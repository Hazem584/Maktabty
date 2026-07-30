import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/utils/copy_with_sentinel.dart';

enum ProductFormStatus { idle, loading, success, failure }

class ProductFormState extends Equatable {
  final ProductFormStatus status;
  final ProductEntity? product;
  final AppFailure? failure;

  const ProductFormState({
    required this.status,
    required this.product,
    required this.failure,
  });

  factory ProductFormState.initial() {
    return const ProductFormState(
      status: ProductFormStatus.idle,
      product: null,
      failure: null,
    );
  }

  ProductFormState copyWith({
    ProductFormStatus? status,
    Object? product = stateFieldUnchanged,
    Object? failure = stateFieldUnchanged,
  }) {
    return ProductFormState(
      status: status ?? this.status,
      product: identical(product, stateFieldUnchanged)
          ? this.product
          : product as ProductEntity?,
      failure: identical(failure, stateFieldUnchanged)
          ? this.failure
          : failure as AppFailure?,
    );
  }

  @override
  List<Object?> get props => [status, product, failure];
}
