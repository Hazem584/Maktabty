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

  bool _initialized = false;
  bool _authBootstrapResolved = false;
  bool _splashCompleted = false;
  String? _lastToastMessage;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      context.read<AuthCubit>().initialize();
      _initialized = true;
    }
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
          previous.message != current.message,
      listener: (context, state) {
        if (!_authBootstrapResolved &&
            state.status != AuthStatus.initial &&
            state.status != AuthStatus.loading) {
          _authBootstrapResolved = true;
        }

        if (state.status == AuthStatus.loading) {
          _lastToastMessage = null;
          return;
        }

        String? message;
        if (state.status == AuthStatus.failure) {
          message = _mapAuthMessage(context, state.message);
        } else if (state.status == AuthStatus.unauthenticated) {
          message = _mapAuthMessage(context, state.message);
        }

        if (message != null &&
            message.isNotEmpty &&
            message != _lastToastMessage) {
          _lastToastMessage = message;
          AppToast.show(message);
        }
      },
      builder: (context, state) {
        if (!_splashCompleted || !_authBootstrapResolved) {
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
                      _mapAuthMessage(context, state.message) ??
                          context.l10n.unableToVerifySession,
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

  String? _mapAuthMessage(BuildContext context, String? rawMessage) {
    if (rawMessage == null || rawMessage.isEmpty) {
      return null;
    }

    final lower = rawMessage.toLowerCase();
    if (lower.contains('invalid email or password')) {
      return context.l10n.invalidEmailOrPassword;
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
    if (rawMessage == 'Session expired. Please sign in again.') {
      return context.l10n.sessionExpired;
    }
    if (lower.contains('request timed out')) {
      return context.l10n.requestTimedOut;
    }
    if (lower.contains('no internet')) {
      return context.l10n.noInternet;
    }
    if (lower.contains('unauthorized')) {
      return context.l10n.unauthorized;
    }
    if (lower.contains('unable to verify your session')) {
      return context.l10n.unableToVerifySession;
    }

    return rawMessage;
  }
}
