import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/widgets/language_selector.dart';
import 'package:maktabty/features/auth/presentation/widgets/auth_header.dart';
import 'package:maktabty/features/auth/presentation/widgets/login_form_card.dart';

class LoginScreenBody extends StatelessWidget {
  final VoidCallback onCreateAccount;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final bool isLoading;

  const LoginScreenBody({
    super.key,
    required this.onCreateAccount,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: LanguageSelector(),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  AuthHeader(
                    icon: Icons.point_of_sale,
                    title: context.l10n.welcomeBackTitle,
                    subtitle: context.l10n.welcomeBackSubtitle,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  LoginFormCard(
                    emailController: emailController,
                    passwordController: passwordController,
                    onSubmit: onSubmit,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: AppSpacing.l),
                  Center(
                    child: TextButton(
                      onPressed: onCreateAccount,
                      child: Text(context.l10n.createAccount),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
