import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/database/database_exception.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class AppFailureMapper {
  const AppFailureMapper._();

  static AppFailure fromException(Object error) {
    if (error is AppFailure) return error;
    if (error is LocalDatabaseException) {
      return const LocalDatabaseFailure();
    }
    if (error is LocalStockException) {
      return StockConflictFailure(
        productId: error.productId,
        requestedQuantity: error.requested,
        availableQuantity: error.available,
      );
    }
    if (error is DataParsingException || error is FormatException) {
      return const ParsingFailure();
    }
    if (error is TimeoutException) {
      return const TimeoutFailure(FailureCode.receiveTimeout);
    }
    if (error is DioException) return _fromDio(error);
    return const UnknownFailure();
  }

  static AppFailure _fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const TimeoutFailure(FailureCode.connectionTimeout);
      case DioExceptionType.sendTimeout:
        return const TimeoutFailure(FailureCode.sendTimeout);
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure(FailureCode.receiveTimeout);
      case DioExceptionType.transformTimeout:
        return const TimeoutFailure(FailureCode.receiveTimeout);
      case DioExceptionType.badCertificate:
        return const NetworkFailure(code: FailureCode.secureConnection);
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const NetworkFailure();
        }
        return const UnknownFailure();
      case DioExceptionType.cancel:
        return const UnknownFailure();
      case DioExceptionType.badResponse:
        return _fromResponse(error.response);
    }
  }

  static AppFailure _fromResponse(Response<dynamic>? response) {
    final statusCode = response?.statusCode;
    final message = _safeServerMessage(response?.data);

    return switch (statusCode) {
      400 ||
      422 => ValidationFailure(statusCode: statusCode, serverMessage: message),
      401 => const UnauthorizedFailure(),
      403 => const ForbiddenFailure(),
      404 => NotFoundFailure(serverMessage: message),
      409 => ConflictFailure(serverMessage: message),
      final code? when code >= 500 => ServerFailure(statusCode: code),
      _ => const UnknownFailure(),
    };
  }

  static String? _safeServerMessage(dynamic data) {
    final values = <String>[];
    if (data is Map) {
      _addMessage(values, data['message']);
      final errors = data['errors'];
      if (errors is Map) {
        for (final value in errors.values) {
          _addMessage(values, value);
        }
      }
    }

    if (values.isEmpty) return null;
    final joined = values
        .join('\n')
        .replaceAll(RegExp(r'[\x00-\x08\x0B-\x1F]'), '');
    if (joined.length > 500) return '${joined.substring(0, 497)}...';
    return joined;
  }

  static void _addMessage(List<String> target, dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      target.add(value.trim());
    } else if (value is List) {
      for (final item in value) {
        _addMessage(target, item);
      }
    }
  }
}
