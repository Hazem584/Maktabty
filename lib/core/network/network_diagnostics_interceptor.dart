import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetworkDiagnosticsInterceptor extends Interceptor {
  static const String _startedAtKey = '_networkDiagnosticStartedAt';
  static final RegExp _sensitiveText = RegExp(
    r'password|token|authorization|secret|credential|cookie',
    caseSensitive: false,
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startedAtKey] = DateTime.now().microsecondsSinceEpoch;
    if (kDebugMode) {
      debugPrint(
        '[HTTP] request method=${options.method} '
        'url=${_redactedUrl(options.uri)}',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint(
        '[HTTP] response method=${response.requestOptions.method} '
        'url=${_redactedUrl(response.requestOptions.uri)} '
        'status=${response.statusCode ?? 'none'} '
        'durationMs=${_durationMs(response.requestOptions)}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final safeMessage = _safeResponseMessage(error.response?.data);
      debugPrint(
        '[HTTP] error method=${error.requestOptions.method} '
        'url=${_redactedUrl(error.requestOptions.uri)} '
        'type=${error.type.name} '
        'status=${error.response?.statusCode ?? 'none'} '
        'durationMs=${_durationMs(error.requestOptions)}'
        '${safeMessage == null ? '' : ' message=$safeMessage'}',
      );
    }
    handler.next(error);
  }

  String _redactedUrl(Uri uri) {
    final redactedQuery = uri.queryParameters.isEmpty
        ? null
        : {for (final key in uri.queryParameters.keys) key: '[redacted]'};
    return uri.replace(userInfo: '', queryParameters: redactedQuery).toString();
  }

  int _durationMs(RequestOptions options) {
    final startedAt = options.extra[_startedAtKey];
    if (startedAt is! int) return -1;
    final elapsedMicros = DateTime.now().microsecondsSinceEpoch - startedAt;
    return elapsedMicros ~/ Duration.microsecondsPerMillisecond;
  }

  String? _safeResponseMessage(dynamic data) {
    if (data is! Map) return null;
    final value = data['message'];
    final message = switch (value) {
      String value => value,
      List value => value.whereType<String>().join(' '),
      _ => null,
    };
    if (message == null ||
        message.isEmpty ||
        message.contains('@') ||
        _sensitiveText.hasMatch(message)) {
      return null;
    }
    final normalized = message.replaceAll(RegExp(r'\s+'), ' ').trim();
    return normalized.length <= 160 ? normalized : normalized.substring(0, 160);
  }
}
