import 'package:dio/dio.dart';
import 'package:maktabty/features/sales/data/models/receipt_model.dart';
import 'package:maktabty/features/sales/data/models/receipt_store_model.dart';
import 'package:maktabty/features/sales/data/models/receipt_totals_model.dart';
import 'package:maktabty/features/sales/data/models/sale_model.dart';
import 'package:maktabty/features/sales/data/models/sale_response_model.dart';
import 'package:maktabty/features/sales/data/models/today_sales_response_model.dart';
import 'package:maktabty/features/sales/data/models/today_sales_summary_model.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_input.dart';

class SalesRemoteDataSource {
  final Dio _dio;

  SalesRemoteDataSource(this._dio);

  Future<SaleResponseModel> createSale({
    required List<SaleItemInput> items,
    required PaymentMethod paymentMethod,
    double? paidAmount,
    double? cashAmount,
    double? cardAmount,
  }) async {
    final response = await _dio.post(
      '/sales',
      data: {
        'items': items.map((item) => item.toJson()).toList(),
        'paymentMethod': paymentMethod.apiValue,
        'paidAmount': ?paidAmount,
        'cashAmount': ?cashAmount,
        'cardAmount': ?cardAmount,
      },
    );
    return _parseSaleResponse(response.data);
  }

  Future<SaleResponseModel> createSaleByCode({
    required String code,
    required int quantity,
    required PaymentMethod paymentMethod,
    double? unitPriceOverride,
    double? paidAmount,
    double? cashAmount,
    double? cardAmount,
  }) async {
    final response = await _dio.post(
      '/sales/by-code',
      data: {
        'code': code,
        'quantity': quantity,
        'paymentMethod': paymentMethod.apiValue,
        'unitPriceOverride': ?unitPriceOverride,
        'paidAmount': ?paidAmount,
        'cashAmount': ?cashAmount,
        'cardAmount': ?cardAmount,
      },
    );
    return _parseSaleResponse(response.data);
  }

  Future<TodaySalesResponseModel> getTodaySales({String? date}) async {
    final response = await _dio.get(
      '/sales/today',
      queryParameters: {if (date != null && date.isNotEmpty) 'date': date},
    );
    return _parseTodaySales(response.data);
  }

  Future<SaleModel> deleteSale(String saleId) async {
    final response = await _dio.delete('/sales/$saleId');
    return _parseSale(response.data);
  }

  Future<ReceiptModel> getReceiptForSale(String saleId) async {
    final response = await _dio.get('/sales/$saleId/receipt');
    return _parseReceipt(response.data);
  }

  SaleResponseModel _parseSaleResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return SaleResponseModel.fromJson(data);
    }
    if (data is Map) {
      return SaleResponseModel.fromJson(Map<String, dynamic>.from(data));
    }
    return const SaleResponseModel(
      sale: SaleModel(
        id: '',
        items: [],
        totalAmount: 0,
        createdAt: null,
        user: null,
      ),
      receipt: ReceiptModel(
        receiptNo: '',
        createdAt: null,
        store: ReceiptStoreModel(name: ''),
        cashier: null,
        items: [],
        totals: ReceiptTotalsModel(subtotal: 0, total: 0),
        payment: null,
        footerLines: [],
      ),
    );
  }

  TodaySalesResponseModel _parseTodaySales(dynamic data) {
    if (data is Map<String, dynamic>) {
      return TodaySalesResponseModel.fromJson(data);
    }
    if (data is Map) {
      return TodaySalesResponseModel.fromJson(Map<String, dynamic>.from(data));
    }
    return const TodaySalesResponseModel(
      data: [],
      summary: TodaySalesSummaryModel(totalAmount: 0, itemsCount: 0),
    );
  }

  SaleModel _parseSale(dynamic data) {
    if (data is Map<String, dynamic>) {
      final saleData = data['sale'] ?? data['data'] ?? data;
      if (saleData is Map<String, dynamic>) {
        return SaleModel.fromJson(saleData);
      }
      if (saleData is Map) {
        return SaleModel.fromJson(Map<String, dynamic>.from(saleData));
      }
      return SaleModel.fromJson(data);
    }
    if (data is Map) {
      final saleData = data['sale'] ?? data['data'] ?? data;
      if (saleData is Map) {
        return SaleModel.fromJson(Map<String, dynamic>.from(saleData));
      }
      return SaleModel.fromJson(Map<String, dynamic>.from(data));
    }
    return const SaleModel(
      id: '',
      items: [],
      totalAmount: 0,
      createdAt: null,
      user: null,
    );
  }

  ReceiptModel _parseReceipt(dynamic data) {
    if (data is Map<String, dynamic>) {
      return _parseReceiptMap(data);
    }
    if (data is Map) {
      return _parseReceiptMap(Map<String, dynamic>.from(data));
    }
    return const ReceiptModel(
      receiptNo: '',
      createdAt: null,
      store: ReceiptStoreModel(name: ''),
      cashier: null,
      items: [],
      totals: ReceiptTotalsModel(subtotal: 0, total: 0),
      payment: null,
      footerLines: [],
    );
  }

  ReceiptModel _parseReceiptMap(Map<String, dynamic> data) {
    final receiptData = data['receipt'] ?? data['receiptData'] ?? data['data'];
    if (receiptData is Map<String, dynamic>) {
      return ReceiptModel.fromJson(receiptData);
    }
    if (receiptData is Map) {
      return ReceiptModel.fromJson(Map<String, dynamic>.from(receiptData));
    }
    if (data.containsKey('receiptNo') ||
        data.containsKey('receipt_no') ||
        data.containsKey('store') ||
        data.containsKey('totals')) {
      return ReceiptModel.fromJson(data);
    }
    return const ReceiptModel(
      receiptNo: '',
      createdAt: null,
      store: ReceiptStoreModel(name: ''),
      cashier: null,
      items: [],
      totals: ReceiptTotalsModel(subtotal: 0, total: 0),
      payment: null,
      footerLines: [],
    );
  }
}
