import 'package:dio/dio.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';
import 'package:maktabty/core/network/json_helpers.dart';
import 'package:maktabty/features/purchases/data/models/purchase_models.dart';
import 'package:maktabty/features/purchases/domain/entities/purchase_entities.dart';

class PurchasesRemoteDataSource {
  final Dio _dio;
  PurchasesRemoteDataSource(this._dio);

  Future<({List<PurchaseInvoiceModel> items, int page, int limit, int total})> getPurchases({String? supplierId, PurchaseStatus? status, String? search, DateTime? from, DateTime? to, int page = 1, int limit = 20}) async {
    final response = await _dio.get('/purchases', queryParameters: {
      'supplierId': ?supplierId,
      if (status != null && status != PurchaseStatus.unknown) 'status': status.name.toUpperCase(),
      if (search?.isNotEmpty == true) 'search': search,
      if (from != null) 'from': from.toIso8601String(),
      if (to != null) 'to': to.toIso8601String(),
      'page': page,
      'limit': limit,
    });
    final root = paginationObject(response.data, operation: 'GET /purchases');
    final items = unwrapList(root, operation: 'GET /purchases').map((value) => PurchaseInvoiceModel.fromJson(requireStringMap(value, operation: 'GET /purchases', field: 'data[]'))).toList(growable: false);
    final meta = paginationMeta(root, itemCount: items.length);
    return (items: items, page: meta.page, limit: meta.limit, total: meta.total);
  }

  Future<PurchaseInvoiceModel> getPurchase(String id) async => _purchase((await _dio.get('/purchases/$id')).data, 'GET /purchases/:id');
  Future<PurchaseInvoiceModel> createDraft(Map<String, Object?> data) async => _purchase((await _dio.post('/purchases', data: data)).data, 'POST /purchases');
  Future<PurchaseInvoiceModel> updateDraft(String id, Map<String, Object?> data) async => _purchase((await _dio.patch('/purchases/$id', data: data)).data, 'PATCH /purchases/:id');

  Future<void> deleteDraft(String id) async {
    await _dio.delete('/purchases/$id');
  }

  Future<PurchaseInvoiceModel> postDraft(String id) async => _purchase((await _dio.post('/purchases/$id/post')).data, 'POST /purchases/:id/post');

  PurchaseInvoiceModel _purchase(Object? data, String operation) => PurchaseInvoiceModel.fromJson(unwrapObject(data, operation: operation, keys: const ['data', 'purchase', 'invoice']));
}
