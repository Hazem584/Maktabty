import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_loading.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/reports/presentation/cubit/reports_cubit.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';
import 'package:maktabty/features/sales/presentation/cubit/today_sales_cubit.dart';
import 'package:maktabty/features/sales/presentation/cubit/today_sales_state.dart';
import 'package:maktabty/features/sales/presentation/widgets/empty_sales_state.dart';
import 'package:maktabty/features/sales/presentation/widgets/receipt_preview_sheet.dart';
import 'package:maktabty/features/sales/presentation/widgets/sales_list_item.dart';
import 'package:maktabty/features/sales/presentation/widgets/sales_summary_card.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_cubit.dart';

class SalesByDateScreen extends StatelessWidget {
  final String date;
  final List<SaleEntity>? sales;

  const SalesByDateScreen({super.key, required this.date, this.sales});

  String _requestDate() {
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return date;
    return DateFormat('yyyy-MM-dd').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final providedSales = sales;
    if (providedSales != null) {
      return BlocProvider(
        create: (_) => sl<TodaySalesCubit>(),
        child: _SalesByDateStaticView(date: date, sales: providedSales),
      );
    }

    final requestDate = _requestDate();
    return BlocProvider(
      create: (_) => sl<TodaySalesCubit>()..load(date: requestDate),
      child: _SalesByDateRemoteView(date: date, requestDate: requestDate),
    );
  }
}

class _SalesByDateStaticView extends StatefulWidget {
  final String date;
  final List<SaleEntity> sales;

  const _SalesByDateStaticView({required this.date, required this.sales});

  @override
  State<_SalesByDateStaticView> createState() => _SalesByDateStaticViewState();
}

class _SalesByDateStaticViewState extends State<_SalesByDateStaticView> {
  late List<SaleEntity> _sales;

