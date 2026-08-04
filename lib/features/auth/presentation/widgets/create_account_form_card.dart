import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/auth/presentation/widgets/app_text_field.dart';
import 'package:maktabty/features/auth/presentation/widgets/primary_button.dart';

class CreateAccountFormCard extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController storeNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSubmit;
  final bool isLoading;

  const CreateAccountFormCard({
    super.key,
    required this.fullNameController,
    required this.storeNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
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
            hintText: context.l10n.fullName,
            icon: Icons.badge_outlined,
            textInputAction: TextInputAction.next,
            controller: fullNameController,
            enabled: !isLoading,
          ),
          const SizedBox(height: AppSpacing.m),
          AppTextField(
            hintText: context.l10n.storeName,
            icon: Icons.storefront_outlined,
            textInputAction: TextInputAction.next,
            controller: storeNameController,
            enabled: !isLoading,
          ),
          const SizedBox(height: AppSpacing.m),
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
            textInputAction: TextInputAction.next,
            controller: passwordController,
            enabled: !isLoading,
          ),
          const SizedBox(height: AppSpacing.m),
          AppTextField(
            hintText: context.l10n.confirmPassword,
            icon: Icons.lock_reset,
            obscureText: true,
            textInputAction: TextInputAction.done,
            controller: confirmPasswordController,
            enabled: !isLoading,
            onSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: AppSpacing.l),
          PrimaryButton(
            label: context.l10n.createAccount,
            onPressed: onSubmit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
