import 'package:dio/dio.dart';
import 'package:maktabty/features/sales/data/models/receipt_model.dart';
import 'package:maktabty/features/sales/data/models/sale_model.dart';
import 'package:maktabty/features/sales/data/models/today_sales_response_model.dart';
import 'package:maktabty/features/sales/data/models/sync_sale_models.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class SalesRemoteDataSource {
  final Dio _dio;

  SalesRemoteDataSource(this._dio);

  Future<TodaySalesResponseModel> getTodaySales({String? date}) async {
    final response = await _dio.get(
      '/sales/today',
      queryParameters: {if (date != null && date.isNotEmpty) 'date': date},
    );
    return _parseTodaySales(response.data);
  }

  Future<SyncSalesResponseModel> syncSales(
    List<SyncSaleRequestModel> sales, {
    CancelToken? cancelToken,
  }) async {
    if (sales.isEmpty || sales.length > 50) {
      throw ArgumentError.value(
        sales.length,
        'sales',
        'A sync batch must contain between 1 and 50 sales.',
      );
    }
    final response = await _dio.post(
      '/sales/sync',
      data: {
        'sales': sales.map((sale) => sale.toJson()).toList(growable: false),
      },
      cancelToken: cancelToken,
    );
    return SyncSalesResponseModel.fromJson(response.data);
  }

  Future<SaleModel> deleteSale(String saleId) async {
    final response = await _dio.delete('/sales/$saleId');
    return _parseSale(response.data);
  }

  Future<ReceiptModel> getReceiptForSale(String saleId) async {
    final response = await _dio.get('/sales/$saleId/receipt');
    return _parseReceipt(response.data);
  }

  TodaySalesResponseModel _parseTodaySales(dynamic data) {
    return TodaySalesResponseModel.fromJson(
      requireStringMap(data, operation: 'GET /sales/today'),
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
    throw const DataParsingException(
      operation: 'DELETE /sales/:id',
      expected: 'sale JSON object',
    );
  }

  ReceiptModel _parseReceipt(dynamic data) {
    if (data is Map<String, dynamic>) {
      return _parseReceiptMap(data);
    }
    if (data is Map) {
      return _parseReceiptMap(Map<String, dynamic>.from(data));
    }
    throw const DataParsingException(
      operation: 'GET /sales/:id/receipt',
      expected: 'receipt JSON object',
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
    throw const DataParsingException(
      operation: 'GET /sales/:id/receipt',
      expected: 'receipt JSON object',
    );
  }
}
