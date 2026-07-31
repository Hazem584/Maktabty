import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/features/sales/domain/entities/local_sale_entity.dart';
import 'package:maktabty/features/sales/presentation/cubit/offline_sales_cubit.dart';
import 'package:maktabty/features/sales/presentation/cubit/offline_sales_state.dart';
import 'package:maktabty/features/sales/presentation/widgets/receipt_preview_sheet.dart';

class OfflineSalesScreen extends StatelessWidget {
  const OfflineSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.offlineSalesTitle),
        actions: [
          BlocBuilder<OfflineSalesCubit, OfflineSalesState>(
            buildWhen: (previous, current) =>
                previous.isSyncing != current.isSyncing,
            builder: (context, state) {
              return IconButton(
                onPressed: state.isSyncing
                    ? null
                    : () => context.read<OfflineSalesCubit>().syncNow(),
                tooltip: context.l10n.syncNow,
                icon: state.isSyncing
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<OfflineSalesCubit, OfflineSalesState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => context.read<OfflineSalesCubit>().syncNow(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.l),
              children: [
                if (state.otherOwnerUnsyncedCount > 0) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.m),
                      child: Row(
                        children: [
                          const Icon(Icons.person_off_outlined),
                          const SizedBox(width: AppSpacing.m),
                          Expanded(
                            child: Text(
                              context.l10n.previousAccountPendingSales(
                                state.otherOwnerUnsyncedCount,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                ],
                if (state.isSyncing) ...[
                  const LinearProgressIndicator(),
                  const SizedBox(height: AppSpacing.m),
                  Text(context.l10n.syncingSales),
                  const SizedBox(height: AppSpacing.m),
                ],
                if (state.sales.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xl,
                    ),
                    child: Center(child: Text(context.l10n.noOfflineSales)),
                  )
                else
                  ...state.sales.map(
                    (sale) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.m),
                      child: _LocalSaleCard(sale: sale),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LocalSaleCard extends StatelessWidget {
  final LocalSaleEntity sale;

  const _LocalSaleCard({required this.sale});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.temporarySaleReference(
                      sale.temporaryReference,
                    ),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(
                  avatar: Icon(
                    _statusIcon(sale.syncStatus),
                    size: 18,
                    color: _statusColor(colors, sale.syncStatus),
                  ),
                  label: Text(_statusLabel(context, sale.syncStatus)),
                ),
              ],
            ),
            Text(
              '${MaterialLocalizations.of(context).formatMediumDate(sale.occurredAt.toLocal())} '
              '${TimeOfDay.fromDateTime(sale.occurredAt.toLocal()).format(context)}',
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              context.l10n.localSaleItemsAndTotal(
                sale.items.length,
                sale.totalAmount.toStringAsFixed(2),
              ),
            ),
            if (sale.syncAttempts > 0)
              Text(context.l10n.syncAttempts(sale.syncAttempts)),
            if (sale.syncStatus == LocalSaleSyncStatus.stockConflict) ...[
              const SizedBox(height: AppSpacing.s),
              Text(
                context.l10n.stockConflictDetails(
                  sale.conflictRequestedQuantity ?? 0,
                  sale.conflictAvailableQuantity ?? 0,
                ),
                style: TextStyle(color: colors.error),
              ),
            ] else if (sale.syncStatus ==
                LocalSaleSyncStatus.idempotencyConflict) ...[
              const SizedBox(height: AppSpacing.s),
              Text(
                context.l10n.idempotencyConflictHelp,
                style: TextStyle(color: colors.error),
              ),
            ] else if (sale.syncStatus == LocalSaleSyncStatus.failed) ...[
              const SizedBox(height: AppSpacing.s),
              Text(
                context.l10n.saleSyncFailed,
                style: TextStyle(color: colors.error),
              ),
            ],
            if (sale.syncStatus != LocalSaleSyncStatus.synced) ...[
              const SizedBox(height: AppSpacing.s),
              Text(
                context.l10n.pendingReceiptNotice,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.m),
            Wrap(
              spacing: AppSpacing.s,
              children: [
                if (sale.syncStatus.canRetry)
                  OutlinedButton.icon(
                    onPressed: () async {
                      final retried = await context
                          .read<OfflineSalesCubit>()
                          .retry(sale.clientSaleId);
                      if (!context.mounted) return;
                      AppToast.show(
                        retried
                            ? context.l10n.saleQueuedForSync
                            : context.l10n.unableToRetrySale,
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(context.l10n.retrySync),
                  ),
                if (sale.syncStatus == LocalSaleSyncStatus.synced)
                  FilledButton.icon(
                    onPressed: () async {
                      final receipt = await context
                          .read<OfflineSalesCubit>()
                          .loadConfirmedReceipt(sale);
                      if (!context.mounted) return;
                      if (receipt == null) {
                        AppToast.show(context.l10n.unableToLoadReceipt);
                        return;
                      }
                      ReceiptPreviewSheet.show(context, receipt);
                    },
                    icon: const Icon(Icons.receipt_long),
                    label: Text(context.l10n.viewConfirmedReceipt),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(BuildContext context, LocalSaleSyncStatus status) {
    return switch (status) {
      LocalSaleSyncStatus.pending => context.l10n.syncStatusPending,
      LocalSaleSyncStatus.syncing => context.l10n.syncStatusSyncing,
      LocalSaleSyncStatus.synced => context.l10n.syncStatusSynced,
      LocalSaleSyncStatus.failed => context.l10n.syncStatusFailed,
      LocalSaleSyncStatus.stockConflict => context.l10n.syncStatusStockConflict,
      LocalSaleSyncStatus.idempotencyConflict =>
        context.l10n.syncStatusIdempotencyConflict,
    };
  }

  IconData _statusIcon(LocalSaleSyncStatus status) {
    return switch (status) {
      LocalSaleSyncStatus.pending => Icons.schedule,
      LocalSaleSyncStatus.syncing => Icons.sync,
      LocalSaleSyncStatus.synced => Icons.cloud_done,
      LocalSaleSyncStatus.failed => Icons.error_outline,
      LocalSaleSyncStatus.stockConflict => Icons.inventory_outlined,
      LocalSaleSyncStatus.idempotencyConflict => Icons.key_off_outlined,
    };
  }

  Color _statusColor(ColorScheme colors, LocalSaleSyncStatus status) {
    return switch (status) {
      LocalSaleSyncStatus.synced => Colors.green,
      LocalSaleSyncStatus.pending ||
      LocalSaleSyncStatus.syncing => colors.primary,
      _ => colors.error,
    };
  }
}
