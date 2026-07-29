import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/services/barcode_scanner_service.dart';
import 'package:maktabty/core/widgets/app_loading.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/product_details_state.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_state.dart';
import 'package:maktabty/features/sales/presentation/widgets/primary_sell_button.dart';
import 'package:maktabty/features/sales/presentation/widgets/product_search_field.dart';
import 'package:maktabty/features/sales/presentation/widgets/product_search_results.dart';
import 'package:maktabty/features/sales/presentation/widgets/quantity_selector.dart';
import 'package:maktabty/features/sales/presentation/widgets/scan_code_card.dart';
import 'package:maktabty/features/sales/presentation/widgets/scan_or_search_toggle.dart';
import 'package:maktabty/features/sales/presentation/widgets/selected_product_card.dart';

enum SellMode { scan, search }

class SellProductScreenBody extends StatefulWidget {
  const SellProductScreenBody({super.key});

  @override
  State<SellProductScreenBody> createState() => _SellProductScreenBodyState();
}

class _SellProductScreenBodyState extends State<SellProductScreenBody> {
  final TextEditingController _searchController = TextEditingController();

  SellMode _mode = SellMode.scan;
  String? _code;
  String? _scanMessage;
  int _quantity = 1;

  ProductEntity? _selectedProduct;

  @override
  void initState() {
    super.initState();
    context.read<ProductsListCubit>().loadInitial();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onModeChanged(SellMode mode) {
    setState(() {
      _mode = mode;
      _scanMessage = null;
      if (mode == SellMode.scan) {
        _searchController.clear();
      } else {
        _code = null;
      }
    });
  }

  Future<void> _scanCode() async {
    final code = await sl<BarcodeScannerService>().scan(
      context,
      title: context.l10n.scanBarcodeTitle,
    );
    if (!mounted || code == null || code.isEmpty) return;

    setState(() {
      _code = code;
      _scanMessage = null;
    });

    context.read<ProductDetailsCubit>().loadByCode(code);
  }

  void _selectProduct(ProductEntity product) {
    setState(() {
      _selectedProduct = product;
      _quantity = 1;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedProduct = null;
      _quantity = 1;
    });
  }

  void _incrementQty() {
    setState(() {
      _quantity += 1;
    });
  }

  void _decrementQty() {
    setState(() {
      if (_quantity > 1) {
        _quantity -= 1;
      }
    });
  }

  void _sellProduct() {
    final product = _selectedProduct;
    if (product == null) {
      AppToast.show(context.l10n.selectProductFirst);
      return;
    }

    AppToast.show(context.l10n.salesNotImplemented);

    debugPrint('Selected product: ${product.name}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductDetailsCubit, ProductDetailsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ProductDetailsStatus.failure) {
          final message = state.message ?? context.l10n.productNotFound;
          setState(() {
            _scanMessage = message;
          });
          AppToast.show(message);
        }
        if (state.status == ProductDetailsStatus.success) {
          final product = state.product;
          if (product != null) {
            setState(() {
              _selectedProduct = product;
              _quantity = 1;
              _scanMessage = null;
            });
          }
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScanOrSearchToggle(
              mode: _mode,
              onModeChanged: _onModeChanged,
            ),
            const SizedBox(height: AppSpacing.l),
            if (_mode == SellMode.scan) ...[
              ScanCodeCard(
                code: _code,
                message: _scanMessage,
                onScan: _scanCode,
              ),
            ] else ...[
              ProductSearchField(
                controller: _searchController,
                onChanged: (value) {
                  context.read<ProductsListCubit>().updateSearch(value);
                },
              ),
              const SizedBox(height: AppSpacing.m),
              BlocBuilder<ProductsListCubit, ProductsListState>(
                builder: (context, state) {
                  if (state.status == ProductsListStatus.loading &&
                      state.products.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.l),
                        child: AppLoading(),
                      ),
                    );
                  }

                  return ProductSearchResults(
                    products: state.products,
                    onSelect: _selectProduct,
                  );
                },
              ),
            ],
            if (_selectedProduct != null) ...[
              const SizedBox(height: AppSpacing.l),
              SelectedProductCard(
                product: _selectedProduct!,
                onChange: _clearSelection,
              ),
              const SizedBox(height: AppSpacing.m),
              QuantitySelector(
                quantity: _quantity,
                onIncrement: _incrementQty,
                onDecrement: _decrementQty,
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            PrimarySellButton(
              label: context.l10n.sell,
              onPressed: _sellProduct,
            ),
          ],
        ),
      ),
    );
  }
}
