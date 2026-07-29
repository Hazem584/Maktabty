import 'package:flutter/material.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/routes/app_routes.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/core/services/receipt_printer_service.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';

class ReceiptPreviewSheet extends StatelessWidget {
  final ReceiptEntity receipt;

  const ReceiptPreviewSheet({super.key, required this.receipt});

  static Future<void> show(BuildContext context, ReceiptEntity receipt) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ReceiptPreviewSheet(receipt: receipt),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final printer = sl<ReceiptPrinterService>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.receiptTitle, style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.s),
            Text('${l10n.receiptNoLabel}: ${receipt.receiptNo}'),
            if (receipt.receiptId.isNotEmpty)
              Text('${l10n.receiptIdLabel}: ${receipt.receiptId}'),
            if (_displayDateTime(receipt) != null)
              Text(_displayDateTime(receipt)!),
            if (_displayDateTime(receipt) == null && receipt.createdAt != null)
              Text(_formatDate(receipt.createdAt!)),
            if ((receipt.currency ?? '').isNotEmpty)
              Text('${l10n.currencyLabel}: ${receipt.currency}'),
            const SizedBox(height: AppSpacing.s),
            Text(receipt.store.name, style: textTheme.titleSmall),
            if (receipt.store.address?.isNotEmpty == true)
              Text(receipt.store.address!),
            if (receipt.store.phone?.isNotEmpty == true)
              Text('${l10n.phoneLabel}: ${receipt.store.phone}'),
            if (receipt.store.taxNumber?.isNotEmpty == true)
              Text('${l10n.taxNumberLabel}: ${receipt.store.taxNumber}'),
            if (receipt.cashier != null) ...[
              const SizedBox(height: AppSpacing.s),
              Text(l10n.cashierLabel(receipt.cashier!.fullName)),
            ],
            const Divider(height: AppSpacing.l),
            ...receipt.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: textTheme.bodyMedium),
                          Text(
                            '${item.qty} x ${_formatCurrency(item.unitPrice, receipt.currency)}',
                            style: textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _formatCurrency(item.lineTotal, receipt.currency),
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: AppSpacing.l),
            if (receipt.distinctItems != null || receipt.totalQty != null) ...[
              _TotalRow(
                label: l10n.itemsLabel,
                value: receipt.distinctItems?.toString() ?? '--',
              ),
              _TotalRow(
                label: l10n.quantityLabel,
                value: receipt.totalQty?.toString() ?? '--',
              ),
              const SizedBox(height: AppSpacing.s),
            ],
            _TotalRow(
              label: l10n.subtotalLabel,
              value: _formatCurrency(receipt.totals.subtotal, receipt.currency),
            ),
            _TotalRow(
              label: l10n.discountLabel,
              value: _formatCurrency(receipt.totals.discount, receipt.currency),
            ),
            _TotalRow(
              label: l10n.taxLabel,
              value: _formatCurrency(receipt.totals.tax, receipt.currency),
            ),
            _TotalRow(
              label: l10n.totalLabel,
              value: _formatCurrency(receipt.totals.total, receipt.currency),
              isEmphasis: true,
            ),
            if (receipt.payment != null) ...[
              const SizedBox(height: AppSpacing.s),
              _TotalRow(
                label: l10n.paymentMethodLabel,
                value: _paymentLabel(context, receipt.payment!.method),
              ),
              if (receipt.payment!.paidAmount != null)
                _TotalRow(
                  label: l10n.paidAmountLabel,
                  value: _formatCurrency(
                    receipt.payment!.paidAmount!,
                    receipt.currency,
                  ),
                ),
              if (receipt.payment!.cashAmount != null)
                _TotalRow(
                  label: l10n.cashAmountLabel,
                  value: _formatCurrency(
                    receipt.payment!.cashAmount!,
                    receipt.currency,
                  ),
                ),
              if (receipt.payment!.cardAmount != null)
                _TotalRow(
                  label: l10n.cardAmountLabel,
                  value: _formatCurrency(
                    receipt.payment!.cardAmount!,
                    receipt.currency,
                  ),
                ),
              if (receipt.payment!.changeAmount != null)
                _TotalRow(
                  label: l10n.changeLabel,
                  value: _formatCurrency(
                    receipt.payment!.changeAmount!,
                    receipt.currency,
                  ),
                ),
            ],
            if (receipt.footerLines.isNotEmpty) ...[
              const Divider(height: AppSpacing.l),
              ...receipt.footerLines.map(
                (line) => Text(line, style: textTheme.bodySmall),
              ),
            ],
            const SizedBox(height: AppSpacing.m),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      try {
                        await printer.printPos(receipt);
                      } catch (_) {
                        AppToast.show(l10n.printFailed);
                      }
                    },
                    child: Text(l10n.printPos),
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      try {
                        await printer.printPdf(receipt);
                      } catch (_) {
                        AppToast.show(l10n.printFailed);
                      }
                    },
                    child: Text(l10n.printPdf),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.printerSettings),
                    child: Text(l10n.printerSettings),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      try {
                        await printer.sharePdf(receipt);
                      } catch (_) {
                        AppToast.show(l10n.printFailed);
                      }
                    },
                    child: Text(l10n.sharePdf),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double value, String? currency) {
    final code = currency?.trim();
    final amount = value.toStringAsFixed(2);
    if (code == null || code.isEmpty) {
      return '\$$amount';
    }
    return '$code $amount';
  }

  String? _displayDateTime(ReceiptEntity receipt) {
    final date = receipt.displayDate?.trim();
    final time = receipt.displayTime?.trim();
    if (date == null || date.isEmpty) return null;
    if (time == null || time.isEmpty) return date;
    return '$date $time';
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.year}-${_two(local.month)}-${_two(local.day)} ${_two(local.hour)}:${_two(local.minute)}';
  }

  String _two(int value) => value.toString().padLeft(2, '0');

  String _paymentLabel(BuildContext context, PaymentMethod method) {
    final l10n = context.l10n;
    switch (method) {
      case PaymentMethod.cash:
        return l10n.cashPayment;
      case PaymentMethod.card:
        return l10n.cardPayment;
      case PaymentMethod.mixed:
        return l10n.mixedPayment;
    }
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isEmphasis;

  const _TotalRow({
    required this.label,
    required this.value,
    this.isEmphasis = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = isEmphasis
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
