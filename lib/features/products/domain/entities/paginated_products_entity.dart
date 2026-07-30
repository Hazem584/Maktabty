import 'package:equatable/equatable.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';

class PaginatedProductsEntity extends Equatable {
  final List<ProductEntity> items;
  final int page;
  final int limit;
  final int total;

  const PaginatedProductsEntity({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  bool get hasMore => total > 0 && items.length < total;

  @override
  List<Object?> get props => [items, page, limit, total];
}
