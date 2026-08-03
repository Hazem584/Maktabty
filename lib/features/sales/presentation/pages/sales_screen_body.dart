import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/widgets/app_loading.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/services/barcode_scanner_service.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_state.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_input.dart';
import 'package:maktabty/features/sales/domain/validation/sale_validator.dart';
import 'package:maktabty/features/sales/presentation/cubit/create_sale_by_code_cubit.dart';
import 'package:maktabty/features/sales/presentation/cubit/create_sale_by_code_state.dart';
import 'package:maktabty/features/sales/presentation/cubit/create_sale_cubit.dart';
import 'package:maktabty/features/sales/presentation/cubit/create_sale_state.dart';
import 'package:maktabty/features/sales/presentation/cubit/today_sales_cubit.dart';
import 'package:maktabty/features/sales/presentation/cubit/today_sales_state.dart';
import 'package:maktabty/features/sales/presentation/widgets/empty_sales_state.dart';
import 'package:maktabty/features/sales/presentation/widgets/primary_sell_button.dart';
import 'package:maktabty/features/sales/presentation/widgets/product_search_field.dart';
import 'package:maktabty/features/sales/presentation/widgets/product_search_results.dart';
import 'package:maktabty/features/sales/presentation/widgets/payment_selection_sheet.dart';
import 'package:maktabty/features/sales/presentation/widgets/quantity_selector.dart';
import 'package:maktabty/features/sales/presentation/widgets/receipt_preview_sheet.dart';
import 'package:maktabty/features/sales/presentation/widgets/sales_list_item.dart';
import 'package:maktabty/features/sales/presentation/widgets/sales_summary_card.dart';
import 'package:maktabty/features/sales/presentation/widgets/selected_product_card.dart';

class SalesScreenBody extends StatelessWidget {
  const SalesScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBarView(children: [_NewSaleTab(), _NewSaleByCodeTab()]);
  }
}

class _NewSaleTab extends StatefulWidget {
  const _NewSaleTab();

  @override
  State<_NewSaleTab> createState() => _NewSaleTabState();
}

