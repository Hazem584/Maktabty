import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';

class SalesSummaryCard extends StatelessWidget {
  final double totalSales;
  final int itemsSold;

  const SalesSummaryCard({
    super.key,
    required this.totalSales,
    required this.itemsSold,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.totalSalesLabel, style: textTheme.bodySmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '\$${totalSales.toStringAsFixed(2)}',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(context.l10n.itemsSold, style: textTheme.bodySmall),
              const SizedBox(height: AppSpacing.xs),
              Text('$itemsSold ${context.l10n.items}',
                  style: textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}
