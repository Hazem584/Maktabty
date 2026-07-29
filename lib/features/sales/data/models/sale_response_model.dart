import 'package:maktabty/features/sales/data/models/receipt_model.dart';
import 'package:maktabty/features/sales/data/models/sale_model.dart';
import 'package:maktabty/features/sales/domain/entities/sale_response_entity.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class SaleResponseModel {
  final SaleModel sale;
  final ReceiptModel receipt;

  const SaleResponseModel({required this.sale, required this.receipt});

  factory SaleResponseModel.fromJson(Map<String, dynamic> json) {
    final saleData = json['sale'] ?? json['data'] ?? json['saleData'] ?? json;
    const operation = 'parse sale response';
    final sale = SaleModel.fromJson(
      requireStringMap(saleData, operation: operation, field: 'sale'),
    );

    final receiptData = json['receipt'] ?? json['receiptData'];
    final receipt = ReceiptModel.fromJson(
      requireStringMap(receiptData, operation: operation, field: 'receipt'),
    );

    return SaleResponseModel(sale: sale, receipt: receipt);
  }

  SaleResponseEntity toEntity() {
    return SaleResponseEntity(
      sale: sale.toEntity(),
      receipt: receipt.toEntity(),
    );
  }
}
