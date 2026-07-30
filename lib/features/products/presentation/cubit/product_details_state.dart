import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/utils/copy_with_sentinel.dart';

enum ProductDetailsStatus { initial, loading, success, failure }

class ProductDetailsState extends Equatable {
  final ProductDetailsStatus status;
  final ProductEntity? product;
  final AppFailure? failure;

  const ProductDetailsState({
    required this.status,
    required this.product,
    required this.failure,
  });

  factory ProductDetailsState.initial() {
    return const ProductDetailsState(
      status: ProductDetailsStatus.initial,
      product: null,
      failure: null,
    );
  }

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    Object? product = stateFieldUnchanged,
    Object? failure = stateFieldUnchanged,
  }) {
    return ProductDetailsState(
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
