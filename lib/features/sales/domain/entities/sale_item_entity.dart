import 'package:equatable/equatable.dart';
import 'package:maktabty/features/sales/domain/entities/product_mini_entity.dart';

class SaleItemEntity extends Equatable {
  final ProductMiniEntity? product;
  final int quantity;
  final double unitPrice;
  final double lineTotal;

  const SaleItemEntity({
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  });

  @override
  List<Object?> get props => [product, quantity, unitPrice, lineTotal];
}
