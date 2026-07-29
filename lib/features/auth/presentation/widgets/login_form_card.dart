import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/auth/presentation/widgets/app_text_field.dart';
import 'package:maktabty/features/auth/presentation/widgets/primary_button.dart';

class LoginFormCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final bool isLoading;

  const LoginFormCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.l),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            hintText: context.l10n.emailAddress,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            controller: emailController,
            enabled: !isLoading,
          ),
          const SizedBox(height: AppSpacing.m),
          AppTextField(
            hintText: context.l10n.password,
            icon: Icons.lock_outline,
            obscureText: true,
            textInputAction: TextInputAction.done,
            controller: passwordController,
            enabled: !isLoading,
            onSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: AppSpacing.s),
          PrimaryButton(
            label: context.l10n.signIn,
            onPressed: onSubmit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