class _NewSaleTabState extends State<_NewSaleTab> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();

  ProductEntity? _selectedProduct;
  int _quantity = 1;
  final List<_PendingSaleItem> _items = [];

  @override
  void dispose() {
    _searchController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  void _selectProduct(ProductEntity product) {
    setState(() {
      _selectedProduct = product;
      _quantity = 1;
      _unitPriceController.clear();
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedProduct = null;
      _quantity = 1;
      _unitPriceController.clear();
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

  void _addItem() {
    final product = _selectedProduct;
    if (product == null) {
      AppToast.show(context.l10n.selectProductFirst);
      return;
    }
    if (!product.isActive) {
      AppToast.show(context.l10n.archivedProductCannotBeSold);
      _clearSelection();
      return;
    }

    final override = _parsePrice(_unitPriceController.text);
    if (_unitPriceController.text.trim().isNotEmpty && override == null) {
      AppToast.show(context.l10n.enterValidUnitPrice);
      return;
    }

    setState(() {
      final index = _items.indexWhere((item) => item.product.id == product.id);
      if (index >= 0) {
        final existing = _items[index];
        _items[index] = existing.copyWith(
          quantity: existing.quantity + _quantity,
          unitPriceOverride: override ?? existing.unitPriceOverride,
        );
      } else {
        _items.add(
          _PendingSaleItem(
            product: product,
            quantity: _quantity,
            unitPriceOverride: override,
          ),
        );
      }
      _selectedProduct = null;
      _quantity = 1;
      _unitPriceController.clear();
      _searchController.clear();
    });
  }

  void _removeItem(_PendingSaleItem item) {
    setState(() {
      _items.remove(item);
    });
  }

  Future<void> _submitSale() async {
    if (_items.isEmpty) {
      AppToast.show(context.l10n.addAtLeastOneItem);
      return;
    }

    final total = _items.fold<double>(0, (sum, item) => sum + item.lineTotal);

    final cubit = context.read<CreateSaleCubit>();
    final confirmed = await _showPaymentSheet(total, cubit);
    if (!confirmed) return;

    final inputs = _items.map((item) => item.toInput()).toList();
    cubit.submit(items: inputs);
  }

  Future<bool> _showPaymentSheet(double total, CreateSaleCubit cubit) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return BlocBuilder<CreateSaleCubit, CreateSaleState>(
          bloc: cubit,
          builder: (context, state) {
            return PaymentSelectionSheet(
              total: total,
              method: state.paymentMethod,
              paidAmount: state.paidAmount,
              cashAmount: state.cashAmount,
              cardAmount: state.cardAmount,
              onMethodChanged: cubit.setPaymentMethod,
              onPaidChanged: cubit.setPaidAmount,
              onCashChanged: cubit.setCashAmount,
              onCardChanged: cubit.setCardAmount,
              onConfirm: () {
                final error = SaleValidator.validatePayment(
                  method: state.paymentMethod,
                  total: total,
                  paidAmount: state.paidAmount,
                  cashAmount: state.cashAmount,
                  cardAmount: state.cardAmount,
                );
                if (error != null) {
                  AppToast.show(context.localizeValidation(error));
                  return;
                }
                Navigator.of(sheetContext).pop(true);
              },
            );
          },
        );
      },
    );

    return result == true;
  }

  double? _parsePrice(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateSaleCubit, CreateSaleState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
        if (state.status == CreateSaleStatus.failure) {
          AppToast.show(
            context.localizeFailure(
              state.failure,
              fallback: context.l10n.unableToCreateSale,
            ),
          );
        }
        if (state.status == CreateSaleStatus.success) {
          AppToast.show(context.l10n.saleSavedLocally);
          context.read<TodaySalesCubit>().load();
          context.read<ProductsListCubit>().refresh();
          final receipt = state.lastReceipt;
          if (receipt != null) {
            ReceiptPreviewSheet.show(context, receipt);
          }
          setState(() {
            _items.clear();
            _selectedProduct = null;
            _quantity = 1;
            _unitPriceController.clear();
            _searchController.clear();
          });
        }
          },
        ),
        BlocListener<ProductsListCubit, ProductsListState>(
          listenWhen: (previous, current) =>
              previous.catalogMutationVersion !=
              current.catalogMutationVersion,
          listener: (context, state) {
            final unavailableId = state.lastUnavailableProductId;
            if (unavailableId == null) return;
            final hadItem = _items.any(
              (item) => item.product.id == unavailableId,
            );
            final wasSelected = _selectedProduct?.id == unavailableId;
            if (!hadItem && !wasSelected) return;
            setState(() {
              _items.removeWhere(
                (item) => item.product.id == unavailableId,
              );
              if (wasSelected) {
                _selectedProduct = null;
                _quantity = 1;
                _unitPriceController.clear();
              }
            });
            AppToast.show(context.l10n.archivedProductRemovedFromCart);
          },
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.l),
        children: [
          Text(
            context.l10n.selectProducts,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.s),
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
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.l),
                  child: Center(child: AppLoading()),
                );
              }

              if (state.status == ProductsListStatus.failure &&
                  state.products.isEmpty) {
                return Text(
                  context.localizeFailure(
                    state.failure,
                    fallback: context.l10n.inventoryLoadFailed,
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state.isFromCache)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.s),
                        child: Row(
                          children: [
                            const Icon(Icons.cloud_off_outlined),
                            const SizedBox(width: AppSpacing.s),
                            Expanded(
                              child: Text(context.l10n.cachedProductsNotice),
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.read<ProductsListCubit>().refresh(),
                              child: Text(context.l10n.refreshProducts),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ProductSearchResults(
                    products: state.products,
                    onSelect: _selectProduct,
                  ),
                ],
              );
            },
          ),
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
            const SizedBox(height: AppSpacing.m),
            TextField(
              controller: _unitPriceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: context.l10n.unitPriceOverrideHint,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            OutlinedButton.icon(
              onPressed: _addItem,
              icon: const Icon(Icons.add_shopping_cart),
              label: Text(context.l10n.addItem),
            ),
          ],
          if (_items.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.l),
            Text(
              context.l10n.itemsLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s),
              itemBuilder: (context, index) {
                final item = _items[index];
                return _PendingItemCard(
                  item: item,
                  onRemove: () => _removeItem(item),
                );
              },
            ),
          ],
          const SizedBox(height: AppSpacing.l),
          BlocBuilder<CreateSaleCubit, CreateSaleState>(
            builder: (context, state) {
              return PrimarySellButton(
                label: context.l10n.submitSale,
                isLoading: state.status == CreateSaleStatus.loading,
                onPressed: state.status == CreateSaleStatus.loading
                    ? null
                    : _submitSale,
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          const _TodaySalesSection(),
        ],
      ),
    );
  }
}

class _NewSaleByCodeTab extends StatefulWidget {
  const _NewSaleByCodeTab();

  @override
  State<_NewSaleByCodeTab> createState() => _NewSaleByCodeTabState();
}

