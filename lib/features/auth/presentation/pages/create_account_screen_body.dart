import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/widgets/language_selector.dart';
import 'package:maktabty/features/auth/presentation/widgets/auth_header.dart';
import 'package:maktabty/features/auth/presentation/widgets/create_account_form_card.dart';

class CreateAccountScreenBody extends StatelessWidget {
  final VoidCallback onBackToLogin;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSubmit;
  final bool isLoading;

  const CreateAccountScreenBody({
    super.key,
    required this.onBackToLogin,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                    icon: Icons.person_add_alt_1_outlined,
                    title: context.l10n.createAccountTitle,
                    subtitle: context.l10n.createAccountSubtitle,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  CreateAccountFormCard(
                    fullNameController: fullNameController,
                    emailController: emailController,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                    onSubmit: onSubmit,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: AppSpacing.l),
                  Center(
                    child: TextButton(
                      onPressed: onBackToLogin,
                      child: Text(context.l10n.backToLogin),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    context.l10n.termsNotice,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
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
