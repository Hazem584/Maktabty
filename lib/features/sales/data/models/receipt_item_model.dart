import 'package:maktabty/features/sales/domain/entities/receipt_item_entity.dart';

class ReceiptItemModel {
  final String productId;
  final String name;
  final String? code;
  final int qty;
  final double unitPrice;
  final double lineTotal;

  const ReceiptItemModel({
    required this.productId,
    required this.name,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
    this.code,
  });

  factory ReceiptItemModel.fromJson(Map<String, dynamic> json) {
    return ReceiptItemModel(
      productId: (json['productId'] ?? json['product_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      code: json['code']?.toString(),
      qty: _toInt(json['qty'] ?? json['quantity']),
      unitPrice: _toDouble(json['unitPrice'] ?? json['unit_price']),
      lineTotal: _toDouble(json['lineTotal'] ?? json['line_total']),
    );
  }

  ReceiptItemEntity toEntity() {
    return ReceiptItemEntity(
      productId: productId,
      name: name,
      qty: qty,
      unitPrice: unitPrice,
      lineTotal: lineTotal,
      code: code,
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
