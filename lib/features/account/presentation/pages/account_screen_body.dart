import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/features/account/presentation/widgets/account_form_card.dart';

class AccountScreenBody extends StatefulWidget {
  const AccountScreenBody({super.key});

  @override
  State<AccountScreenBody> createState() => _AccountScreenBodyState();
}

class _AccountScreenBodyState extends State<AccountScreenBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    AppToast.show(context.l10n.changesSavedDemo);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadii.m),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                context.l10n.accountSettings,
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                context.l10n.updateEmailPassword,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AccountFormCard(
            emailController: _emailController,
            passwordController: _passwordController,
            obscurePassword: _obscurePassword,
            onTogglePassword: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          const SizedBox(height: AppSpacing.l),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveChanges,
              child: Text(context.l10n.saveChanges),
            ),
          ),
        ],
      ),
    );
  }
}
