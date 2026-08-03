import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/utils/copy_with_sentinel.dart';

enum ProductsListStatus { initial, loading, success, failure }

class ProductsListState extends Equatable {
  final ProductsListStatus status;
  final List<ProductEntity> products;
  final int page;
  final int limit;
  final int total;
  final String search;
  final bool lowStock;
  final bool isLoadingMore;
  final bool isRefreshing;
  final AppFailure? failure;
  final bool isFromCache;
  final DateTime? lastCachedAt;
  final ProductStatus productStatus;
  final String? lastUnavailableProductId;
  final int catalogMutationVersion;

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
    required this.failure,
    required this.isFromCache,
    required this.lastCachedAt,
    required this.productStatus,
    required this.lastUnavailableProductId,
    required this.catalogMutationVersion,
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
      failure: null,
      isFromCache: false,
      lastCachedAt: null,
      productStatus: ProductStatus.active,
      lastUnavailableProductId: null,
      catalogMutationVersion: 0,
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
    Object? failure = stateFieldUnchanged,
    bool? isFromCache,
    Object? lastCachedAt = stateFieldUnchanged,
    ProductStatus? productStatus,
    Object? lastUnavailableProductId = stateFieldUnchanged,
    int? catalogMutationVersion,
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
      failure: identical(failure, stateFieldUnchanged)
          ? this.failure
          : failure as AppFailure?,
      isFromCache: isFromCache ?? this.isFromCache,
      lastCachedAt: identical(lastCachedAt, stateFieldUnchanged)
          ? this.lastCachedAt
          : lastCachedAt as DateTime?,
      productStatus: productStatus ?? this.productStatus,
      lastUnavailableProductId:
          identical(lastUnavailableProductId, stateFieldUnchanged)
          ? this.lastUnavailableProductId
          : lastUnavailableProductId as String?,
      catalogMutationVersion:
          catalogMutationVersion ?? this.catalogMutationVersion,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    page,
    limit,
    total,
    search,
    lowStock,
    isLoadingMore,
    isRefreshing,
    failure,
    isFromCache,
    lastCachedAt,
    productStatus,
    lastUnavailableProductId,
    catalogMutationVersion,
  ];
}
