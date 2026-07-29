import 'package:maktabty/features/sales/domain/entities/receipt_store_entity.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class ReceiptStoreModel {
  final String name;
  final String? address;
  final String? phone;
  final String? taxNumber;

  const ReceiptStoreModel({
    required this.name,
    this.address,
    this.phone,
    this.taxNumber,
  });

  factory ReceiptStoreModel.fromJson(Map<String, dynamic> json) {
    return ReceiptStoreModel(
      name: requireString(json, const [
        'name',
      ], operation: 'parse receipt store'),
      address: json['address']?.toString(),
      phone: json['phone']?.toString(),
      taxNumber: json['taxNumber']?.toString(),
    );
  }

  ReceiptStoreEntity toEntity() {
    return ReceiptStoreEntity(
      name: name,
      address: address,
      phone: phone,
      taxNumber: taxNumber,
    );
  }
}
