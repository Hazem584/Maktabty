import 'package:flutter/material.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/sales/presentation/pages/sell_product_screen_body.dart';

class ScanOrSearchToggle extends StatelessWidget {
  final SellMode mode;
  final ValueChanged<SellMode> onModeChanged;

  const ScanOrSearchToggle({
    super.key,
    required this.mode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<SellMode>(
      segments: [
        ButtonSegment(value: SellMode.scan, label: Text(context.l10n.scan)),
        ButtonSegment(value: SellMode.search, label: Text(context.l10n.search)),
      ],
      selected: <SellMode>{mode},
      onSelectionChanged: (value) {
        if (value.isNotEmpty) {
          onModeChanged(value.first);
        }
      },
    );
  }
}
