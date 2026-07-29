import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';

class TimePickerRow extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final VoidCallback onPick;
  final bool enabled;

  const TimePickerRow({
    super.key,
    required this.label,
    required this.time,
    required this.onPick,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final display = time.format(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        OutlinedButton.icon(
          onPressed: enabled ? onPick : null,
          icon: const Icon(Icons.access_time),
          label: Text(display),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.s,
            ),
          ),
        ),
      ],
    );
  }
}
