import 'package:maktabty/features/sales/domain/entities/receipt_cashier_entity.dart';

class ReceiptCashierModel {
  final String id;
  final String fullName;

  const ReceiptCashierModel({
    required this.id,
    required this.fullName,
  });

  factory ReceiptCashierModel.fromJson(Map<String, dynamic> json) {
    return ReceiptCashierModel(
      id: (json['id'] ?? '').toString(),
      fullName: (json['fullName'] ?? json['name'] ?? '').toString(),
    );
  }

  ReceiptCashierEntity toEntity() {
    return ReceiptCashierEntity(
      id: id,
      fullName: fullName,
    );
  }
}
