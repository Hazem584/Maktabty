import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';

class ScanCodeCard extends StatelessWidget {
  final String? code;
  final Future<void> Function() onScan;

  const ScanCodeCard({
    super.key,
    required this.code,
    required this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
          Text(context.l10n.productCode, style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.m),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadii.m),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Icon(Icons.qr_code_scanner, color: colorScheme.primary),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Text(
                    code ?? context.l10n.noCodeScanned,
                    style: textTheme.bodyMedium?.copyWith(
                      color: code == null
                          ? colorScheme.outline
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            context.l10n.scanHint,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
          ),
          const SizedBox(height: AppSpacing.m),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => onScan(),
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(context.l10n.scanQrBarcode),
            ),
          ),
        ],
      ),
    );
  }
}
