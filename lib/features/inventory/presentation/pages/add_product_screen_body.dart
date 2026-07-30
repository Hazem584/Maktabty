import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/services/barcode_scanner_service.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/inventory/presentation/widgets/primary_action_bar.dart';
import 'package:maktabty/features/inventory/presentation/widgets/product_form_field.dart';
import 'package:maktabty/features/inventory/presentation/widgets/scan_code_card.dart';
import 'package:maktabty/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/product_form_state.dart';
import 'package:maktabty/features/products/domain/validation/product_validator.dart';

class AddProductScreenBody extends StatefulWidget {
  const AddProductScreenBody({super.key});

  @override
  State<AddProductScreenBody> createState() => _AddProductScreenBodyState();
}

class _AddProductScreenBodyState extends State<AddProductScreenBody> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  String? _code;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _scanCode() async {
    final code = await sl<BarcodeScannerService>().scan(
      context,
      title: context.l10n.scanBarcodeTitle,
    );
    if (!mounted || code == null || code.isEmpty) return;
    setState(() {
      _code = code;
    });
  }

  void _saveProduct() {
    final result = ProductValidator.validate(
      name: _nameController.text,
      price: _priceController.text,
      stock: _quantityController.text,
      code: _code,
    );
    if (!result.isValid) {
      AppToast.show(context.localizeValidation(result.error!));
      return;
    }
    final input = result.value!;
    context.read<ProductFormCubit>().createProduct(
      name: input.name,
      price: input.price,
      stock: input.stock,
      code: input.code,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductFormCubit, ProductFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ProductFormStatus.failure) {
          AppToast.show(context.localizeFailure(state.failure));
        }
        if (state.status == ProductFormStatus.success) {
          AppToast.show(context.l10n.productSaved);
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ProductFormStatus.loading;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.l),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadii.l),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ProductFormField(
                      label: context.l10n.productName,
                      icon: Icons.inventory_2_outlined,
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.m),
                    ProductFormField(
                      label: context.l10n.price,
                      icon: Icons.attach_money,
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      prefixText: r'$',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.m),
                    ProductFormField(
                      label: context.l10n.quantity,
                      icon: Icons.numbers,
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              ScanCodeCard(code: _code, onScan: _scanCode),
              const SizedBox(height: AppSpacing.xl),
              PrimaryActionBar(
                label: isLoading
                    ? context.l10n.saving
                    : context.l10n.saveProduct,
                onPressed: isLoading ? () {} : _saveProduct,
              ),
            ],
          ),
        );
      },
    );
  }
}
