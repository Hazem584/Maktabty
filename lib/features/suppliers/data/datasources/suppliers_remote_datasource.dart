import 'package:dio/dio.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';
import 'package:maktabty/core/network/json_helpers.dart';
import 'package:maktabty/features/suppliers/data/models/supplier_models.dart';
import 'package:maktabty/features/suppliers/domain/entities/supplier_entities.dart';

class SuppliersRemoteDataSource {
  final Dio _dio;
  SuppliersRemoteDataSource(this._dio);

  Future<({List<SupplierModel> items, int page, int limit, int total})> getSuppliers({String? search, bool? isActive, int page = 1, int limit = 20}) async {
    final response = await _dio.get('/suppliers', queryParameters: {if (search != null && search.isNotEmpty) 'search': search, 'isActive': ?isActive, 'page': page, 'limit': limit});
    final root = paginationObject(response.data, operation: 'GET /suppliers');
    final items = unwrapList(root, operation: 'GET /suppliers').map((item) => SupplierModel.fromJson(requireStringMap(item, operation: 'GET /suppliers', field: 'data[]'))).toList(growable: false);
    final meta = paginationMeta(root, itemCount: items.length);
    return (items: items, page: meta.page, limit: meta.limit, total: meta.total);
  }

  Future<SupplierModel> getSupplier(String id) async => _supplier((await _dio.get('/suppliers/$id')).data, 'GET /suppliers/:id');
  Future<SupplierModel> createSupplier(Map<String, Object?> data) async => _supplier((await _dio.post('/suppliers', data: data)).data, 'POST /suppliers');
  Future<SupplierModel> updateSupplier(String id, Map<String, Object?> data) async => _supplier((await _dio.patch('/suppliers/$id', data: data)).data, 'PATCH /suppliers/:id');
  Future<SupplierModel> deactivateSupplier(String id) async {
    final response = await _dio.delete('/suppliers/$id');
    if (response.data == null || response.data == '') {
      return getSupplier(id);
    }
    return _supplier(response.data, 'DELETE /suppliers/:id');
  }

  Future<List<SupplierPaymentModel>> getPayments(String id) async {
    final response = await _dio.get('/suppliers/$id/payments');
    return unwrapList(response.data, operation: 'GET /suppliers/:id/payments').map((item) => SupplierPaymentModel.fromJson(requireStringMap(item, operation: 'GET /suppliers/:id/payments'))).toList(growable: false);
  }

  Future<SupplierPaymentModel> createPayment(String id, Map<String, Object?> data) async {
    final response = await _dio.post('/suppliers/$id/payments', data: data);
    return SupplierPaymentModel.fromJson(unwrapObject(response.data, operation: 'POST /suppliers/:id/payments', keys: const ['data', 'payment']));
  }

  Future<SupplierStatementModel> getStatement(String id, {DateTime? from, DateTime? to}) async {
    final response = await _dio.get('/suppliers/$id/statement', queryParameters: {if (from != null) 'from': from.toIso8601String(), if (to != null) 'to': to.toIso8601String()});
    return SupplierStatementModel.fromJson(unwrapObject(response.data, operation: 'GET /suppliers/:id/statement', keys: const ['data', 'statement']));
  }

  SupplierModel _supplier(Object? data, String operation) => SupplierModel.fromJson(unwrapObject(data, operation: operation, keys: const ['data', 'supplier']));

  static String methodValue(SupplierPaymentMethod method) => switch (method) {
    SupplierPaymentMethod.cash => 'CASH',
    SupplierPaymentMethod.card => 'CARD',
    SupplierPaymentMethod.bankTransfer => 'BANK_TRANSFER',
    SupplierPaymentMethod.other || SupplierPaymentMethod.unknown => 'OTHER',
  };
}
