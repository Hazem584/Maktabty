import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/routes/app_routes.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_loading.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/features/cashiers/presentation/cubit/cashier_details_cubit.dart';

class CashierDetailsScreen extends StatelessWidget {
  final String cashierId;
  const CashierDetailsScreen({super.key, required this.cashierId});

  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => sl<CashierDetailsCubit>()..load(cashierId), child: const _CashierDetailsView());
}

class _CashierDetailsView extends StatelessWidget {
  const _CashierDetailsView();

  Future<void> _changeStatus(BuildContext context, bool isActive) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isActive ? context.l10n.enableCashier : context.l10n.disableCashier),
        content: Text(isActive ? context.l10n.enableCashierConfirmation : context.l10n.disableCashierConfirmation),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(isActive ? context.l10n.enableCashier : context.l10n.disableCashier)),
        ],
      ),
    );
    if (confirmed == true && context.mounted) context.read<CashierDetailsCubit>().setStatus(isActive);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CashierDetailsCubit, CashierDetailsState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action || previous.failure != current.failure,
      listener: (context, state) {
        if (state.status == CashierDetailsStatus.failure) {
          AppToast.show(context.localizeFailure(state.failure, notFoundFallback: context.l10n.cashierUnavailable));
        } else if (state.action == CashierDetailsAction.enabled) {
          AppToast.show(context.l10n.cashierEnabledSuccess);
        } else if (state.action == CashierDetailsAction.disabled) {
          AppToast.show(context.l10n.cashierDisabledSuccess);
        }
      },
      builder: (context, state) {
        final cashier = state.cashier;
        final busy = state.status == CashierDetailsStatus.submitting;
        if (state.status == CashierDetailsStatus.loading && cashier == null) return Scaffold(appBar: AppBar(title: Text(context.l10n.cashierDetails)), body: const Center(child: AppLoading()));
        if (cashier == null) {
          return Scaffold(appBar: AppBar(title: Text(context.l10n.cashierDetails)), body: Center(child: Padding(padding: const EdgeInsets.all(AppSpacing.l), child: Column(mainAxisSize: MainAxisSize.min, children: [Text(context.localizeFailure(state.failure, notFoundFallback: context.l10n.cashierUnavailable), textAlign: TextAlign.center), const SizedBox(height: AppSpacing.s), FilledButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.backToHome))]))));
        }
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) {},
          child: Scaffold(
            appBar: AppBar(title: Text(context.l10n.cashierDetails)),
            body: ListView(
              padding: const EdgeInsets.all(AppSpacing.l),
              children: [
                Center(child: CircleAvatar(radius: 36, child: Icon(cashier.isActive ? Icons.badge_outlined : Icons.person_off_outlined, size: 36))),
                const SizedBox(height: AppSpacing.m),
                Text(cashier.fullName, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                Text(cashier.email, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.m),
                Center(child: Chip(avatar: Icon(cashier.isActive ? Icons.check_circle : Icons.block, size: 18), label: Text(cashier.isActive ? context.l10n.active : context.l10n.disabled))),
                const SizedBox(height: AppSpacing.l),
                FilledButton.tonalIcon(
                  onPressed: busy ? null : () async { final updated = await Navigator.of(context).pushNamed(AppRoutes.cashierEdit, arguments: cashier); if (updated != null && context.mounted) context.read<CashierDetailsCubit>().load(cashier.id); },
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(context.l10n.editCashier),
                ),
                const SizedBox(height: AppSpacing.s),
                OutlinedButton.icon(
                  onPressed: busy ? null : () => Navigator.of(context).pushNamed(AppRoutes.cashierPassword, arguments: cashier),
                  icon: const Icon(Icons.password_outlined),
                  label: Text(context.l10n.resetPassword),
                ),
                const SizedBox(height: AppSpacing.s),
                FilledButton.icon(
                  onPressed: busy ? null : () => _changeStatus(context, !cashier.isActive),
                  icon: Icon(cashier.isActive ? Icons.block : Icons.check_circle_outline),
                  label: Text(cashier.isActive ? context.l10n.disableCashier : context.l10n.enableCashier),
                ),
                if (busy) ...[const SizedBox(height: AppSpacing.m), const Center(child: AppLoading())],
              ],
            ),
          ),
        );
      },
    );
  }
}
