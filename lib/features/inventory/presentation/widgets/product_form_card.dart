import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/inventory/presentation/widgets/quantity_stepper.dart';

class ProductFormCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final int stock;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String? code;

  const ProductFormCard({
    super.key,
    required this.nameController,
    required this.priceController,
    required this.stock,
    required this.onIncrement,
    required this.onDecrement,
    this.code,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.l),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: nameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: context.l10n.productName,
              prefixIcon: const Icon(Icons.inventory_2_outlined),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: context.l10n.price,
              prefixIcon: const Icon(Icons.attach_money),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            context.l10n.quantity,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.s),
          QuantityStepper(
            quantity: stock,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
          ),
          if (code != null) ...[
            const SizedBox(height: AppSpacing.m),
            TextFormField(
              initialValue: code,
              readOnly: true,
              decoration: InputDecoration(
                labelText: context.l10n.productCode,
                prefixIcon: const Icon(Icons.qr_code_scanner),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
