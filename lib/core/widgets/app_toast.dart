import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maktabty/core/routes/app_navigator.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';

class AppToast {
  const AppToast._();

  static void show(String message) {
    final context = AppNavigator.key.currentContext;
    final resolved = context == null ? message : _mapMessage(context, message);
    if (_useSnackBarFallback) {
      _showSnackBar(context, resolved);
      return;
    }

    try {
      Fluttertoast.showToast(
        msg: resolved,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    } catch (_) {
      _showSnackBar(context, resolved);
    }
  }

  static bool get _useSnackBarFallback {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;
  }

  static void _showSnackBar(BuildContext? context, String message) {
    if (context == null) {
      debugPrint(message);
      return;
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      debugPrint(message);
      return;
    }

    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
        ),
      );
  }

  static String _mapMessage(BuildContext context, String message) {
    if (message.isEmpty) return message;

    // Skip mapping if already Arabic.
    final hasArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(message);
    if (hasArabic) return message;

    final lower = message.trim().toLowerCase();

    if (lower == 'internal server error' || lower == 'internal server error.') {
      return context.l10n.internalServerError;
    }
    if (lower.contains('unauthorized')) {
      return context.l10n.unauthorized;
    }
    if (lower.contains('no internet connection')) {
      return context.l10n.noInternet;
    }
    if (lower.contains('request timed out')) {
      return context.l10n.requestTimedOut;
    }
    if (lower.contains('api server is unreachable')) {
      return context.l10n.apiServerUnreachable;
    }
    if (lower.contains('connection to the api server timed out')) {
      return context.l10n.apiConnectionTimedOut;
    }
    if (lower.contains('request could not be sent in time')) {
      return context.l10n.requestSendTimedOut;
    }
    if (lower.contains('api server did not respond in time')) {
      return context.l10n.apiResponseTimedOut;
    }
    if (lower.contains('secure connection to the api server')) {
      return context.l10n.apiSecureConnectionFailed;
    }
    if (lower.contains('server is temporarily unavailable')) {
      return context.l10n.backendServerUnavailable;
    }
    if (lower.contains('something went wrong')) {
      return context.l10n.somethingWentWrong;
    }
    if (lower.contains('invalid email or password')) {
      return context.l10n.invalidEmailOrPassword;
    }
    if (lower.contains("don't have permission") ||
        lower.contains('do not have permission') ||
        lower.contains('permission')) {
      return context.l10n.noPermission;
    }
    if (lower.contains('product not found')) {
      return context.l10n.productNotFound;
    }
    if (lower.contains('product has sales') ||
        lower.contains('cannot be deleted')) {
      return context.l10n.productHasSalesCannotBeDeleted;
    }
    if (lower.contains('password') &&
        (lower.contains('longer than or equal') ||
            lower.contains('at least') ||
            lower.contains('min'))) {
      return context.l10n.passwordTooShort;
    }
    if (lower.contains('email') &&
        (lower.contains('must be an email') ||
            lower.contains('valid email') ||
            lower.contains('invalid email'))) {
      return context.l10n.invalidEmail;
    }

    return message;
  }
}
