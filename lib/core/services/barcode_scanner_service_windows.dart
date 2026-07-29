import 'package:flutter/material.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/services/barcode_scanner_service.dart';
import 'package:maktabty/core/theme/app_theme.dart';

class WindowsBarcodeScannerService implements BarcodeScannerService {
  @override
  Future<String?> scan(BuildContext context, {String? title}) async {
    final l10n = context.l10n;
    String scannedValue = '';

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title ?? l10n.scanBarcodeTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.scanBarcodeHint),
              const SizedBox(height: AppSpacing.s),
              TextField(
                autofocus: true,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  scannedValue = value;
                },
                onSubmitted: (value) {
                  Navigator.of(dialogContext).pop(value);
                },
                decoration: InputDecoration(
                  labelText: l10n.scanBarcodeTitle,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                MaterialLocalizations.of(dialogContext).cancelButtonLabel,
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(scannedValue),
              child: Text(
                MaterialLocalizations.of(dialogContext).okButtonLabel,
              ),
            ),
          ],
        );
      },
    );

    final trimmed = result?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
