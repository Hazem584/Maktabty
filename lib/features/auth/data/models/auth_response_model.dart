import 'package:maktabty/features/auth/data/models/user_model.dart';
import 'package:maktabty/features/auth/data/models/store_model.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class AuthResponseModel {
  final UserModel user;
  final StoreModel? store;
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  const AuthResponseModel({
    required this.user,
    this.store,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse authentication response';
    final userJson = _extractUserJson(json);
    return AuthResponseModel(
      user: UserModel.fromJson(userJson),
      store: _extractStore(json),
      accessToken: requireString(json, const [
        'accessToken',
        'access_token',
      ], operation: operation),
      refreshToken: requireString(json, const [
        'refreshToken',
        'refresh_token',
      ], operation: operation),
      tokenType: (json['tokenType'] ?? 'Bearer').toString(),
    );
  }

  static StoreModel? _extractStore(Map<String, dynamic> json) {
    final value = json['store'];
    if (value == null) return null;
    return StoreModel.fromJson(
      requireStringMap(
        value,
        operation: 'parse authentication response',
        field: 'store',
      ),
    );
  }

  static Map<String, dynamic> _extractUserJson(Map<String, dynamic> json) {
    final user = json['user'];
    if (user is Map<String, dynamic>) {
      return user;
    }
    if (user is Map) {
      return requireStringMap(
        user,
        operation: 'parse authentication response',
        field: 'user',
      );
    }
    throw const DataParsingException(
      operation: 'parse authentication response',
      expected: 'user JSON object',
      field: 'user',
    );
  }
}
