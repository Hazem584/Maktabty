class ReceiptTotalsEntity {
  final double subtotal;
  final double discount;
  final double tax;
  final double total;

  const ReceiptTotalsEntity({
    required this.subtotal,
    this.discount = 0,
    this.tax = 0,
    required this.total,
  });
}
