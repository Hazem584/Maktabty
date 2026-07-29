import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/reports/domain/entities/monthly_report.dart';

class DailyBreakdownList extends StatelessWidget {
  final List<DailyBreakdownEntity> items;
  final ValueChanged<DailyBreakdownEntity>? onItemTap;

  const DailyBreakdownList({super.key, required this.items, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(
        context.l10n.noBreakdownDataYet,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.outline,
        ),
      );
    }

    return Column(
      children: items.map((item) {
        final card = Ink(
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadii.l),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 18),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.date,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${context.l10n.orders}: ${item.orders}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${item.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        );

        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.s),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadii.l),
              onTap: onItemTap == null ? null : () => onItemTap?.call(item),
              child: card,
            ),
          ),
        );
      }).toList(),
    );
  }
}
