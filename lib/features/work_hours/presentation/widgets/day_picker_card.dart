import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';

class DayPickerCard extends StatelessWidget {
  final String dateLabel;
  final VoidCallback onPick;

  const DayPickerCard({
    super.key,
    required this.dateLabel,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.l),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
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
                Text(context.l10n.selectDay, style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  dateLabel,
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onPick,
            child: Text(context.l10n.pick),
          ),
        ],
      ),
    );
  }
}
