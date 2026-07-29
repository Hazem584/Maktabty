import 'package:maktabty/features/products/domain/entities/product_entity.dart';

enum ProductsListStatus { initial, loading, success, failure }

class ProductsListState {
  final ProductsListStatus status;
  final List<ProductEntity> products;
  final int page;
  final int limit;
  final int total;
  final String search;
  final bool lowStock;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? errorMessage;

  const ProductsListState({
    required this.status,
    required this.products,
    required this.page,
    required this.limit,
    required this.total,
    required this.search,
    required this.lowStock,
    required this.isLoadingMore,
    required this.isRefreshing,
    required this.errorMessage,
  });

  factory ProductsListState.initial() {
    return const ProductsListState(
      status: ProductsListStatus.initial,
      products: [],
      page: 1,
      limit: 20,
      total: 0,
      search: '',
      lowStock: false,
      isLoadingMore: false,
      isRefreshing: false,
      errorMessage: null,
    );
  }

  bool get hasReachedEnd => total > 0 && products.length >= total;

  ProductsListState copyWith({
    ProductsListStatus? status,
    List<ProductEntity>? products,
    int? page,
    int? limit,
    int? total,
    String? search,
    bool? lowStock,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return ProductsListState(
      status: status ?? this.status,
      products: products ?? this.products,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      search: search ?? this.search,
      lowStock: lowStock ?? this.lowStock,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
    );
  }
}
