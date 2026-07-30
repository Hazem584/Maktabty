import 'dart:async';

import 'package:dio/dio.dart';
import 'package:maktabty/core/network/auth_session_manager.dart';
import 'package:maktabty/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _refreshDio;
  final AuthSessionManager _sessionManager;

  Completer<String>? _refreshCompleter;

  AuthInterceptor({
    required this._tokenStorage,
    required this._refreshDio,
    required this._sessionManager,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuth'] == true ||
        _isPublicAuthEndpoint(options.path)) {
      handler.next(options);
      return;
    }

    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldAttemptRefresh(err)) {
      handler.next(err);
      return;
    }

    try {
      final token = await _refreshToken();
      final response = await _retryRequest(err.requestOptions, token);
      handler.resolve(response);
    } on _InvalidRefreshException {
      await _expireSession();
      handler.next(err);
    } on _TemporaryRefreshException catch (error) {
      handler.next(
        DioException(
          requestOptions: err.requestOptions,
          error: error,
          message: error.message,
          type: DioExceptionType.unknown,
        ),
      );
    } on DioException catch (retryError) {
      if (retryError.response?.statusCode == 401) {
        await _expireSession();
      }
      handler.next(retryError);
    } catch (error) {
      handler.next(
        DioException(
          requestOptions: err.requestOptions,
          error: error,
          message: 'Unable to retry the request after refreshing the session.',
        ),
      );
    }
  }

  bool _shouldAttemptRefresh(DioException err) {
    final statusCode = err.response?.statusCode;
    if (statusCode != 401) return false;

    final options = err.requestOptions;
    if ((options.extra['authRetryCount'] as int? ?? 0) >= 1) return false;
    if (options.extra['skipAuth'] == true) return false;

    if (_isPublicAuthEndpoint(options.path)) {
      return false;
    }

    return true;
  }

  Future<String> _refreshToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String>();
    final completer = _refreshCompleter!;
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        throw const _InvalidRefreshException('Missing refresh token.');
      }

      final response = await _refreshDio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(extra: {'skipAuth': true}),
      );

      final tokens = _extractTokens(response.data);
      await _tokenStorage.saveAccessToken(tokens.accessToken);
      if (tokens.refreshToken != null) {
        await _tokenStorage.saveRefreshToken(tokens.refreshToken!);
      }
      completer.complete(tokens.accessToken);
    } on DioException catch (error, stackTrace) {
      final status = error.response?.statusCode;
      if (status == 401 || status == 403) {
        completer.completeError(
          const _InvalidRefreshException('Refresh credentials were rejected.'),
          stackTrace,
        );
      } else {
        completer.completeError(
          const _TemporaryRefreshException(
            'The session could not be refreshed right now. Please retry.',
          ),
          stackTrace,
        );
      }
    } on _InvalidRefreshException catch (error, stackTrace) {
      completer.completeError(error, stackTrace);
    } catch (_, stackTrace) {
      completer.completeError(
        const _TemporaryRefreshException(
          'The refresh response was not valid. Please retry.',
        ),
        stackTrace,
      );
    } finally {
      _refreshCompleter = null;
    }

    return completer.future;
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String token,
  ) {
    final updatedHeaders = Map<String, dynamic>.from(requestOptions.headers)
      ..['Authorization'] = 'Bearer $token';
    final updatedExtra = Map<String, dynamic>.from(requestOptions.extra)
      ..['authRetryCount'] = 1;

    final retryOptions = requestOptions.copyWith(
      headers: updatedHeaders,
      extra: updatedExtra,
    );

    return _refreshDio.fetch(retryOptions);
  }

  _RefreshTokens _extractTokens(dynamic responseData) {
    final root = _asStringMap(responseData);
    if (root == null) {
      throw const _TemporaryRefreshException(
        'The refresh response was not a JSON object.',
      );
    }

    final candidates = <Map<String, dynamic>>[
      root,
      ?_asStringMap(root['data']),
      ?_asStringMap(root['tokens']),
      ?_asStringMap(root['auth']),
    ];

    for (final candidate in candidates) {
      final accessToken = candidate['accessToken'] ?? candidate['access_token'];
      final refreshToken =
          candidate['refreshToken'] ?? candidate['refresh_token'];
      if (accessToken is String && accessToken.trim().isNotEmpty) {
        return _RefreshTokens(
          accessToken.trim(),
          refreshToken is String && refreshToken.trim().isNotEmpty
              ? refreshToken.trim()
              : null,
        );
      }
    }

    throw const _TemporaryRefreshException(
      'The refresh response did not contain an access token.',
    );
  }

  Map<String, dynamic>? _asStringMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      try {
        return Map<String, dynamic>.from(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  bool _isPublicAuthEndpoint(String rawPath) {
    final path =
        Uri.tryParse(rawPath)?.path.toLowerCase() ?? rawPath.toLowerCase();
    return path.endsWith('/auth/login') ||
        path.endsWith('/auth/register') ||
        path.endsWith('/auth/refresh');
  }

  Future<void> _expireSession() async {
    await _tokenStorage.clearAll();
    _sessionManager.notifySessionExpired();
  }
}

class _RefreshTokens {
  final String accessToken;
  final String? refreshToken;

  const _RefreshTokens(this.accessToken, this.refreshToken);
}

class _InvalidRefreshException implements Exception {
  final String message;

  const _InvalidRefreshException(this.message);
}

class _TemporaryRefreshException implements Exception {
  final String message;

  const _TemporaryRefreshException(this.message);

  @override
  String toString() => message;
}
