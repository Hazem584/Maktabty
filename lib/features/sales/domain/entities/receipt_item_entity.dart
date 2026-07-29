class ReceiptItemEntity {
  final String productId;
  final String name;
  final String? code;
  final int qty;
  final double unitPrice;
  final double lineTotal;

  const ReceiptItemEntity({
    required this.productId,
    required this.name,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
    this.code,
  });
}
