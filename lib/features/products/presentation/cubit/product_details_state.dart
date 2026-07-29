import 'package:maktabty/features/products/domain/entities/product_entity.dart';

enum ProductDetailsStatus { initial, loading, success, failure }

class ProductDetailsState {
  final ProductDetailsStatus status;
  final ProductEntity? product;
  final String? message;

  const ProductDetailsState({
    required this.status,
    required this.product,
    required this.message,
  });

  factory ProductDetailsState.initial() {
    return const ProductDetailsState(
      status: ProductDetailsStatus.initial,
      product: null,
      message: null,
    );
  }

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    ProductEntity? product,
    String? message,
  }) {
    return ProductDetailsState(
      status: status ?? this.status,
      product: product ?? this.product,
      message: message,
    );
  }
}
