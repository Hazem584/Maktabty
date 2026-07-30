import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/routes/app_routes.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/auth/domain/validation/auth_validator.dart';
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
    final result = AuthValidator.login(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!result.isValid) {
      AppToast.show(context.localizeValidation(result.error!));
      return;
    }
    final input = result.value!;
    context.read<AuthCubit>().login(
      email: input.email,
      password: input.password,
    );
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
          previous.failure != current.failure,
      listener: (context, state) {
        if (state.status == AuthStatus.failure) {
          AppToast.show(
            context.localizeFailure(
              state.failure,
              fallback: context.l10n.signInFailed,
            ),
          );
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
