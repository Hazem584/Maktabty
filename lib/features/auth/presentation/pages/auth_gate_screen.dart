import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/widgets/app_startup_splash.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_state.dart';
import 'package:maktabty/features/auth/presentation/pages/login_screen.dart';
import 'package:maktabty/features/home/presentation/pages/home_screen.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  static const Duration _minimumSplashDuration = Duration(milliseconds: 1400);

  bool _authBootstrapResolved = false;
  bool _splashCompleted = false;
  Object? _lastToastFailure;
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

        if (state.status == AuthStatus.loading) {
          _lastToastFailure = null;
          return;
        }

        String? message;
        if (state.status == AuthStatus.failure) {
          message = context.localizeFailure(state.failure);
        } else if (state.status == AuthStatus.unauthenticated) {
          message = state.failure == null
              ? null
              : context.localizeFailure(state.failure);
        }

        if (message != null &&
            message.isNotEmpty &&
            state.failure != _lastToastFailure) {
          _lastToastFailure = state.failure;
          AppToast.show(message);
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
          return const HomeScreen();
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
