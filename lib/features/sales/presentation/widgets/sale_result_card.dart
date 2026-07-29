import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';

class SaleResultCard extends StatelessWidget {
  final SaleEntity sale;

  const SaleResultCard({super.key, required this.sale});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.saleCreatedTitle, style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s),
          Text(
            '${context.l10n.idLabel}: ${_shortId(sale.id)}',
            style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            '${context.l10n.totalLabel}: \$${sale.totalAmount.toStringAsFixed(2)}',
            style: textTheme.titleMedium?.copyWith(color: colorScheme.primary),
          ),
          const SizedBox(height: AppSpacing.m),
          Text(context.l10n.itemsLabel, style: textTheme.titleSmall),
          const SizedBox(height: AppSpacing.s),
          if (sale.items.isEmpty)
            Text(
              context.l10n.noItemsAvailable,
              style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            )
          else
            ...sale.items.map((item) {
              final name = item.product?.name ?? context.l10n.itemLabel;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '$name x${item.quantity}',
                        style: textTheme.bodySmall,
                      ),
                    ),
                    Text(
                      '\$${item.lineTotal.toStringAsFixed(2)}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  String _shortId(String id) {
    if (id.length <= 8) return id;
    return id.substring(0, 8);
  }
}
