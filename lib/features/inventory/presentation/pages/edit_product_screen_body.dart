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
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';

class EditProductScreenBody extends StatefulWidget {
  final ProductEntity product;

  const EditProductScreenBody({super.key, required this.product});

  @override
  State<EditProductScreenBody> createState() => _EditProductScreenBodyState();
}

class _EditProductScreenBodyState extends State<EditProductScreenBody> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _adjustmentReasonController;
  late int _stock;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(
      text: widget.product.price.toStringAsFixed(2),
    );
    _adjustmentReasonController = TextEditingController();
    _stock = widget.product.stock;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _adjustmentReasonController.dispose();
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
    final stockChanged = input.stock != widget.product.stock;
    final adjustmentReason = _adjustmentReasonController.text.trim();
    if (stockChanged && adjustmentReason.isEmpty) {
      AppToast.show(context.l10n.adjustmentReasonRequired);
      return;
    }
    context.read<ProductFormCubit>().updateProduct(
      id: widget.product.id,
      name: input.name,
      price: input.price,
      stock: stockChanged ? input.stock : null,
      code: input.code,
      adjustmentReason: stockChanged ? adjustmentReason : null,
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
        final isOwner = context.select<AuthCubit, bool>(
          (cubit) =>
              cubit.state.user?.role?.trim().toUpperCase() == 'OWNER',
        );

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
              if (isOwner &&
                  (widget.product.lastPurchasePrice != null ||
                      widget.product.averageCost != null)) ...[
                const SizedBox(height: AppSpacing.m),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(context.l10n.lastPurchasePrice),
                          trailing: Text(
                            widget.product.lastPurchasePrice == null
                                ? context.l10n.notAvailable
                                : '${widget.product.lastPurchasePrice!.toStringAsFixed(2)} EGP',
                          ),
                        ),
                        ListTile(
                          title: Text(context.l10n.averageCost),
                          trailing: Text(
                            widget.product.averageCost == null
                                ? context.l10n.notAvailable
                                : '${widget.product.averageCost!.toStringAsFixed(2)} EGP',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (_stock != widget.product.stock) ...[
                const SizedBox(height: AppSpacing.m),
                Text(
                  context.l10n.stockAdjustmentSummary(
                    widget.product.stock,
                    _stock,
                    '${_stock - widget.product.stock >= 0 ? '+' : ''}${_stock - widget.product.stock}',
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                TextFormField(
                  controller: _adjustmentReasonController,
                  enabled: !isLoading,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: context.l10n.adjustmentReason,
                    helperText: context.l10n.stockMovementWillBeRecorded,
                  ),
                ),
              ],
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
