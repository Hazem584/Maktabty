class ReceiptStoreEntity {
  final String name;
  final String? address;
  final String? phone;
  final String? taxNumber;

  const ReceiptStoreEntity({
    required this.name,
    this.address,
    this.phone,
    this.taxNumber,
  });
}
