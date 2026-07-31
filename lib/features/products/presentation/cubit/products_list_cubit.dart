import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/get_products_usecase.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_state.dart';

class ProductsListCubit extends Cubit<ProductsListState> {
  final GetProductsUseCase _getProductsUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  Timer? _debounce;
  bool _initialized = false;

  ProductsListCubit({
    required GetProductsUseCase getProductsUseCase,
    required DeleteProductUseCase deleteProductUseCase,
  }) : _getProductsUseCase = getProductsUseCase,
       _deleteProductUseCase = deleteProductUseCase,
       super(ProductsListState.initial());

  void loadInitial() {
    if (_initialized) return;
    _initialized = true;
    _fetch(page: 1, replace: true, showLoading: true);
  }

  Future<void> refresh() async {
    await _fetch(page: 1, replace: true, showLoading: false, refreshing: true);
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

  Future<bool> deleteProduct(String id) async {
    try {
      await _deleteProductUseCase(id: id);
      await _fetch(page: 1, replace: true, showLoading: false);
      return true;
    } on AppFailure catch (failure) {
      if (!isClosed) {
        emit(
          state.copyWith(status: ProductsListStatus.failure, failure: failure),
        );
      }
      return false;
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ProductsListStatus.failure,
            failure: const UnknownFailure(),
          ),
        );
      }
      return false;
    }
  }

  Future<void> _fetch({
    required int page,
    required bool replace,
    required bool showLoading,
    bool refreshing = false,
    bool loadMore = false,
  }) async {
    if (isClosed) return;
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
        page: page,
        limit: state.limit,
      );

      final updated = replace
          ? response.items
          : [...state.products, ...response.items];

      if (isClosed) return;
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
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ProductsListStatus.failure,
          isLoadingMore: false,
          isRefreshing: false,
          failure: failure,
        ),
      );
    } catch (_) {
      if (isClosed) return;
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
