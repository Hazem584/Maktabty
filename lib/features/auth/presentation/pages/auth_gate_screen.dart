import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/widgets/app_startup_splash.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_state.dart';
import 'package:maktabty/features/auth/presentation/pages/login_screen.dart';
import 'package:maktabty/features/home/presentation/pages/home_screen.dart';

class AuthGateScreen extends StatefulWidget {
  final Widget authenticatedChild;

  const AuthGateScreen({
    super.key,
    this.authenticatedChild = const HomeScreen(),
  });

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  static const Duration _minimumSplashDuration = Duration(milliseconds: 1400);

  bool _authBootstrapResolved = false;
  bool _splashCompleted = false;
  Timer? _splashTimer;

  @override
  void initState() {
    super.initState();
    _splashTimer = Timer(_minimumSplashDuration, () {
      if (!mounted) return;
      setState(() {
        _splashCompleted = true;
      });
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.failure != current.failure,
      listener: (context, state) {
        if (!_authBootstrapResolved &&
            state.status != AuthStatus.initial &&
            state.status != AuthStatus.loading) {
          _authBootstrapResolved = true;
        }
      },
      builder: (context, state) {
        final authBootstrapResolved =
            _authBootstrapResolved ||
            (state.status != AuthStatus.initial &&
                state.status != AuthStatus.loading);
        if (!_splashCompleted || !authBootstrapResolved) {
          return const AppStartupSplash();
        }

        if (state.status == AuthStatus.loading) {
          return const AppStartupSplash();
        }

        if (state.status == AuthStatus.authenticated) {
          return widget.authenticatedChild;
        }

        if (state.status == AuthStatus.startupFailure) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off_outlined, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      context.localizeFailure(
                        state.failure,
                        fallback: context.l10n.unableToVerifySession,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () =>
                          context.read<AuthCubit>().retryInitialization(),
                      child: Text(context.l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const LoginScreen();
      },
    );
  }
}
