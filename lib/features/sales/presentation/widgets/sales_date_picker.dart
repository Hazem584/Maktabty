import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';

class SalesDatePicker extends StatelessWidget {
  final String dateLabel;
  final VoidCallback onPick;

  const SalesDatePicker({
    super.key,
    required this.dateLabel,
    required this.onPick,
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
        children: [
          const Icon(Icons.calendar_today),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.selectDate, style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(dateLabel, style: textTheme.bodyMedium),
              ],
            ),
          ),
          IconButton(
            onPressed: onPick,
            icon: Icon(Icons.calendar_today, color: colorScheme.primary),
            tooltip: context.l10n.pickDate,
          ),
        ],
      ),
    );
  }
}
