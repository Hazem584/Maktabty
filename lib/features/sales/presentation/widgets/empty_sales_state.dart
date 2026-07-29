import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';

class EmptySalesState extends StatelessWidget {
  const EmptySalesState({super.key});

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
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 40,
            color: colorScheme.outline,
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            context.l10n.noSalesForDay,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
          ),
        ],
      ),
    );
  }
}
