import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maktabty/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:maktabty/features/auth/data/models/auth_response_model.dart';
import 'package:maktabty/features/auth/data/models/user_model.dart';
import 'package:maktabty/features/auth/domain/validation/auth_validator.dart';
import 'package:maktabty/core/validation/validation_result.dart';

class _Adapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) callback;
  _Adapter(this.callback);
  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) => callback(options);
  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object body) => ResponseBody.fromString(jsonEncode(body), 200, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});

void main() {
  final userJson = <String, dynamic>{
    'id': 'user-1',
    'fullName': 'Store Owner',
    'email': 'owner@example.com',
    'role': 'OWNER',
    'storeId': 'store-1',
    'isActive': true,
  };

  test('user parser reads trusted store membership and active status', () {
    final user = UserModel.fromJson(userJson).toEntity();
    expect(user.storeId, 'store-1');
    expect(user.isActive, isTrue);
    expect(user.hasTrustedStoreMembership, isTrue);
  });

  test('registration response parses its store while login may omit it', () {
    final registration = AuthResponseModel.fromJson({'user': userJson, 'store': {'id': 'store-1', 'name': 'Downtown Market'}, 'accessToken': 'access', 'refreshToken': 'refresh'});
    final login = AuthResponseModel.fromJson({'user': userJson, 'accessToken': 'access', 'refreshToken': 'refresh'});
    expect(registration.store?.toEntity().name, 'Downtown Market');
    expect(login.store, isNull);
  });

  test('registration sends storeName and excludes role and storeId', () async {
    RequestOptions? captured;
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test'));
    dio.httpClientAdapter = _Adapter((options) async {
      captured = options;
      return _json({'user': userJson, 'store': {'id': 'store-1', 'name': 'Downtown Market'}, 'accessToken': 'access', 'refreshToken': 'refresh'});
    });
    final source = AuthRemoteDataSource(dio, dio);

    await source.register(fullName: 'Store Owner', storeName: 'Downtown Market', email: 'owner@example.com', password: 'password123');

    final data = Map<String, dynamic>.from(captured!.data as Map);
    expect(data['storeName'], 'Downtown Market');
    expect(data.containsKey('role'), isFalse);
    expect(data.containsKey('storeId'), isFalse);
  });

  test('old cached-style user JSON remains parseable but is not trusted', () {
    final user = UserModel.fromJson({'id': 'user-1', 'fullName': 'Owner', 'email': 'owner@example.com', 'role': 'OWNER'}).toEntity();
    expect(user.storeId, isNull);
    expect(user.hasTrustedStoreMembership, isFalse);
  });

  test('registration requires and trims the store name', () {
    final missing = AuthValidator.registration(fullName: 'Owner', storeName: '  ', email: 'owner@example.com', password: 'password123', confirmPassword: 'password123');
    final valid = AuthValidator.registration(fullName: ' Owner ', storeName: ' Downtown Market ', email: 'OWNER@example.com', password: 'password123', confirmPassword: 'password123');
    expect(missing.error, ValidationKey.storeNameRequired);
    expect(valid.value?.storeName, 'Downtown Market');
    expect(valid.value?.email, 'owner@example.com');
  });
}
