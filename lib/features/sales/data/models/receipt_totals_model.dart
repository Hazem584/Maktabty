import 'package:maktabty/features/sales/domain/entities/receipt_totals_entity.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

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
    const operation = 'parse receipt totals';
    return ReceiptTotalsModel(
      subtotal: requireDouble(json, const ['subtotal'], operation: operation),
      discount: json['discount'] == null
          ? 0
          : requireDouble(json, const ['discount'], operation: operation),
      tax: json['tax'] == null
          ? 0
          : requireDouble(json, const ['tax'], operation: operation),
      total: requireDouble(json, const ['total'], operation: operation),
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
}
