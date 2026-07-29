import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';

class HomeActionsRow extends StatelessWidget {
  final VoidCallback onAddProduct;
  final VoidCallback onSellProduct;
  final VoidCallback? onAddWorkHours;

  const HomeActionsRow({
    super.key,
    required this.onAddProduct,
    required this.onSellProduct,
    this.onAddWorkHours,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildButton(context.l10n.addProduct, onAddProduct)),
        const SizedBox(width: AppSpacing.s),
        Expanded(child: _buildButton(context.l10n.sellProduct, onSellProduct)),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          child: _buildButton(context.l10n.addWorkHours, onAddWorkHours),
        ),
      ],
    );
  }

  Widget _buildButton(String label, VoidCallback? onPressed) {
    return SizedBox(
      height: 48,
      child: FilledButton.tonal(
        onPressed: onPressed ?? () {},
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.m),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
