import 'package:maktabty/features/products/domain/entities/product_entity.dart';

enum ProductFormStatus { idle, loading, success, failure }

class ProductFormState {
  final ProductFormStatus status;
  final ProductEntity? product;
  final String? message;

  const ProductFormState({
    required this.status,
    required this.product,
    required this.message,
  });

  factory ProductFormState.initial() {
    return const ProductFormState(
      status: ProductFormStatus.idle,
      product: null,
      message: null,
    );
  }

  ProductFormState copyWith({
    ProductFormStatus? status,
    ProductEntity? product,
    String? message,
  }) {
    return ProductFormState(
      status: status ?? this.status,
      product: product ?? this.product,
      message: message,
    );
  }
}
