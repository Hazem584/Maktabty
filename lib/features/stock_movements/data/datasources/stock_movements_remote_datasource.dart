import 'package:dio/dio.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';
import 'package:maktabty/core/network/json_helpers.dart';
import 'package:maktabty/features/stock_movements/data/models/stock_movement_model.dart';
import 'package:maktabty/features/stock_movements/domain/entities/stock_movement_entities.dart';

class StockMovementsRemoteDataSource {
  final Dio _dio;
  StockMovementsRemoteDataSource(this._dio);

  Future<({List<StockMovementModel> items, int page, int limit, int total})> getMovements({String? productId, StockMovementType? type, String? purchaseInvoiceId, String? saleId, DateTime? from, DateTime? to, int page = 1, int limit = 20}) async {
    final response = await _dio.get('/stock-movements', queryParameters: {
      'productId': ?productId,
      if (type != null && type != StockMovementType.unknown) 'type': _typeValue(type),
      if (purchaseInvoiceId?.isNotEmpty == true) 'purchaseInvoiceId': purchaseInvoiceId,
      if (saleId?.isNotEmpty == true) 'saleId': saleId,
      if (from != null) 'from': from.toIso8601String(),
      if (to != null) 'to': to.toIso8601String(),
      'page': page,
      'limit': limit,
    });
    final root = paginationObject(response.data, operation: 'GET /stock-movements');
    final items = unwrapList(root, operation: 'GET /stock-movements').map((value) => StockMovementModel.fromJson(requireStringMap(value, operation: 'GET /stock-movements', field: 'data[]'))).toList(growable: false);
    final meta = paginationMeta(root, itemCount: items.length);
    return (items: items, page: meta.page, limit: meta.limit, total: meta.total);
  }

  String _typeValue(StockMovementType type) => switch (type) {
    StockMovementType.openingStock => 'OPENING_STOCK',
    StockMovementType.purchase => 'PURCHASE',
    StockMovementType.purchaseReversal => 'PURCHASE_REVERSAL',
    StockMovementType.sale => 'SALE',
    StockMovementType.saleReversal => 'SALE_REVERSAL',
    StockMovementType.manualAdjustment => 'MANUAL_ADJUSTMENT',
    StockMovementType.unknown => 'UNKNOWN',
  };
}
