import 'package:maktabty/features/sales/domain/entities/receipt_item_entity.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

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
    const operation = 'parse receipt item';
    return ReceiptItemModel(
      productId: requireString(json, const [
        'productId',
        'product_id',
      ], operation: operation),
      name: requireString(json, const ['name'], operation: operation),
      code: json['code']?.toString(),
      qty: requireInt(json, const ['qty', 'quantity'], operation: operation),
      unitPrice: requireDouble(json, const [
        'unitPrice',
        'unit_price',
      ], operation: operation),
      lineTotal: requireDouble(json, const [
        'lineTotal',
        'line_total',
      ], operation: operation),
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
}
