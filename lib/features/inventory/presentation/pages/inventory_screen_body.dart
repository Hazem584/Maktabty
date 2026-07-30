import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_loading.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/inventory/presentation/pages/edit_product_screen.dart';
import 'package:maktabty/features/inventory/presentation/widgets/inventory_product_tile.dart';
import 'package:maktabty/features/inventory/presentation/widgets/inventory_search_bar.dart';
import 'package:maktabty/features/inventory/presentation/widgets/product_actions_sheet.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_state.dart';

class InventoryScreenBody extends StatefulWidget {
  const InventoryScreenBody({super.key});

  @override
  State<InventoryScreenBody> createState() => _InventoryScreenBodyState();
}

class _InventoryScreenBodyState extends State<InventoryScreenBody> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<ProductsListCubit>().loadMore();
    }
  }

  void _openActions(ProductEntity product) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return ProductActionsSheet(
          onEdit: () {
            Navigator.of(context).pop();
            _editProduct(product);
          },
          onDelete: () {
            Navigator.of(context).pop();
            _confirmDelete(product);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(ProductEntity product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.deleteProductTitle),
          content: Text(context.l10n.deleteProductMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.l10n.delete),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (confirmed == true) {
      final success = await context.read<ProductsListCubit>().deleteProduct(
        product.id,
      );
      if (!mounted) return;
      if (success) {
        AppToast.show(context.l10n.productDeleted);
      }
    }
  }

  Future<void> _editProduct(ProductEntity product) async {
    final updated = await Navigator.of(context).push<ProductEntity>(
      MaterialPageRoute(builder: (_) => EditProductScreen(product: product)),
    );

    if (updated != null && mounted) {
      await context.read<ProductsListCubit>().refresh();
      if (!mounted) return;
      AppToast.show(context.l10n.productUpdated);
    }
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 240,
          child: Center(
            child: Text(
              context.l10n.inventoryEmpty,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(AppFailure? failure) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 240,
          child: Center(
            child: Text(
              context.localizeFailure(
                failure,
                fallback: context.l10n.inventoryLoadFailed,
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        children: [
          InventorySearchBar(
            controller: _searchController,
            onChanged: (value) {
              context.read<ProductsListCubit>().updateSearch(value);
            },
          ),
          const SizedBox(height: AppSpacing.l),
          Expanded(
            child: BlocConsumer<ProductsListCubit, ProductsListState>(
              listenWhen: (previous, current) {
                return current.failure != null &&
                    current.failure != previous.failure;
              },
              listener: (context, state) {
                final failure = state.failure;
                if (failure != null) {
                  AppToast.show(
                    context.localizeFailure(
                      failure,
                      notFoundFallback: context.l10n.productNotFound,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.status == ProductsListStatus.loading &&
                    state.products.isEmpty) {
                  return const Center(child: AppLoading());
                }

                return RefreshIndicator(
                  onRefresh: () => context.read<ProductsListCubit>().refresh(),
                  child: Builder(
                    builder: (_) {
                      if (state.status == ProductsListStatus.failure &&
                          state.products.isEmpty) {
                        return _buildErrorState(state.failure);
                      }

                      if (state.products.isEmpty) {
                        return _buildEmptyState();
                      }

                      final itemCount =
                          state.products.length + (state.isLoadingMore ? 1 : 0);

                      return ListView.separated(
                        controller: _scrollController,
                        itemCount: itemCount,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index >= state.products.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: AppLoading(size: 22, lineWidth: 2),
                              ),
                            );
                          }

                          final product = state.products[index];
                          return InventoryProductTile(
                            product: product,
                            onTap: () => _openActions(product),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
