import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';

class PrimaryActionBar extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimaryActionBar({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
        ),
        child: Text(label),
      ),
    );
  }
}
