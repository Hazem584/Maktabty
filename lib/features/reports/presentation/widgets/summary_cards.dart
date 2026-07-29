import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';

class SummaryCards extends StatelessWidget {
  final double totalSalesAmount;
  final int totalOrders;
  final int totalItemsSold;

  const SummaryCards({
    super.key,
    required this.totalSalesAmount,
    required this.totalOrders,
    required this.totalItemsSold,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        _SummaryCard(
          title: context.l10n.totalSalesLabel,
          value: '\$${totalSalesAmount.toStringAsFixed(2)}',
          accent: colorScheme.primary,
        ),
        const SizedBox(height: AppSpacing.s),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: context.l10n.totalOrders,
                value: '$totalOrders',
                accent: colorScheme.secondary,
              ),
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: _SummaryCard(
                title: context.l10n.itemsSold,
                value: '$totalItemsSold',
                accent: colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color accent;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
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
          Text(title, style: textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(color: accent),
          ),
        ],
      ),
    );
  }
}
