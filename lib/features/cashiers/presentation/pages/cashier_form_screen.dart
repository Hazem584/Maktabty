import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/features/cashiers/domain/entities/cashier_entity.dart';
import 'package:maktabty/features/cashiers/presentation/cubit/cashier_form_cubit.dart';

class CashierFormScreen extends StatelessWidget {
  final CashierEntity? cashier;
  const CashierFormScreen({super.key, this.cashier});

  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => sl<CashierFormCubit>(), child: _CashierFormView(cashier: cashier));
}

class _CashierFormView extends StatefulWidget {
  final CashierEntity? cashier;
  const _CashierFormView({this.cashier});
  @override
  State<_CashierFormView> createState() => _CashierFormViewState();
}

class _CashierFormViewState extends State<_CashierFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.cashier?.fullName);
    _email = TextEditingController(text: widget.cashier?.email);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    final cubit = context.read<CashierFormCubit>();
    final existing = widget.cashier;
    if (existing == null) {
      cubit.create(fullName: _name.text.trim(), email: _email.text.trim().toLowerCase(), password: _password.text);
    } else {
      cubit.update(existing: existing, fullName: _name.text, email: _email.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final creating = widget.cashier == null;
    return BlocConsumer<CashierFormCubit, CashierFormState>(
      listener: (context, state) {
        if (state.status == CashierFormStatus.success) {
          _password.clear();
          _confirmPassword.clear();
          AppToast.show(creating ? context.l10n.cashierCreatedSuccess : context.l10n.cashierUpdatedSuccess);
          Navigator.of(context).pop(state.cashier);
        } else if (state.status == CashierFormStatus.failure) {
          AppToast.show(
            state.failure is ConflictFailure
                ? context.l10n.duplicateCashierEmail
                : context.localizeFailure(
                    state.failure,
                    notFoundFallback: context.l10n.cashierUnavailable,
                    fallback: context.l10n.cashierSaveFailed,
                  ),
          );
        }
      },
      builder: (context, state) {
        final busy = state.status == CashierFormStatus.submitting;
        return Scaffold(
          appBar: AppBar(title: Text(creating ? context.l10n.addCashier : context.l10n.editCashier)),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.l),
              children: [
                TextFormField(controller: _name, enabled: !busy, textInputAction: TextInputAction.next, decoration: InputDecoration(labelText: context.l10n.fullName, prefixIcon: const Icon(Icons.badge_outlined)), validator: (value) => value?.trim().isEmpty != false ? context.l10n.requiredField : null),
                const SizedBox(height: AppSpacing.m),
                TextFormField(controller: _email, enabled: !busy, keyboardType: TextInputType.emailAddress, textInputAction: creating ? TextInputAction.next : TextInputAction.done, decoration: InputDecoration(labelText: context.l10n.emailAddress, prefixIcon: const Icon(Icons.email_outlined)), validator: (value) { final text = value?.trim() ?? ''; if (text.isEmpty) return context.l10n.requiredField; return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text) ? null : context.l10n.invalidEmail; }, onFieldSubmitted: creating ? null : (_) => _submit()),
                if (creating) ...[
                  const SizedBox(height: AppSpacing.m),
                  TextFormField(controller: _password, enabled: !busy, obscureText: true, textInputAction: TextInputAction.next, decoration: InputDecoration(labelText: context.l10n.password, prefixIcon: const Icon(Icons.lock_outline)), validator: (value) { final text = value ?? ''; if (text.isEmpty) return context.l10n.requiredField; return text.length < 8 ? context.l10n.passwordTooShort : null; }),
                  const SizedBox(height: AppSpacing.m),
                  TextFormField(controller: _confirmPassword, enabled: !busy, obscureText: true, textInputAction: TextInputAction.done, decoration: InputDecoration(labelText: context.l10n.confirmPassword, prefixIcon: const Icon(Icons.lock_reset)), validator: (value) => value != _password.text ? context.l10n.passwordsDoNotMatch : null, onFieldSubmitted: (_) => _submit()),
                ],
                const SizedBox(height: AppSpacing.l),
                FilledButton(onPressed: busy ? null : _submit, child: Text(busy ? context.l10n.saving : context.l10n.save)),
              ],
            ),
          ),
        );
      },
    );
  }
}
