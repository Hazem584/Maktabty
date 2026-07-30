import 'package:equatable/equatable.dart';

class SaleItemInput extends Equatable {
  final String productId;
  final int quantity;
  final double? unitPriceOverride;

  const SaleItemInput({
    required this.productId,
    required this.quantity,
    this.unitPriceOverride,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      if (unitPriceOverride != null) 'unitPriceOverride': unitPriceOverride,
    };
  }

  @override
  List<Object?> get props => [productId, quantity, unitPriceOverride];
}
