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
}
