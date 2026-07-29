import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_payment_entity.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class ReceiptPaymentModel {
  final PaymentMethod method;
  final double? paidAmount;
  final double? cashAmount;
  final double? cardAmount;
  final double? changeAmount;

  const ReceiptPaymentModel({
    required this.method,
    this.paidAmount,
    this.cashAmount,
    this.cardAmount,
    this.changeAmount,
  });

  factory ReceiptPaymentModel.fromJson(Map<String, dynamic> json) {
    return ReceiptPaymentModel(
      method: PaymentMethodX.fromApi(json['method']),
      paidAmount: _toNullableDouble(json['paidAmount']),
      cashAmount: _toNullableDouble(json['cashAmount']),
      cardAmount: _toNullableDouble(json['cardAmount']),
      changeAmount: _toNullableDouble(json['changeAmount']),
    );
  }

  ReceiptPaymentEntity toEntity() {
    return ReceiptPaymentEntity(
      method: method,
      paidAmount: paidAmount,
      cashAmount: cashAmount,
      cardAmount: cardAmount,
      changeAmount: changeAmount,
    );
  }

  static double? _toNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    final parsed = double.tryParse(value.toString());
    if (parsed != null) return parsed;
    throw const DataParsingException(
      operation: 'parse receipt payment',
      expected: 'number or numeric string',
      field: 'payment amount',
    );
  }
}