class _NewSaleByCodeTabState extends State<_NewSaleByCodeTab> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  int _quantity = 1;

  @override
  void dispose() {
    _codeController.dispose();
    _unitPriceController.dispose();
    super.dispose();
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

  Future<void> _scanCode() async {
    final code = await sl<BarcodeScannerService>().scan(
      context,
      title: context.l10n.scanBarcodeTitle,
    );
    if (!mounted || code == null || code.isEmpty) return;
    _codeController.text = code;
    _codeController.selection = TextSelection.fromPosition(
      TextPosition(offset: _codeController.text.length),
    );
  }

  Future<void> _submitByCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      AppToast.show(context.l10n.enterProductCodeToast);
      return;
    }

    final override = _parsePrice(_unitPriceController.text);
    if (_unitPriceController.text.trim().isNotEmpty && override == null) {
      AppToast.show(context.l10n.enterValidUnitPrice);
      return;
    }

    final cubit = context.read<CreateSaleByCodeCubit>();
    final confirmed = await _showPaymentSheet(cubit);
    if (!confirmed) return;

    cubit.submit(code: code, quantity: _quantity, unitPriceOverride: override);
  }

  Future<bool> _showPaymentSheet(CreateSaleByCodeCubit cubit) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return BlocBuilder<CreateSaleByCodeCubit, CreateSaleByCodeState>(
          bloc: cubit,
          builder: (context, state) {
            return PaymentSelectionSheet(
              total: null,
              method: state.paymentMethod,
              paidAmount: state.paidAmount,
              cashAmount: state.cashAmount,
              cardAmount: state.cardAmount,
              onMethodChanged: cubit.setPaymentMethod,
              onPaidChanged: cubit.setPaidAmount,
              onCashChanged: cubit.setCashAmount,
              onCardChanged: cubit.setCardAmount,
              onConfirm: () {
                final error = SaleValidator.validatePayment(
                  method: state.paymentMethod,
                  total: null,
                  paidAmount: state.paidAmount,
                  cashAmount: state.cashAmount,
                  cardAmount: state.cardAmount,
                );
                if (error != null) {
                  AppToast.show(context.localizeValidation(error));
                  return;
                }
                Navigator.of(sheetContext).pop(true);
              },
            );
          },
        );
      },
    );

    return result == true;
  }

  double? _parsePrice(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateSaleByCodeCubit, CreateSaleByCodeState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == CreateSaleByCodeStatus.failure) {
          AppToast.show(
            context.localizeFailure(
              state.failure,
              fallback: context.l10n.unableToCreateSale,
            ),
          );
        }
        if (state.status == CreateSaleByCodeStatus.success) {
          AppToast.show(context.l10n.saleSavedLocally);
          context.read<TodaySalesCubit>().load();
          context.read<ProductsListCubit>().refresh();
          final receipt = state.lastReceipt;
          if (receipt != null) {
            ReceiptPreviewSheet.show(context, receipt);
          }
          setState(() {
            _codeController.clear();
            _unitPriceController.clear();
            _quantity = 1;
          });
        }
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.l),
        children: [
          Text(
            context.l10n.createSaleByCodeTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.s),
          TextField(
            controller: _codeController,
            decoration: InputDecoration(
              hintText: context.l10n.enterProductCode,
              prefixIcon: const Icon(Icons.qr_code_2),
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: _scanCode,
                tooltip: context.l10n.scanQrBarcode,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          QuantitySelector(
            quantity: _quantity,
            onIncrement: _incrementQty,
            onDecrement: _decrementQty,
          ),
          const SizedBox(height: AppSpacing.m),
          TextField(
            controller: _unitPriceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: context.l10n.unitPriceOverrideHint,
            ),
          ),
          const SizedBox(height: AppSpacing.l),
          BlocBuilder<CreateSaleByCodeCubit, CreateSaleByCodeState>(
            builder: (context, state) {
              return PrimarySellButton(
                label: context.l10n.submitSale,
                isLoading: state.status == CreateSaleByCodeStatus.loading,
                onPressed: state.status == CreateSaleByCodeStatus.loading
                    ? null
                    : _submitByCode,
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          const _TodaySalesSection(),
        ],
      ),
    );
  }
}

enum _SaleAction { print, delete }

class _PendingSaleItem {
  final ProductEntity product;
  final int quantity;
  final double? unitPriceOverride;

  const _PendingSaleItem({
    required this.product,
    required this.quantity,
    required this.unitPriceOverride,
  });

  double get effectivePrice => unitPriceOverride ?? product.price;

  double get lineTotal => effectivePrice * quantity;

  SaleItemInput toInput() {
    return SaleItemInput(
      productId: product.id,
      quantity: quantity,
      unitPriceOverride: unitPriceOverride,
      productName: product.name,
      productCode: product.code,
      sellingPrice: product.price,
    );
  }

  _PendingSaleItem copyWith({int? quantity, double? unitPriceOverride}) {
    return _PendingSaleItem(
      product: product,
      quantity: quantity ?? this.quantity,
      unitPriceOverride: unitPriceOverride ?? this.unitPriceOverride,
    );
  }
}

class _PendingItemCard extends StatelessWidget {
  final _PendingSaleItem item;
  final VoidCallback onRemove;

