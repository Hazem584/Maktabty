import 'package:flutter/material.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/validation/validation_result.dart';
import 'package:maktabty/l10n/gen/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    if (localizations == null) {
      throw FlutterError(
        'AppLocalizations not found in context. '
        'Make sure you have added AppLocalizations.delegate to your MaterialApp.',
      );
    }
    return localizations;
  }

  String localizeFailure(
    AppFailure? failure, {
    String? notFoundFallback,
    String? fallback,
  }) {
    if (failure == null) return fallback ?? l10n.somethingWentWrong;
    if (failure is ValidationFailure && failure.validationKey != null) {
      return localizeValidation(failure.validationKey!);
    }
    return switch (failure.code) {
      FailureCode.network => l10n.noInternet,
      FailureCode.secureConnection => l10n.apiSecureConnectionFailed,
      FailureCode.connectionTimeout => l10n.apiConnectionTimedOut,
      FailureCode.sendTimeout => l10n.requestSendTimedOut,
      FailureCode.receiveTimeout => l10n.apiResponseTimedOut,
      FailureCode.unauthorized => l10n.sessionExpired,
      FailureCode.forbidden => l10n.noPermission,
      FailureCode.invalidCredentials => l10n.invalidEmailOrPassword,
      FailureCode.notFound =>
        notFoundFallback ??
            _localizeServerMessage(failure.serverMessage) ??
            l10n.somethingWentWrong,
      FailureCode.validation || FailureCode.conflict =>
        _localizeServerMessage(failure.serverMessage) ??
            fallback ??
            l10n.somethingWentWrong,
      FailureCode.parsing => l10n.unexpectedServerResponse,
      FailureCode.server => l10n.backendServerUnavailable,
      FailureCode.unknown => fallback ?? l10n.somethingWentWrong,
    };
  }

  String localizeValidation(ValidationKey key) {
    return switch (key) {
      ValidationKey.requiredFields => l10n.missingFields,
      ValidationKey.invalidEmail => l10n.invalidEmail,
      ValidationKey.passwordTooShort => l10n.passwordTooShort,
      ValidationKey.passwordsDoNotMatch => l10n.passwordsDoNotMatch,
      ValidationKey.nameTooShort => l10n.nameTooShort,
      ValidationKey.invalidPrice => l10n.enterValidPrice,
      ValidationKey.invalidStock => l10n.enterValidStock,
      ValidationKey.invalidCode => l10n.invalidProductCode,
      ValidationKey.atLeastOneSaleItem => l10n.addAtLeastOneItem,
      ValidationKey.invalidQuantity => l10n.invalidSaleQuantity,
      ValidationKey.duplicateSaleItem => l10n.duplicateSaleItem,
      ValidationKey.invalidUnitPrice => l10n.enterValidUnitPrice,
      ValidationKey.enterPaidAmount => l10n.enterPaidAmount,
      ValidationKey.enterCashAmount => l10n.enterCashAmount,
      ValidationKey.enterCardAmount => l10n.enterCardAmount,
      ValidationKey.paymentTotalMismatch => l10n.paymentTotalMismatch,
      ValidationKey.paidAmountTooLow => l10n.paidAmountTooLow,
      ValidationKey.invalidShiftTimes => l10n.fixInvalidShiftTimes,
      ValidationKey.overlappingShifts => l10n.overlappingShifts,
    };
  }

  String? _localizeServerMessage(String? message) {
    if (message == null || message.isEmpty) return null;
    final normalized = message.toLowerCase();
    if (normalized.contains('invalid email or password')) {
      return l10n.invalidEmailOrPassword;
    }
    if (normalized.contains('product has sales') ||
        normalized.contains('cannot be deleted')) {
      return l10n.productHasSalesCannotBeDeleted;
    }
    if (normalized.contains('password') &&
        (normalized.contains('at least') ||
            normalized.contains('minimum') ||
            normalized.contains('longer than or equal'))) {
      return l10n.passwordTooShort;
    }
    if (normalized.contains('invalid email') ||
        normalized.contains('must be an email')) {
      return l10n.invalidEmail;
    }
    return message;
  }
}
