import 'dart:async';

import 'package:dio/dio.dart';
import 'package:maktabty/core/network/auth_session_manager.dart';
import 'package:maktabty/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _refreshDio;
  final AuthSessionManager _sessionManager;

  Completer<String?>? _refreshCompleter;

  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio refreshDio,
    required AuthSessionManager sessionManager,
  }) : _tokenStorage = tokenStorage,
       _refreshDio = refreshDio,
       _sessionManager = sessionManager;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuth'] == true) {
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

    final token = await _refreshToken();
    if (token == null) {
      await _tokenStorage.clearAll();
      _sessionManager.notifySessionExpired();
      handler.next(err);
      return;
    }

    try {
      final response = await _retryRequest(err.requestOptions, token);
      handler.resolve(response);
    } catch (_) {
      handler.next(err);
    }
  }

  bool _shouldAttemptRefresh(DioException err) {
    final statusCode = err.response?.statusCode;
    if (statusCode != 401) return false;

    final options = err.requestOptions;
    if (options.extra['retry'] == true) return false;
    if (options.extra['skipAuth'] == true) return false;

    final path = options.path.toLowerCase();
    if (path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh')) {
      return false;
    }

    return true;
  }

  Future<String?> _refreshToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String?>();
    final completer = _refreshCompleter!;
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        completer.complete(null);
        return completer.future;
      }

      final response = await _refreshDio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(extra: {'skipAuth': true}),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final accessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];
        if (accessToken is String && accessToken.isNotEmpty) {
          await _tokenStorage.saveAccessToken(accessToken);
        }
        if (newRefreshToken is String && newRefreshToken.isNotEmpty) {
          await _tokenStorage.saveRefreshToken(newRefreshToken);
        }
        completer.complete(accessToken is String ? accessToken : null);
      } else {
        completer.complete(null);
      }
    } catch (_) {
      completer.complete(null);
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
      ..['retry'] = true;

    final retryOptions = requestOptions.copyWith(
      headers: updatedHeaders,
      extra: updatedExtra,
    );

    return _refreshDio.fetch(retryOptions);
  }
}
