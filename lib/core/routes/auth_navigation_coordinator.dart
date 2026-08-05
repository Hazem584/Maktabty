import 'dart:async';

import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/routes/app_navigator.dart';
import 'package:maktabty/core/routes/app_routes.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_state.dart';

class AuthNavigationCoordinator {
  const AuthNavigationCoordinator._();

  static void handle(AuthState state) {
    final navigator = AppNavigator.key.currentState;
    final navigatorContext = AppNavigator.key.currentContext;

    if (state.status == AuthStatus.unauthenticated &&
        state.failure != null &&
        navigatorContext != null) {
      AppToast.show(navigatorContext.localizeFailure(state.failure));
    }

    if ((state.status == AuthStatus.authenticated ||
            state.status == AuthStatus.unauthenticated) &&
        navigator != null &&
        navigator.canPop()) {
      unawaited(
        navigator.pushNamedAndRemoveUntil(
          AppRoutes.root,
          (route) => false,
        ),
      );
    }
  }
}
