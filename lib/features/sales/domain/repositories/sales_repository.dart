import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_input.dart';
import 'package:maktabty/features/sales/domain/entities/sale_response_entity.dart';
import 'package:maktabty/features/sales/domain/entities/today_sales_response_entity.dart';

abstract class SalesRepository {
  Future<SaleResponseEntity> createSale({
    required List<SaleItemInput> items,
    required PaymentMethod paymentMethod,
    double? paidAmount,
    double? cashAmount,
    double? cardAmount,
  });

  Future<SaleResponseEntity> createSaleByCode({
    required String code,
    required int quantity,
    required PaymentMethod paymentMethod,
    double? unitPriceOverride,
    double? paidAmount,
    double? cashAmount,
    double? cardAmount,
  });

  Future<TodaySalesResponseEntity> getTodaySales({String? date});

  Future<SaleEntity> deleteSale({required String id});

  Future<ReceiptEntity> getReceiptForSale(String saleId);
}
