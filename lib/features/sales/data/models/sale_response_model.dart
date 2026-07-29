import 'package:maktabty/features/sales/data/models/receipt_model.dart';
import 'package:maktabty/features/sales/data/models/receipt_store_model.dart';
import 'package:maktabty/features/sales/data/models/receipt_totals_model.dart';
import 'package:maktabty/features/sales/data/models/sale_model.dart';
import 'package:maktabty/features/sales/domain/entities/sale_response_entity.dart';

class SaleResponseModel {
  final SaleModel sale;
  final ReceiptModel receipt;

  const SaleResponseModel({
    required this.sale,
    required this.receipt,
  });

  factory SaleResponseModel.fromJson(Map<String, dynamic> json) {
    final saleData = json['sale'] ?? json['data'] ?? json['saleData'] ?? json;
    SaleModel sale;
    if (saleData is Map<String, dynamic>) {
      sale = SaleModel.fromJson(saleData);
    } else if (saleData is Map) {
      sale = SaleModel.fromJson(Map<String, dynamic>.from(saleData));
    } else {
      sale = const SaleModel(
        id: '',
        items: [],
        totalAmount: 0,
        createdAt: null,
        user: null,
      );
    }

    final receiptData = json['receipt'] ?? json['receiptData'];
    ReceiptModel receipt;
    if (receiptData is Map<String, dynamic>) {
      receipt = ReceiptModel.fromJson(receiptData);
    } else if (receiptData is Map) {
      receipt = ReceiptModel.fromJson(Map<String, dynamic>.from(receiptData));
    } else {
      receipt = ReceiptModel(
        receiptNo: '',
        createdAt: sale.createdAt,
        store: const ReceiptStoreModel(name: ''),
        cashier: null,
        items: const [],
        totals: ReceiptTotalsModel(
          subtotal: sale.totalAmount,
          total: sale.totalAmount,
        ),
        payment: null,
        footerLines: const [],
      );
    }

    return SaleResponseModel(sale: sale, receipt: receipt);
  }

  SaleResponseEntity toEntity() {
    return SaleResponseEntity(
      sale: sale.toEntity(),
      receipt: receipt.toEntity(),
    );
  }
}
