import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_loading.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/presentation/cubit/product_archive_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_state.dart';

class ArchivedProductsScreen extends StatelessWidget {
  const ArchivedProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ProductsListCubit>()
            ..setProductStatus(ProductStatus.archived),
        ),
        BlocProvider(create: (_) => sl<ProductArchiveCubit>()),
      ],
      child: const _ArchivedProductsView(),
    );
  }
}

class _ArchivedProductsView extends StatefulWidget {
  const _ArchivedProductsView();

  @override
  State<_ArchivedProductsView> createState() => _ArchivedProductsViewState();
}

class _ArchivedProductsViewState extends State<_ArchivedProductsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
  }

  void _loadMore() {
    if (_scrollController.hasClients &&
        _scrollController.position.extentAfter < 240) {
      context.read<ProductsListCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _restore(ProductEntity product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.restoreProduct),
        content: Text(context.l10n.restoreProductConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.restoreProduct),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await context.read<ProductArchiveCubit>().restore(product.id);
    if (!mounted) return;
    final state = context.read<ProductArchiveCubit>().state;
    if (state.status == ProductArchiveStatus.restored ||
        state.conflict == ProductArchiveConflict.alreadyActive) {
      context.read<ProductsListCubit>().removeProductLocally(
        product.id,
        markUnavailable: false,
      );
      AppToast.show(
        state.status == ProductArchiveStatus.restored
            ? context.l10n.productRestoredSuccessfully
            : context.l10n.productAlreadyActive,
      );
      return;
    }
    AppToast.show(
      context.localizeFailure(
        state.failure,
        fallback: context.l10n.restoreRequestFailed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.archivedProducts),
        actions: [
          IconButton(
            onPressed: () => context.read<ProductsListCubit>().refresh(),
            icon: const Icon(Icons.refresh),
            tooltip: context.l10n.refresh,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: TextField(
              onChanged: context.read<ProductsListCubit>().updateSearch,
              decoration: InputDecoration(
                labelText: context.l10n.searchProductsHint,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductsListCubit, ProductsListState>(
              builder: (context, state) {
                if (state.status == ProductsListStatus.loading &&
                    state.products.isEmpty) {
                  return const Center(child: AppLoading());
                }
                if (state.status == ProductsListStatus.failure &&
                    state.products.isEmpty) {
                  return _ArchivedError(
                    message: context.localizeFailure(state.failure),
                    onRetry: () => context.read<ProductsListCubit>().refresh(),
                  );
                }
                if (state.products.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: context.read<ProductsListCubit>().refresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 280,
                          child: Center(
                            child: Text(context.l10n.noArchivedProducts),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: context.read<ProductsListCubit>().refresh,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.m),
                    itemCount:
                        state.products.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.products.length) {
                        return const Padding(
                          padding: EdgeInsets.all(AppSpacing.m),
                          child: Center(child: AppLoading()),
                        );
                      }
                      return _ArchivedProductCard(
                        product: state.products[index],
                        onRestore: _restore,
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

class _ArchivedProductCard extends StatelessWidget {
  final ProductEntity product;
  final ValueChanged<ProductEntity> onRestore;
  const _ArchivedProductCard({required this.product, required this.onRestore});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final archivedDate = product.archivedAt == null
        ? context.l10n.notAvailable
        : DateFormat.yMMMd(locale).add_Hm().format(
            product.archivedAt!.toLocal(),
          );
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.archive_outlined),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => onRestore(product),
                  icon: const Icon(Icons.restore),
                  label: Text(context.l10n.restoreProduct),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            Text('${context.l10n.productCode}: ${product.code ?? context.l10n.notAvailable}'),
            Text('${context.l10n.price}: ${product.price.toStringAsFixed(2)} EGP'),
            Text('${context.l10n.stockLabel}: ${product.stock}'),
            Text('${context.l10n.archivedDate}: $archivedDate'),
            Text('${context.l10n.archiveReason}: ${product.archiveReason ?? context.l10n.notAvailable}'),
            if (product.lastPurchasePrice != null)
              Text('${context.l10n.lastPurchasePrice}: ${product.lastPurchasePrice!.toStringAsFixed(2)} EGP'),
            if (product.averageCost != null)
              Text('${context.l10n.averageCost}: ${product.averageCost!.toStringAsFixed(2)} EGP'),
          ],
        ),
      ),
    );
  }
}

class _ArchivedError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ArchivedError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.s),
          FilledButton(onPressed: onRetry, child: Text(context.l10n.retry)),
        ],
      ),
    );
  }
}
