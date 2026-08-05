import 'package:dio/dio.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/network/auth_session_manager.dart';
import 'package:maktabty/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  static const String sessionGenerationKey = 'authSessionGeneration';

  final TokenStorage _tokenStorage;
  final Dio _refreshDio;
  final AuthSessionManager _sessionManager;

  final Map<int, Future<String>> _refreshOperations = {};

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

    final generation = _sessionManager.currentGeneration;
    options.extra[sessionGenerationKey] = generation;
    final accessToken = await _tokenStorage.getAccessToken();
    if (!_sessionManager.isCurrent(generation)) {
      handler.next(options);
      return;
    }
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final expectedGeneration = _requestGeneration(err.requestOptions);
    if (_isAccountDisabled(err) &&
        !_isPublicAuthEndpoint(err.requestOptions.path)) {
      if (expectedGeneration != null) {
        await _expireSession(
          expectedGeneration,
          const AccountDisabledFailure(),
        );
      }
      handler.next(err);
      return;
    }

    if (!_shouldAttemptRefresh(err)) {
      handler.next(err);
      return;
    }

    if (expectedGeneration == null) {
      handler.next(err);
      return;
    }

    try {
      final token = await _refreshToken(expectedGeneration);
      if (!_sessionManager.isCurrent(expectedGeneration)) {
        handler.next(err);
        return;
      }
      final response = await _retryRequest(err.requestOptions, token);
      if (!_sessionManager.isCurrent(expectedGeneration)) {
        handler.next(err);
        return;
      }
      handler.resolve(response);
    } on _InvalidRefreshException {
      await _expireSession(
        expectedGeneration,
        const UnauthorizedFailure(),
      );
      handler.next(err);
    } on _AccountDisabledRefreshException catch (error) {
      final invalidated = await _expireSession(
        expectedGeneration,
        const AccountDisabledFailure(),
      );
      handler.next(invalidated ? error.error : err);
    } on _StaleSessionException {
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
      if (_isAccountDisabled(retryError)) {
        await _expireSession(
          expectedGeneration,
          const AccountDisabledFailure(),
        );
      } else if (retryError.response?.statusCode == 401) {
        await _expireSession(
          expectedGeneration,
          const UnauthorizedFailure(),
        );
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
    final expectedGeneration = _requestGeneration(options);
    if (expectedGeneration == null ||
        !_sessionManager.isCurrent(expectedGeneration)) {
      return false;
    }

    if (_isPublicAuthEndpoint(options.path)) {
      return false;
    }

    return true;
  }

  Future<String> _refreshToken(int expectedGeneration) {
    final existing = _refreshOperations[expectedGeneration];
    if (existing != null) return existing;

    late final Future<String> operation;
    operation = _performRefresh(expectedGeneration).whenComplete(() {
      if (identical(_refreshOperations[expectedGeneration], operation)) {
        _refreshOperations.remove(expectedGeneration);
      }
    });
    _refreshOperations[expectedGeneration] = operation;
    return operation;
  }

  Future<String> _performRefresh(int expectedGeneration) async {
    try {
      if (!_sessionManager.isCurrent(expectedGeneration)) {
        throw const _StaleSessionException();
      }
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (!_sessionManager.isCurrent(expectedGeneration)) {
        throw const _StaleSessionException();
      }
      if (refreshToken == null || refreshToken.isEmpty) {
        throw const _InvalidRefreshException('Missing refresh token.');
      }

      final response = await _refreshDio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(extra: {'skipAuth': true}),
      );

      final tokens = _extractTokens(response.data);
      final saved = await _sessionManager.updateSessionIfCurrent(
        expectedGeneration: expectedGeneration,
        updateSession: () async {
          await _tokenStorage.saveAccessToken(tokens.accessToken);
          if (tokens.refreshToken != null) {
            await _tokenStorage.saveRefreshToken(tokens.refreshToken!);
          }
        },
      );
      if (!saved) {
        throw const _StaleSessionException();
      }
      _sessionManager.notifySessionRefreshed(expectedGeneration);
      return tokens.accessToken;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (_isAccountDisabled(error)) {
        throw _AccountDisabledRefreshException(error);
      }
      if (status == 401 || status == 403) {
        throw const _InvalidRefreshException(
          'Refresh credentials were rejected.',
        );
      }
      throw const _TemporaryRefreshException(
        'The session could not be refreshed right now. Please retry.',
      );
    } on _InvalidRefreshException {
      rethrow;
    } on _StaleSessionException {
      rethrow;
    } catch (_) {
      throw const _TemporaryRefreshException(
        'The refresh response was not valid. Please retry.',
      );
    }
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

  int? _requestGeneration(RequestOptions options) {
    final value = options.extra[sessionGenerationKey];
    return value is int ? value : null;
  }

  bool _isAccountDisabled(DioException error) {
    if (error.response?.statusCode != 403) return false;
    final data = error.response?.data;
    if (data is! Map) return false;
    return data['code'] == 'ACCOUNT_DISABLED';
  }

  Future<bool> _expireSession(
    int expectedGeneration,
    AppFailure failure,
  ) {
    return _sessionManager.invalidateSessionIfCurrent(
      expectedGeneration: expectedGeneration,
      clearSession: _tokenStorage.clearAll,
      failure: failure,
    );
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

class _AccountDisabledRefreshException implements Exception {
  final DioException error;

  const _AccountDisabledRefreshException(this.error);
}

class _StaleSessionException implements Exception {
  const _StaleSessionException();
}

class _TemporaryRefreshException implements Exception {
  final String message;

  const _TemporaryRefreshException(this.message);

  @override
  String toString() => message;
}
