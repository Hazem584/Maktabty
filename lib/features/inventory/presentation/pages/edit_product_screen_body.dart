import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/inventory/presentation/widgets/product_form_card.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/product_form_state.dart';
import 'package:maktabty/features/products/domain/validation/product_validator.dart';

class EditProductScreenBody extends StatefulWidget {
  final ProductEntity product;

  const EditProductScreenBody({super.key, required this.product});

  @override
  State<EditProductScreenBody> createState() => _EditProductScreenBodyState();
}

class _EditProductScreenBodyState extends State<EditProductScreenBody> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late int _stock;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(
      text: widget.product.price.toStringAsFixed(2),
    );
    _stock = widget.product.stock;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final result = ProductValidator.validate(
      name: _nameController.text,
      price: _priceController.text,
      stock: _stock.toString(),
      code: widget.product.code,
    );
    if (!result.isValid) {
      AppToast.show(context.localizeValidation(result.error!));
      return;
    }
    final input = result.value!;
    context.read<ProductFormCubit>().updateProduct(
      id: widget.product.id,
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
          final product = state.product;
          if (product != null) {
            AppToast.show(context.l10n.productUpdated);
            Navigator.of(context).pop(product);
          }
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ProductFormStatus.loading;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductFormCard(
                nameController: _nameController,
                priceController: _priceController,
                stock: _stock,
                code: widget.product.code,
                onIncrement: () {
                  setState(() {
                    _stock += 1;
                  });
                },
                onDecrement: () {
                  setState(() {
                    if (_stock > 0) {
                      _stock -= 1;
                    }
                  });
                },
              ),
              const SizedBox(height: AppSpacing.l),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _saveChanges,
                  child: Text(
                    isLoading ? context.l10n.saving : context.l10n.saveChanges,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
