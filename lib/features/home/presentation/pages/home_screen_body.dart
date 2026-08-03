import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/routes/app_routes.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_loading.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/features/home/presentation/widgets/home_actions_row.dart';
import 'package:maktabty/features/home/presentation/widgets/home_stats_section.dart';
import 'package:maktabty/features/home/presentation/widgets/sales_list.dart';
import 'package:maktabty/features/home/presentation/widgets/todays_sales_header.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_state.dart';
import 'package:maktabty/features/sales/presentation/cubit/today_sales_cubit.dart';
import 'package:maktabty/features/sales/presentation/cubit/today_sales_state.dart';
import 'package:maktabty/features/sales/presentation/widgets/receipt_preview_sheet.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';
import 'package:maktabty/features/work_hours/presentation/cubit/work_hours_cubit.dart';
import 'package:maktabty/features/work_hours/presentation/cubit/work_hours_state.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.logoutTitle),
          content: Text(context.l10n.logoutConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.l10n.logout),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      context.read<AuthCubit>().logout();
    }
  }

  Future<void> _openReceipt(BuildContext context, SaleEntity sale) async {
    final l10n = context.l10n;
    if (sale.id.isEmpty) {
      AppToast.show(l10n.unableToLoadReceipt);
      return;
    }

    final receipt =
        await _runWithLoading(
          context,
          () => context.read<TodaySalesCubit>().getReceiptForSale(sale.id),
        ).onError((error, stackTrace) {
          final message = error is AppFailure && context.mounted
              ? context.localizeFailure(
                  error,
                  fallback: l10n.unableToLoadReceipt,
                )
              : l10n.unableToLoadReceipt;
          AppToast.show(message);
          return null;
        });

    if (!context.mounted || receipt == null) return;
    if (receipt.receiptNo.isEmpty && receipt.items.isEmpty) {
      AppToast.show(l10n.unableToLoadReceipt);
      return;
    }
    ReceiptPreviewSheet.show(context, receipt);
  }

  Future<T?> _runWithLoading<T>(
    BuildContext context,
    Future<T> Function() action,
  ) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const Center(child: AppLoading()),
    );

    try {
      return await action();
    } finally {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = context.select<AuthCubit, bool>(
      (cubit) => cubit.state.user?.role?.trim().toUpperCase() == 'OWNER',
    );
    final productsState = context.watch<ProductsListCubit>().state;
    final todaySalesState = context.watch<TodaySalesCubit>().state;
    final workHoursState = context.watch<WorkHoursCubit>().state;

    final summary = todaySalesState.response?.summary;
    final salesAmountLabel = _formatCurrency(
      summary?.totalAmount,
      placeholder:
          todaySalesState.status == TodaySalesStatus.loading &&
              todaySalesState.response == null
          ? '--'
          : null,
    );
    final ordersLabel = _formatCount(
      todaySalesState.response?.data.length,
      placeholder:
          todaySalesState.status == TodaySalesStatus.loading &&
              todaySalesState.response == null
          ? '--'
          : null,
    );
    final itemsSoldLabel = _formatCount(
      summary?.itemsCount,
      placeholder:
          todaySalesState.status == TodaySalesStatus.loading &&
              todaySalesState.response == null
          ? '--'
          : null,
    );
    final workHoursLabel = _formatHours(
      _totalMinutes(workHoursState),
      placeholder:
          workHoursState.loadStatus == WorkHoursStatus.loading &&
              workHoursState.items.isEmpty
          ? '--'
          : null,
    );

    final productsLabel = _formatCount(
      productsState.total,
      placeholder:
          productsState.status == ProductsListStatus.loading &&
              productsState.products.isEmpty
          ? '--'
          : null,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.dashboard,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout),
                tooltip: context.l10n.logout,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          HomeActionsRow(
            onAddProduct: () {
              Navigator.of(context).pushNamed(AppRoutes.addProduct).then((
                result,
              ) {
                if (result == true && context.mounted) {
                  context.read<ProductsListCubit>().refresh();
                }
              });
            },
            onSellProduct: () {
              Navigator.of(context).pushNamed(AppRoutes.sellProduct).then((_) {
                if (context.mounted) {
                  context.read<ProductsListCubit>().refresh();
                }
              });
            },
            onAddWorkHours: () {
              Navigator.of(context).pushNamed(AppRoutes.addWorkHours);
            },
          ),
          if (isOwner) ...[
            const SizedBox(height: AppSpacing.m),
            Text(
              context.l10n.procurementAndStock,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s),
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.suppliers),
                  icon: const Icon(Icons.business_outlined),
                  label: Text(context.l10n.suppliers),
                ),
                FilledButton.tonalIcon(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.purchases),
                  icon: const Icon(Icons.inventory_outlined),
                  label: Text(context.l10n.purchases),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.stockMovements),
                  icon: const Icon(Icons.swap_vert),
                  label: Text(context.l10n.stockMovements),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.l),
          HomeStatsSection(
            items: [
              HomeStatItem(
                title: context.l10n.salesToday,
                value: salesAmountLabel,
                subtitle: context.l10n.total,
              ),
              HomeStatItem(
                title: context.l10n.ordersToday,
                value: ordersLabel,
                subtitle: context.l10n.orders,
              ),
              HomeStatItem(
                title: context.l10n.itemsSold,
                value: itemsSoldLabel,
                subtitle: context.l10n.items,
              ),
              HomeStatItem(
                title: context.l10n.products,
                value: productsLabel,
                subtitle: context.l10n.inInventory,
              ),
              HomeStatItem(
                title: context.l10n.workHours,
                value: workHoursLabel,
                subtitle: context.l10n.today,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const TodaysSalesHeader(),
          const SizedBox(height: AppSpacing.m),
          BlocBuilder<TodaySalesCubit, TodaySalesState>(
            builder: (context, state) {
              if (state.status == TodaySalesStatus.loading &&
                  state.response == null) {
                return const Center(child: AppLoading());
              }

              if (state.status == TodaySalesStatus.failure &&
                  state.response == null) {
                return Text(
                  context.localizeFailure(
                    state.failure,
                    fallback: context.l10n.unableToLoadSales,
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                );
              }

              final sales = state.response?.data ?? [];
              if (sales.isEmpty) {
                return Text(
                  context.l10n.noSalesToday,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                );
              }

              return SalesList(
                sales: sales,
                onSaleTap: (sale) => _openReceipt(context, sale),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double? value, {String? placeholder}) {
    if (value == null) return placeholder ?? '\$0.00';
    return '\$${value.toStringAsFixed(2)}';
  }

  String _formatCount(int? value, {String? placeholder}) {
    if (value == null) return placeholder ?? '0';
    return value.toString();
  }

  String _formatHours(int minutes, {String? placeholder}) {
    if (placeholder != null) return placeholder;
    final hours = minutes / 60.0;
    return hours.toStringAsFixed(1);
  }

  int _totalMinutes(WorkHoursState state) {
    if (state.items.isEmpty) return 0;
    return state.items.fold<int>(0, (sum, item) => sum + item.totalMinutes);
  }
}
