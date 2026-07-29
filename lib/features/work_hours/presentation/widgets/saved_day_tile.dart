import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/work_hours/domain/entities/work_day.dart';

class SavedDayTile extends StatelessWidget {
  final WorkDayEntity entry;

  const SavedDayTile({
    super.key,
    required this.entry,
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
            color: Color(0x0C000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.access_time),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_formatDate(entry.date, context),
                    style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                if (entry.user != null)
                  Text(
                    entry.user!.fullName,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                if (entry.shift1Start != null && entry.shift1End != null)
                  Text(
                    '${context.l10n.shift1}: ${_formatTime(entry.shift1Start!, context)} - '
                    '${_formatTime(entry.shift1End!, context)}',
                    style: textTheme.bodySmall,
                  ),
                if (entry.shift2Start != null && entry.shift2End != null)
                  Text(
                    '${context.l10n.shift2}: ${_formatTime(entry.shift2Start!, context)} - '
                    '${_formatTime(entry.shift2End!, context)}',
                    style: textTheme.bodySmall,
                  ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${context.l10n.totalLabel}: ${_formatMinutes(entry.totalMinutes)}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date, BuildContext context) {
    if (date == null) return context.l10n.unknownDate;
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat.yMMMd(locale).format(date);
  }

  String _formatTime(DateTime dateTime, BuildContext context) {
    return TimeOfDay.fromDateTime(dateTime).format(context);
  }

  String _formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours == 0) return '${mins}m';
    if (mins == 0) return '${hours}h';
    return '${hours}h ${mins}m';
  }
}
