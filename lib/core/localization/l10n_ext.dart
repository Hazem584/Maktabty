import 'package:flutter/material.dart';
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

  String localizeAppError(String message) {
    return switch (message) {
      'The server returned an unexpected response. Please try again.' =>
        l10n.unexpectedServerResponse,
      'The API server is unreachable. Please try again later.' =>
        l10n.apiServerUnreachable,
      'Connection to the API server timed out. Please try again.' =>
        l10n.apiConnectionTimedOut,
      'The request could not be sent in time. Please try again.' =>
        l10n.requestSendTimedOut,
      'The API server did not respond in time. Please try again.' =>
        l10n.apiResponseTimedOut,
      'Could not establish a secure connection to the API server.' =>
        l10n.apiSecureConnectionFailed,
      'The server is temporarily unavailable. Please try again.' =>
        l10n.backendServerUnavailable,
      _ => message,
    };
  }
}
