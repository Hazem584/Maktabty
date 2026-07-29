import 'dart:io';

import 'package:dio/dio.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

enum ApiErrorKind { unauthorized, network, timeout, server, parsing, other }

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final ApiErrorKind kind;

  const ApiException(
    this.message, {
    this.statusCode,
    this.kind = ApiErrorKind.other,
  });

  bool get isRecoverable =>
      kind == ApiErrorKind.network ||
      kind == ApiErrorKind.timeout ||
      kind == ApiErrorKind.server;

  bool get isUnauthorized => kind == ApiErrorKind.unauthorized;

  @override
  String toString() => 'ApiException($message)';
}

class ApiExceptions {
  const ApiExceptions._();

  static ApiException fromParsing(DataParsingException error) {
    return const ApiException(
      'The server returned an unexpected response. Please try again.',
      kind: ApiErrorKind.parsing,
    );
  }

  static ApiException fromDio(DioException error) {
    final statusCode = error.response?.statusCode;
    final messageFromServer = _messageFromResponse(error.response?.data);

    if (error.type == DioExceptionType.connectionTimeout) {
      return const ApiException(
        'Connection to the API server timed out. Please try again.',
        kind: ApiErrorKind.timeout,
      );
    }

    if (error.type == DioExceptionType.sendTimeout) {
      return const ApiException(
        'The request could not be sent in time. Please try again.',
        kind: ApiErrorKind.timeout,
      );
    }

    if (error.type == DioExceptionType.receiveTimeout) {
      return const ApiException(
        'The API server did not respond in time. Please try again.',
        kind: ApiErrorKind.timeout,
      );
    }

    if (error.type == DioExceptionType.badCertificate) {
      return const ApiException(
        'Could not establish a secure connection to the API server.',
        kind: ApiErrorKind.network,
      );
    }

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown &&
            error.error is SocketException) {
      final detail = '${error.error} ${error.message}'.toLowerCase();
      if (detail.contains('failed host lookup') ||
          detail.contains('network is unreachable') ||
          detail.contains('no route to host')) {
        return const ApiException(
          'No internet connection. Please try again.',
          kind: ApiErrorKind.network,
        );
      }
      return const ApiException(
        'The API server is unreachable. Please try again later.',
        kind: ApiErrorKind.network,
      );
    }

    if (statusCode == 401) {
      return ApiException(
        'Unauthorized',
        statusCode: statusCode,
        kind: ApiErrorKind.unauthorized,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return ApiException(
        'The server is temporarily unavailable. Please try again.',
        statusCode: statusCode,
        kind: ApiErrorKind.server,
      );
    }

    if (messageFromServer != null && messageFromServer.isNotEmpty) {
      return ApiException(messageFromServer, statusCode: statusCode);
    }

    return ApiException(
      'Something went wrong. Please try again.',
      statusCode: statusCode,
    );
  }

  static String? _messageFromResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String) {
        return message;
      }
      if (message is List) {
        return message.whereType<String>().join('\n');
      }
    }
    return null;
  }
}
