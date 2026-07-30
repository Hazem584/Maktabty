import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maktabty/core/routes/app_routes.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/auth/domain/validation/auth_validator.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_state.dart';
import 'package:maktabty/features/auth/presentation/pages/create_account_screen_body.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FToast _toast = FToast();
  bool _toastReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_toastReady) {
      _toast.init(context);
      _toastReady = true;
    }
  }

  void _goToLogin(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.login);
    }
  }

  void _submit() {
    final result = AuthValidator.registration(
      fullName: _fullNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
    if (!result.isValid) {
      _showToast(context.localizeValidation(result.error!));
      return;
    }
    final input = result.value!;
    context.read<AuthCubit>().register(
      fullName: input.fullName,
      email: input.email,
      password: input.password,
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          _showToast(
            context.localizeFailure(
              state.failure,
              fallback: context.l10n.registrationFailed,
            ),
          );
        }

        if (state.status == AuthStatus.authenticated) {
          _showToast(context.l10n.createAccountSuccess);
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
            child: CreateAccountScreenBody(
              onBackToLogin: () => _goToLogin(context),
              fullNameController: _fullNameController,
              emailController: _emailController,
              passwordController: _passwordController,
              confirmPasswordController: _confirmPasswordController,
              onSubmit: _submit,
              isLoading: isLoading,
            ),
          ),
        );
      },
    );
  }

  void _showToast(String message) {
    if (!_toastReady) return;
    final isWindows =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;
    if (!isWindows) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
    _toast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(message, style: const TextStyle(color: Colors.white)),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
