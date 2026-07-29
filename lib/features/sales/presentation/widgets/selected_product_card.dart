import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';

class SelectedProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onChange;

  const SelectedProductCard({
    super.key,
    required this.product,
    required this.onChange,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(product.name, style: textTheme.titleMedium),
              TextButton(onPressed: onChange, child: Text(context.l10n.change)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.inStock(product.stock),
            style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
          ),
        ],
      ),
    );
  }
}
