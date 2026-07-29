import 'package:flutter/material.dart';
import 'package:maktabty/core/widgets/app_loading.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? AppLoading(
                size: 20,
                lineWidth: 2,
                color: Theme.of(context).colorScheme.onPrimary,
              )
            : Text(label),
      ),
    );
  }
}
