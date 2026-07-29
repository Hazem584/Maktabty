import 'dart:io';

import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($message)';
}

class ApiExceptions {
  const ApiExceptions._();

  static ApiException fromDio(DioException error) {
    final statusCode = error.response?.statusCode;
    final messageFromServer = _messageFromResponse(error.response?.data);

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown &&
            error.error is SocketException) {
      return const ApiException(
        'No internet connection. Please try again.',
      );
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const ApiException('Request timed out. Please try again.');
    }

    if (statusCode == 401) {
      return ApiException('Unauthorized', statusCode: statusCode);
    }

    if (messageFromServer != null && messageFromServer.isNotEmpty) {
      return ApiException(messageFromServer, statusCode: statusCode);
    }

    return ApiException('Something went wrong. Please try again.',
        statusCode: statusCode);
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
