import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maktabty/features/cashiers/data/datasources/cashiers_remote_datasource.dart';
import 'package:maktabty/features/cashiers/data/models/cashier_model.dart';
import 'package:maktabty/features/cashiers/data/repositories/cashiers_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class _Adapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) callback;
  _Adapter(this.callback);
  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) => callback(options);
  @override
  void close({bool force = false}) {}
}

class _MockRemote extends Mock implements CashiersRemoteDataSource {}

ResponseBody _json(Object body) => ResponseBody.fromString(jsonEncode(body), 200, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});

void main() {
  final cashier = <String, dynamic>{'id': 'cashier-1', 'fullName': 'Cashier One', 'email': 'cashier@example.com', 'role': 'CASHIER', 'storeId': 'store-1', 'isActive': true, 'createdAt': '2026-08-01T00:00:00Z'};

  test('list maps pagination, search, and active filter', () async {
    RequestOptions? captured;
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))..httpClientAdapter = _Adapter((options) async { captured = options; return _json({'data': [cashier], 'meta': {'page': 2, 'limit': 20, 'total': 25}}); });
    final source = CashiersRemoteDataSource(dio);
    final result = await source.getCashiers(search: 'ahmed', isActive: false, page: 2, limit: 20);
    expect(captured?.queryParameters, {'search': 'ahmed', 'isActive': false, 'page': 2, 'limit': 20});
    expect(result.page, 2);
    expect(result.total, 25);
    expect(result.items.single.entity.storeId, 'store-1');
  });

  test('create excludes role and store identity', () async {
    RequestOptions? captured;
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))..httpClientAdapter = _Adapter((options) async { captured = options; return _json(cashier); });
    await CashiersRemoteDataSource(dio).createCashier({'fullName': 'Cashier One', 'email': 'cashier@example.com', 'password': 'password123'});
    final data = Map<String, dynamic>.from(captured!.data as Map);
    expect(data.containsKey('role'), isFalse);
    expect(data.containsKey('storeId'), isFalse);
  });

  test('update, status, and password requests contain only allowed fields', () async {
    final requests = <RequestOptions>[];
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))..httpClientAdapter = _Adapter((options) async { requests.add(options); return _json(cashier); });
    final source = CashiersRemoteDataSource(dio);
    await source.updateCashier('cashier-1', {'fullName': 'Updated'});
    await source.setCashierStatus('cashier-1', false);
    await source.resetCashierPassword('cashier-1', 'new-password');
    expect(requests[0].data, {'fullName': 'Updated'});
    expect(requests[1].data, {'isActive': false});
    expect(requests[2].data, {'password': 'new-password'});
  });

  test('repository edit maps only changed allowed fields', () async {
    final remote = _MockRemote();
    when(() => remote.updateCashier('cashier-1', {'email': 'updated@example.com'})).thenAnswer((_) async => CashierModel.fromJson({...cashier, 'email': 'updated@example.com'}));
    final result = await CashiersRepositoryImpl(remote).updateCashier(id: 'cashier-1', email: ' UPDATED@example.com ');
    expect(result.email, 'updated@example.com');
    verify(() => remote.updateCashier('cashier-1', {'email': 'updated@example.com'})).called(1);
  });
}
