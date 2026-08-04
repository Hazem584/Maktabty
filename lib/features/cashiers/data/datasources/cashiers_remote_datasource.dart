import 'package:dio/dio.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';
import 'package:maktabty/core/network/json_helpers.dart';
import 'package:maktabty/features/cashiers/data/models/cashier_model.dart';

class CashiersRemoteDataSource {
  final Dio _dio;

  CashiersRemoteDataSource(this._dio);

  Future<({List<CashierModel> items, int page, int limit, int total})> getCashiers({String? search, bool? isActive, int page = 1, int limit = 20}) async {
    final response = await _dio.get('/users/cashiers', queryParameters: {if (search != null && search.isNotEmpty) 'search': search, 'isActive': ?isActive, 'page': page, 'limit': limit});
    final root = paginationObject(response.data, operation: 'GET /users/cashiers');
    final items = unwrapList(root, operation: 'GET /users/cashiers').map((item) => CashierModel.fromJson(requireStringMap(item, operation: 'GET /users/cashiers', field: 'data[]'))).toList(growable: false);
    final meta = paginationMeta(root, itemCount: items.length);
    return (items: items, page: meta.page, limit: meta.limit, total: meta.total);
  }

  Future<CashierModel> getCashier(String id) async => _parseCashier((await _dio.get('/users/cashiers/$id')).data, 'GET /users/cashiers/:id');

  Future<CashierModel> createCashier(Map<String, Object?> data) async => _parseCashier((await _dio.post('/users/cashiers', data: data)).data, 'POST /users/cashiers');

  Future<CashierModel> updateCashier(String id, Map<String, Object?> data) async => _parseCashier((await _dio.patch('/users/cashiers/$id', data: data)).data, 'PATCH /users/cashiers/:id');

  Future<CashierModel> setCashierStatus(String id, bool isActive) async => _parseCashier((await _dio.patch('/users/cashiers/$id/status', data: {'isActive': isActive})).data, 'PATCH /users/cashiers/:id/status');

  Future<CashierModel> resetCashierPassword(String id, String password) async => _parseCashier((await _dio.patch('/users/cashiers/$id/password', data: {'password': password})).data, 'PATCH /users/cashiers/:id/password');

  CashierModel _parseCashier(Object? data, String operation) => CashierModel.fromJson(unwrapObject(data, operation: operation, keys: const ['data', 'cashier', 'user']));
}
