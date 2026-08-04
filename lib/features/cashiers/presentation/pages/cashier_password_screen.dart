import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/features/cashiers/domain/entities/cashier_entity.dart';
import 'package:maktabty/features/cashiers/presentation/cubit/cashier_password_cubit.dart';

class CashierPasswordScreen extends StatelessWidget {
  final CashierEntity cashier;
  const CashierPasswordScreen({super.key, required this.cashier});
  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => sl<CashierPasswordCubit>(), child: _CashierPasswordView(cashier: cashier));
}

class _CashierPasswordView extends StatefulWidget {
  final CashierEntity cashier;
  const _CashierPasswordView({required this.cashier});
  @override
  State<_CashierPasswordView> createState() => _CashierPasswordViewState();
}

class _CashierPasswordViewState extends State<_CashierPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.resetPassword),
        content: Text(context.l10n.passwordResetConfirmation),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(context.l10n.resetPassword)),
        ],
      ),
    );
    if (confirmed == true && mounted) context.read<CashierPasswordCubit>().reset(cashierId: widget.cashier.id, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CashierPasswordCubit, CashierPasswordState>(
      listener: (context, state) {
        if (state.status == CashierPasswordStatus.success) {
          _password.clear();
          _confirmation.clear();
          AppToast.show(context.l10n.passwordResetSuccess);
          Navigator.of(context).pop(true);
        } else if (state.status == CashierPasswordStatus.failure) {
          AppToast.show(context.localizeFailure(state.failure, notFoundFallback: context.l10n.cashierUnavailable));
        }
      },
      builder: (context, state) {
        final busy = state.status == CashierPasswordStatus.submitting;
        return Scaffold(
          appBar: AppBar(title: Text(context.l10n.resetPassword)),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.l),
              children: [
                Text(widget.cashier.fullName, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.s),
                Text(context.l10n.passwordResetSessionNotice),
                const SizedBox(height: AppSpacing.l),
                TextFormField(controller: _password, enabled: !busy, obscureText: true, textInputAction: TextInputAction.next, decoration: InputDecoration(labelText: context.l10n.newPassword, prefixIcon: const Icon(Icons.lock_outline)), validator: (value) { final text = value ?? ''; if (text.isEmpty) return context.l10n.requiredField; return text.length < 8 ? context.l10n.passwordTooShort : null; }),
                const SizedBox(height: AppSpacing.m),
                TextFormField(controller: _confirmation, enabled: !busy, obscureText: true, textInputAction: TextInputAction.done, decoration: InputDecoration(labelText: context.l10n.confirmNewPassword, prefixIcon: const Icon(Icons.lock_reset)), validator: (value) => value != _password.text ? context.l10n.passwordsDoNotMatch : null, onFieldSubmitted: (_) => _submit()),
                const SizedBox(height: AppSpacing.l),
                FilledButton(onPressed: busy ? null : _submit, child: Text(busy ? context.l10n.saving : context.l10n.resetPassword)),
              ],
            ),
          ),
        );
      },
    );
  }
}
