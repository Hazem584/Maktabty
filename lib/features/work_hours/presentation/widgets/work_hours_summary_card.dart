import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';

class WorkHoursSummaryCard extends StatelessWidget {
  final double? totalHours;

  const WorkHoursSummaryCard({super.key, required this.totalHours});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final totalLabel = totalHours == null
        ? '--'
        : totalHours!.toStringAsFixed(1);

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
          Icon(Icons.timelapse, color: colorScheme.primary),
          const SizedBox(width: AppSpacing.m),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.totalWorkedHours, style: textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                context.l10n.hoursLabel(totalLabel),
                style: textTheme.bodyMedium?.copyWith(
                  color: totalHours == null
                      ? colorScheme.outline
                      : colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
