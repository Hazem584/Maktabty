class SaleItemInput {
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
}
