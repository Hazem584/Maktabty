import 'package:maktabty/features/sales/domain/entities/receipt_totals_entity.dart';

class ReceiptTotalsModel {
  final double subtotal;
  final double discount;
  final double tax;
  final double total;

  const ReceiptTotalsModel({
    required this.subtotal,
    this.discount = 0,
    this.tax = 0,
    required this.total,
  });

  factory ReceiptTotalsModel.fromJson(Map<String, dynamic> json) {
    return ReceiptTotalsModel(
      subtotal: _toDouble(json['subtotal']),
      discount: _toDouble(json['discount']),
      tax: _toDouble(json['tax']),
      total: _toDouble(json['total']),
    );
  }

  ReceiptTotalsEntity toEntity() {
    return ReceiptTotalsEntity(
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      total: total,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
