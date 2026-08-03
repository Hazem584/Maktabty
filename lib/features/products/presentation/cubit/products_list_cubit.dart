import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/products/domain/usecases/get_products_usecase.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_state.dart';

class ProductsListCubit extends Cubit<ProductsListState> {
  final GetProductsUseCase _getProductsUseCase;
  Timer? _debounce;
  bool _initialized = false;
  int _requestVersion = 0;

  ProductsListCubit({
    required this._getProductsUseCase,
  }) : super(ProductsListState.initial());

  void loadInitial() {
    if (_initialized) return;
    _initialized = true;
    _fetch(page: 1, replace: true, showLoading: true);
  }

  Future<void> refresh() async {
    await _fetch(page: 1, replace: true, showLoading: false, refreshing: true);
  }

  void setProductStatus(ProductStatus status) {
    if (status == state.productStatus && _initialized) return;
    _initialized = true;
    emit(state.copyWith(productStatus: status));
    _fetch(page: 1, replace: true, showLoading: true);
  }

  void updateSearch(String value) {
    final query = value.trim();
    if (query == state.search) return;
    if (isClosed) return;
    emit(state.copyWith(search: query));
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (isClosed) return;
      _fetch(page: 1, replace: true, showLoading: true);
    });
  }

  void setLowStock(bool value) {
    if (value == state.lowStock) return;
    if (isClosed) return;
    emit(state.copyWith(lowStock: value));
    _fetch(page: 1, replace: true, showLoading: true);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || state.hasReachedEnd) return;
    if (state.status == ProductsListStatus.loading) return;
    await _fetch(
      page: state.page + 1,
      replace: false,
      showLoading: false,
      loadMore: true,
    );
  }

  void removeProductLocally(String id, {required bool markUnavailable}) {
    if (isClosed) return;
    final updated = state.products
        .where((product) => product.id != id)
        .toList(growable: false);
    emit(
      state.copyWith(
        products: updated,
        total: state.total > 0 && updated.length < state.products.length
            ? state.total - 1
            : state.total,
        lastUnavailableProductId: markUnavailable
            ? id
            : state.lastUnavailableProductId,
        catalogMutationVersion: markUnavailable
            ? state.catalogMutationVersion + 1
            : state.catalogMutationVersion,
      ),
    );
  }

  Future<void> _fetch({
    required int page,
    required bool replace,
    required bool showLoading,
    bool refreshing = false,
    bool loadMore = false,
  }) async {
    if (isClosed) return;
    final requestVersion = ++_requestVersion;
    if (showLoading) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ProductsListStatus.loading,
          products: replace ? const [] : state.products,
          page: replace ? 1 : state.page,
          total: replace ? 0 : state.total,
          failure: null,
        ),
      );
    } else if (refreshing) {
      if (isClosed) return;
      emit(state.copyWith(isRefreshing: true, failure: null));
    } else if (loadMore) {
      if (isClosed) return;
      emit(state.copyWith(isLoadingMore: true, failure: null));
    }

    try {
      final response = await _getProductsUseCase(
        search: state.search.isEmpty ? null : state.search,
        lowStock: state.lowStock ? true : null,
        status: state.productStatus,
        page: page,
        limit: state.limit,
      );

      final updated = replace
          ? response.items
          : [...state.products, ...response.items];

      if (isClosed || requestVersion != _requestVersion) return;
      emit(
        state.copyWith(
          status: ProductsListStatus.success,
          products: updated,
          page: response.page,
          limit: response.limit,
          total: response.total,
          isLoadingMore: false,
          isRefreshing: false,
          failure: null,
          isFromCache: response.isFromCache,
          lastCachedAt: response.lastCachedAt,
        ),
      );
    } on AppFailure catch (failure) {
      if (isClosed || requestVersion != _requestVersion) return;
      emit(
        state.copyWith(
          status: ProductsListStatus.failure,
          isLoadingMore: false,
          isRefreshing: false,
          failure: failure,
        ),
      );
    } catch (_) {
      if (isClosed || requestVersion != _requestVersion) return;
      emit(
        state.copyWith(
          status: ProductsListStatus.failure,
          isLoadingMore: false,
          isRefreshing: false,
          failure: const UnknownFailure(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
