import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/routes/app_routes.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_state.dart';
import 'package:maktabty/features/auth/presentation/pages/login_screen_body.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _openCreateAccount(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.createAccount);
  }

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      AppToast.show(context.l10n.enterEmailPassword);
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      AppToast.show(context.l10n.invalidEmail);
      return;
    }
    if (password.length < 8) {
      AppToast.show(context.l10n.passwordTooShort);
      return;
    }

    context.read<AuthCubit>().login(email: email, password: password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.message != current.message,
      listener: (context, state) {
        if (state.status == AuthStatus.failure) {
          final rawMessage = state.message ?? context.l10n.signInFailed;
          final lower = rawMessage.toLowerCase();
          final message = lower.contains('invalid email or password')
              ? context.l10n.invalidEmailOrPassword
              : lower.contains('request timed out')
                  ? context.l10n.requestTimedOut
                  : lower.contains('no internet')
                      ? context.l10n.noInternet
                      : rawMessage;
          AppToast.show(message);
        }

        if (state.status == AuthStatus.authenticated) {
          AppToast.show(context.l10n.signInSuccess);
          Future.delayed(const Duration(milliseconds: 350), () {
            if (!mounted) return;
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
          });
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return Scaffold(
          body: SafeArea(
            child: LoginScreenBody(
              onCreateAccount: () => _openCreateAccount(context),
              emailController: _emailController,
              passwordController: _passwordController,
              onSubmit: _submit,
              isLoading: isLoading,
            ),
          ),
        );
      },
    );
  }
}