  const _PendingItemCard({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.l),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.inventory_2_outlined),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${context.l10n.quantityLabel}: ${item.quantity} • ${context.l10n.unitLabel}: \$${item.effectivePrice.toStringAsFixed(2)}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${item.lineTotal.toStringAsFixed(2)}',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.close),
                tooltip: context.l10n.removeItem,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TodaySalesSection extends StatelessWidget {
  const _TodaySalesSection();

  Future<void> _showSaleActions(BuildContext context, SaleEntity sale) async {
    final l10n = context.l10n;
    final action = await showModalBottomSheet<_SaleAction>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.print_outlined),
                title: Text(l10n.printReceipt),
                onTap: () => Navigator.of(sheetContext).pop(_SaleAction.print),
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(sheetContext).colorScheme.error,
                ),
                title: Text(
                  l10n.deleteSale,
                  style: TextStyle(
                    color: Theme.of(sheetContext).colorScheme.error,
                  ),
                ),
                onTap: () => Navigator.of(sheetContext).pop(_SaleAction.delete),
              ),
              const SizedBox(height: AppSpacing.s),
            ],
          ),
        );
      },
    );

    if (action == _SaleAction.print) {
      await _openReceipt(context, sale);
      return;
    }

    if (action == _SaleAction.delete) {
      if (sale.id.isEmpty) {
        AppToast.show(l10n.somethingWentWrong);
        return;
      }
      final confirmed = await _confirmDeleteSale(context);
      if (!context.mounted || !confirmed) return;
      final deleted =
          await _runWithLoading<bool>(context, () async {
            await context.read<TodaySalesCubit>().deleteSale(sale.id);
            return true;
          }).onError((error, stackTrace) {
            final message = error is AppFailure && context.mounted
                ? context.localizeFailure(
                    error,
                    fallback: l10n.unableToLoadSales,
                  )
                : l10n.unableToLoadSales;
            AppToast.show(message);
            return false;
          });
      if (deleted != true) return;
      AppToast.show(l10n.saleDeleted);
      _refreshInventoryIfAvailable(context);
    }
  }

  void _refreshInventoryIfAvailable(BuildContext context) {
    try {
      context.read<ProductsListCubit>().refresh();
    } catch (_) {}
  }

  Future<bool> _confirmDeleteSale(BuildContext context) async {
    final l10n = context.l10n;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteSaleTitle),
          content: Text(l10n.deleteSaleMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  Future<void> _openReceipt(BuildContext context, SaleEntity sale) async {
    final l10n = context.l10n;
    if (sale.id.isEmpty) {
      AppToast.show(l10n.unableToLoadReceipt);
      return;
    }

    final receipt =
        await _runWithLoading(
          context,
          () => context.read<TodaySalesCubit>().getReceiptForSale(sale.id),
        ).onError((error, stackTrace) {
          final message = error is AppFailure && context.mounted
              ? context.localizeFailure(
                  error,
                  fallback: l10n.unableToLoadReceipt,
                )
              : l10n.unableToLoadReceipt;
          AppToast.show(message);
          return null;
        });

    if (!context.mounted || receipt == null) return;
    if (receipt.receiptNo.isEmpty && receipt.items.isEmpty) {
      AppToast.show(l10n.unableToLoadReceipt);
      return;
    }
    ReceiptPreviewSheet.show(context, receipt);
  }

  Future<T?> _runWithLoading<T>(
    BuildContext context,
    Future<T> Function() action,
  ) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const Center(child: AppLoading()),
    );

    try {
      return await action();
    } finally {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.l10n.todaysSales, style: textTheme.titleMedium),
            TextButton(
              onPressed: () => context.read<TodaySalesCubit>().load(),
              child: Text(context.l10n.refresh),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s),
        BlocBuilder<TodaySalesCubit, TodaySalesState>(
          builder: (context, state) {
            if (state.status == TodaySalesStatus.loading &&
                state.response == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.l),
                child: Center(child: AppLoading()),
              );
            }

            if (state.status == TodaySalesStatus.failure) {
              return Container(
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(AppRadii.m),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: Text(
                        context.localizeFailure(
                          state.failure,
                          fallback: context.l10n.unableToLoadSales,
                        ),
                        style: textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final response = state.response;
            if (response == null) {
              return const EmptySalesState();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SalesSummaryCard(
                  totalSales: response.summary.totalAmount,
                  itemsSold: response.summary.itemsCount,
                ),
                const SizedBox(height: AppSpacing.m),
                if (response.data.isEmpty)
                  const EmptySalesState()
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: response.data.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.s),
                    itemBuilder: (context, index) {
                      final sale = response.data[index];
                      return SalesListItem(
                        sale: sale,
                        onTap: () => _showSaleActions(context, sale),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
