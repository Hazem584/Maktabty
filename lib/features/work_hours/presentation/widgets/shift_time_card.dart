import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/work_hours/presentation/widgets/time_picker_row.dart';

class ShiftTimeCard extends StatelessWidget {
  final String title;
  final bool worked;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool isValid;
  final ValueChanged<bool> onToggleWorked;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;

  const ShiftTimeCard({
    super.key,
    required this.title,
    required this.worked,
    required this.startTime,
    required this.endTime,
    required this.isValid,
    required this.onToggleWorked,
    required this.onPickStart,
    required this.onPickEnd,
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
              Text(title, style: textTheme.titleMedium),
              Switch(
                value: worked,
                onChanged: onToggleWorked,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            context.l10n.workedThisShift,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
          ),
          const SizedBox(height: AppSpacing.m),
          Opacity(
            opacity: worked ? 1 : 0.5,
            child: Column(
              children: [
                TimePickerRow(
                  label: context.l10n.start,
                  time: startTime,
                  onPick: onPickStart,
                  enabled: worked,
                ),
                const SizedBox(height: AppSpacing.s),
                TimePickerRow(
                  label: context.l10n.end,
                  time: endTime,
                  onPick: onPickEnd,
                  enabled: worked,
                ),
              ],
            ),
          ),
          if (worked && !isValid) ...[
            const SizedBox(height: AppSpacing.s),
            Text(
              context.l10n.endAfterStart,
              style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
            ),
          ],
        ],
      ),
    );
  }
}
