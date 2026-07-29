import 'package:maktabty/features/sales/domain/entities/receipt_cashier_entity.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class ReceiptCashierModel {
  final String id;
  final String fullName;

  const ReceiptCashierModel({required this.id, required this.fullName});

  factory ReceiptCashierModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse receipt cashier';
    return ReceiptCashierModel(
      id: requireString(json, const ['id'], operation: operation),
      fullName: requireString(json, const [
        'fullName',
        'name',
      ], operation: operation),
    );
  }

  ReceiptCashierEntity toEntity() {
    return ReceiptCashierEntity(id: id, fullName: fullName);
  }
}
