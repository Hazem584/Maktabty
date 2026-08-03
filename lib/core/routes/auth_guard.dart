import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_state.dart';
import 'package:maktabty/features/auth/presentation/pages/login_screen.dart';
import 'package:maktabty/core/widgets/app_startup_splash.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          return child;
        }
        if (state.status == AuthStatus.initial ||
            state.status == AuthStatus.loading) {
          return const AppStartupSplash();
        }

        return const LoginScreen();
      },
    );
  }
}

class OwnerGuard extends StatelessWidget {
  final Widget child;
  const OwnerGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      if (state.status == AuthStatus.initial || state.status == AuthStatus.loading) {
        return const AppStartupSplash();
      }
      if (state.status != AuthStatus.authenticated) return const LoginScreen();
      if (state.user?.role?.trim().toUpperCase() == 'OWNER') return child;
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(context.l10n.accessDeniedOwner, textAlign: TextAlign.center))),
      );
    });
  }
}