  @override
  void initState() {
    super.initState();
    _sales = List.of(widget.sales);
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = _dateLabel(context, widget.date);
    final totalSales = _sumTotalSales(_sales);
    final itemsSold = _countItemsSold(_sales);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.sales)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.l),
          children: [
            _DateHeaderCard(
              title: context.l10n.sales,
              subtitle: dateLabel,
              onRefresh: null,
            ),
            const SizedBox(height: AppSpacing.l),
            SalesSummaryCard(totalSales: totalSales, itemsSold: itemsSold),
            const SizedBox(height: AppSpacing.m),
            if (_sales.isEmpty)
              const EmptySalesState()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _sales.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.s),
                itemBuilder: (context, index) {
                  final sale = _sales[index];
                  return SalesListItem(
                    sale: sale,
                    onTap: () => _showSaleActions(
                      context,
                      sale,
                      reportDate: DateTime.tryParse(widget.date),
                      onDeleted: () {
                        setState(() {
                          _sales.removeWhere((item) => item.id == sale.id);
                        });
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _SalesByDateRemoteView extends StatelessWidget {
  final String date;
  final String requestDate;

  const _SalesByDateRemoteView({required this.date, required this.requestDate});

  @override
  Widget build(BuildContext context) {
    final dateLabel = _dateLabel(context, date);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.sales)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.l),
          children: [
            _DateHeaderCard(
              title: context.l10n.sales,
              subtitle: dateLabel,
              onRefresh: () =>
                  context.read<TodaySalesCubit>().load(date: requestDate),
            ),
            const SizedBox(height: AppSpacing.l),
            BlocBuilder<TodaySalesCubit, TodaySalesState>(
              builder: (context, state) {
                if (state.status == TodaySalesStatus.loading &&
                    state.response == null) {
                  return const Center(child: AppLoading());
                }

                if (state.status == TodaySalesStatus.failure) {
                  return _ErrorCard(
                    message: state.message == null
                        ? context.l10n.unableToLoadSales
                        : context.localizeAppError(state.message!),
                    onRetry: () =>
                        context.read<TodaySalesCubit>().load(date: requestDate),
                  );
                }

                final response = state.response;
                if (response == null) {
                  return const EmptySalesState();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SalesSummaryCard(
                      totalSales: response.summary.totalAmount,
                      itemsSold: response.summary.itemsCount,
                    ),
                    const SizedBox(height: AppSpacing.m),
                    if (response.data.isEmpty)
                      const EmptySalesState()
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: response.data.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.s),
                        itemBuilder: (context, index) {
                          final sale = response.data[index];
                          return SalesListItem(
                            sale: sale,
                            onTap: () => _showSaleActions(
                              context,
                              sale,
                              reportDate: sale.createdAt,
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DateHeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onRefresh;

  const _DateHeaderCard({
    required this.title,
    required this.subtitle,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.l),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          if (onRefresh != null)
            TextButton(onPressed: onRefresh, child: Text(context.l10n.refresh)),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadii.m),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.error),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colorScheme.error),
            ),
          ),
          TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
        ],
      ),
    );
  }
}

enum _SaleAction { print, delete }

String _dateLabel(BuildContext context, String date) {
  final parsed = DateTime.tryParse(date);
  if (parsed == null) return date;
  final locale = Localizations.localeOf(context).languageCode;
  return DateFormat.yMMMd(locale).format(parsed);
}

int _countItemsSold(List<SaleEntity> sales) {
  return sales.fold<int>(
    0,
    (sum, sale) => sum + sale.items.fold(0, (s, item) => s + item.quantity),
  );
}

double _sumTotalSales(List<SaleEntity> sales) {
  return sales.fold<double>(0, (sum, sale) => sum + sale.totalAmount);
}

Future<void> _showSaleActions(
  BuildContext context,
  SaleEntity sale, {
  DateTime? reportDate,
  VoidCallback? onDeleted,
}) async {
  final l10n = context.l10n;
  final action = await showModalBottomSheet<_SaleAction>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.print_outlined),
              title: Text(l10n.printReceipt),
              onTap: () => Navigator.of(sheetContext).pop(_SaleAction.print),
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(sheetContext).colorScheme.error,
              ),
              title: Text(
                l10n.deleteSale,
                style: TextStyle(
                  color: Theme.of(sheetContext).colorScheme.error,
                ),
              ),
              onTap: () => Navigator.of(sheetContext).pop(_SaleAction.delete),
            ),
            const SizedBox(height: AppSpacing.s),
          ],
        ),
      );
    },
  );

  if (action == _SaleAction.print) {
    await _openReceipt(context, sale);
    return;
  }

  if (action == _SaleAction.delete) {
    if (sale.id.isEmpty) {
      AppToast.show(l10n.somethingWentWrong);
      return;
    }
    final confirmed = await _confirmDeleteSale(context);
    if (!confirmed) return;
    final deleted =
        await _runWithLoading<bool>(context, () async {
          await context.read<TodaySalesCubit>().deleteSale(sale.id);
          return true;
        }).onError((error, stackTrace) {
          final message = error is String ? error : l10n.unableToLoadSales;
          AppToast.show(message);
          return false;
        });
    if (deleted != true) return;
    onDeleted?.call();
    AppToast.show(l10n.saleDeleted);
    _refreshInventoryIfAvailable(context);
    _refreshReportsIfAvailable(context, reportDate ?? sale.createdAt);
  }
}

void _refreshInventoryIfAvailable(BuildContext context) {
  try {
    context.read<ProductsListCubit>().refresh();
  } catch (_) {}
}

void _refreshReportsIfAvailable(BuildContext context, DateTime? date) {
  if (date == null) return;
  try {
    final reportsCubit = context.read<ReportsCubit>();
    reportsCubit.loadMonthly(month: DateTime(date.year, date.month, 1));
  } catch (_) {}
}

Future<bool> _confirmDeleteSale(BuildContext context) async {
  final l10n = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.deleteSaleTitle),
        content: Text(l10n.deleteSaleMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      );
    },
  );
  return result ?? false;
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
        final message = error is String ? error : l10n.unableToLoadReceipt;
        AppToast.show(context.localizeAppError(message));
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
