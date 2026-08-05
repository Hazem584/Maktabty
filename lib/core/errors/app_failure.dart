import 'package:equatable/equatable.dart';
import 'package:maktabty/core/validation/validation_result.dart';

enum FailureCode {
  network,
  secureConnection,
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  unauthorized,
  forbidden,
  accountDisabled,
  validation,
  invalidCredentials,
  notFound,
  conflict,
  stockConflict,
  idempotencyConflict,
  archivedProduct,
  localDatabase,
  parsing,
  server,
  unknown,
}

abstract class AppFailure extends Equatable implements Exception {
  final FailureCode code;
  final int? statusCode;
  final String? serverMessage;

  const AppFailure({required this.code, this.statusCode, this.serverMessage});

  bool get isTemporary =>
      code == FailureCode.network ||
      code == FailureCode.secureConnection ||
      code == FailureCode.connectionTimeout ||
      code == FailureCode.sendTimeout ||
      code == FailureCode.receiveTimeout ||
      code == FailureCode.server;

  bool get isUnauthorized => code == FailureCode.unauthorized;

  @override
  List<Object?> get props => [code, statusCode, serverMessage];
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure({super.code = FailureCode.network, super.serverMessage})
    : assert(
        code == FailureCode.network || code == FailureCode.secureConnection,
      );
}

final class TimeoutFailure extends AppFailure {
  const TimeoutFailure(FailureCode code)
    : assert(
        code == FailureCode.connectionTimeout ||
            code == FailureCode.sendTimeout ||
            code == FailureCode.receiveTimeout,
      ),
      super(code: code);
}

final class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure({super.statusCode = 401})
    : super(code: FailureCode.unauthorized);
}

final class ForbiddenFailure extends AppFailure {
  const ForbiddenFailure({super.statusCode = 403})
    : super(code: FailureCode.forbidden);
}

final class AccountDisabledFailure extends AppFailure {
  const AccountDisabledFailure({super.statusCode = 403})
    : super(code: FailureCode.accountDisabled);
}

final class ValidationFailure extends AppFailure {
  final ValidationKey? validationKey;

  const ValidationFailure({
    super.code = FailureCode.validation,
    super.statusCode,
    super.serverMessage,
    this.validationKey,
  });

  @override
  List<Object?> get props => [...super.props, validationKey];
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure({super.statusCode = 404, super.serverMessage})
    : super(code: FailureCode.notFound);
}

final class ConflictFailure extends AppFailure {
  const ConflictFailure({super.statusCode = 409, super.serverMessage})
    : super(code: FailureCode.conflict);
}

final class StockConflictFailure extends AppFailure {
  final String? productId;
  final int? requestedQuantity;
  final int? availableQuantity;

  const StockConflictFailure({
    this.productId,
    this.requestedQuantity,
    this.availableQuantity,
    super.serverMessage,
  }) : super(code: FailureCode.stockConflict);

  @override
  List<Object?> get props => [
    ...super.props,
    productId,
    requestedQuantity,
    availableQuantity,
  ];
}

final class IdempotencyConflictFailure extends AppFailure {
  const IdempotencyConflictFailure({super.serverMessage})
    : super(code: FailureCode.idempotencyConflict);
}

final class ArchivedProductFailure extends AppFailure {
  final String? productId;

  const ArchivedProductFailure({this.productId})
    : super(code: FailureCode.archivedProduct);

  @override
  List<Object?> get props => [...super.props, productId];
}

final class LocalDatabaseFailure extends AppFailure {
  const LocalDatabaseFailure() : super(code: FailureCode.localDatabase);
}

final class ParsingFailure extends AppFailure {
  const ParsingFailure() : super(code: FailureCode.parsing);
}

final class ServerFailure extends AppFailure {
  const ServerFailure({super.statusCode}) : super(code: FailureCode.server);
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure() : super(code: FailureCode.unknown);
}
