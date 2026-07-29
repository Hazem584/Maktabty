import 'package:flutter/material.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';

class PaymentSelectionSheet extends StatefulWidget {
  final double? total;
  final PaymentMethod method;
  final double? paidAmount;
  final double? cashAmount;
  final double? cardAmount;
  final ValueChanged<PaymentMethod> onMethodChanged;
  final ValueChanged<double?> onPaidChanged;
  final ValueChanged<double?> onCashChanged;
  final ValueChanged<double?> onCardChanged;
  final VoidCallback onConfirm;

  const PaymentSelectionSheet({
    super.key,
    required this.total,
    required this.method,
    required this.paidAmount,
    required this.cashAmount,
    required this.cardAmount,
    required this.onMethodChanged,
    required this.onPaidChanged,
    required this.onCashChanged,
    required this.onCardChanged,
    required this.onConfirm,
  });

  @override
  State<PaymentSelectionSheet> createState() => _PaymentSelectionSheetState();
}

class _PaymentSelectionSheetState extends State<PaymentSelectionSheet> {
  late final TextEditingController _paidController;
  late final TextEditingController _cashController;
  late final TextEditingController _cardController;

  @override
  void initState() {
    super.initState();
    _paidController = TextEditingController(
      text: _formatValue(widget.paidAmount),
    );
    _cashController = TextEditingController(
      text: _formatValue(widget.cashAmount),
    );
    _cardController = TextEditingController(
      text: _formatValue(widget.cardAmount),
    );

    _applyAutoFillIfNeeded();
  }

  @override
  void dispose() {
    _paidController.dispose();
    _cashController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PaymentSelectionSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.method != oldWidget.method) {
      _paidController.clear();
      _cashController.clear();
      _cardController.clear();
      _applyAutoFillIfNeeded();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.l,
          right: AppSpacing.l,
          top: AppSpacing.l,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.l,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.paymentTitle, style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.s),
            if (widget.total != null) ...[
              Text(
                '${l10n.totalLabel}: ${_formatCurrency(widget.total!)}',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.s),
            ],
            Text(l10n.paymentMethodLabel, style: textTheme.bodySmall),
            const SizedBox(height: AppSpacing.s),
            SegmentedButton<PaymentMethod>(
              segments: [
                ButtonSegment(
                  value: PaymentMethod.cash,
                  label: Text(l10n.cashPayment),
                ),
                ButtonSegment(
                  value: PaymentMethod.card,
                  label: Text(l10n.cardPayment),
                ),
                ButtonSegment(
                  value: PaymentMethod.mixed,
                  label: Text(l10n.mixedPayment),
                ),
              ],
              selected: {widget.method},
              onSelectionChanged: (value) {
                if (value.isEmpty) return;
                widget.onMethodChanged(value.first);
              },
            ),
            const SizedBox(height: AppSpacing.m),
            if (widget.method == PaymentMethod.cash) ...[
              TextField(
                controller: _paidController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(labelText: l10n.paidAmountLabel),
                onChanged: (value) => widget.onPaidChanged(_parse(value)),
              ),
              if (_discountValue != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${l10n.discountLabel}: ${_formatCurrency(_discountValue!)}',
                  style: textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.s),
            ],
            if (widget.method == PaymentMethod.mixed) ...[
              TextField(
                controller: _cashController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(labelText: l10n.cashAmountLabel),
                onChanged: (value) => widget.onCashChanged(_parse(value)),
              ),
              const SizedBox(height: AppSpacing.s),
              TextField(
                controller: _cardController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(labelText: l10n.cardAmountLabel),
                onChanged: (value) => widget.onCardChanged(_parse(value)),
              ),
              if (_discountValue != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${l10n.discountLabel}: ${_formatCurrency(_discountValue!)}',
                  style: textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.s),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: widget.onConfirm,
                child: Text(l10n.confirmPayment),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatValue(double? value) {
    if (value == null) return '';
    return value.toStringAsFixed(2);
  }

  void _applyAutoFillIfNeeded() {
    if (widget.method != PaymentMethod.cash) return;
    if (widget.total == null) return;
    if (_paidController.text.trim().isNotEmpty) return;
    final totalText = widget.total!.toStringAsFixed(2);
    _paidController.text = totalText;
    widget.onPaidChanged(widget.total);
  }

  double? get _discountValue {
    if (widget.total == null) return null;
    switch (widget.method) {
      case PaymentMethod.cash:
        if (widget.paidAmount == null) return null;
        final diff = widget.total! - widget.paidAmount!;
        return diff > 0 ? diff : null;
      case PaymentMethod.mixed:
        if (widget.cashAmount == null || widget.cardAmount == null) {
          return null;
        }
        final diff = widget.total! - (widget.cashAmount! + widget.cardAmount!);
        return diff > 0 ? diff : null;
      case PaymentMethod.card:
        return null;
    }
  }

  double? _parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }

  String _formatCurrency(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }
}
