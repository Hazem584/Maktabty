import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _cachedUserIdKey = 'cached_user_id';
  static const _cachedUserEmailKey = 'cached_user_email';
  static const _cachedUserNameKey = 'cached_user_name';
  static const _cachedUserRoleKey = 'cached_user_role';

  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveAccessToken(String token) {
    return _storage.write(key: _accessTokenKey, value: token);
  }

  Future<void> saveRefreshToken(String token) {
    return _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getAccessToken() {
    return _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() {
    return _storage.read(key: _refreshTokenKey);
  }

  Future<void> saveUserIdentity({
    required String id,
    required String email,
    required String fullName,
    String? role,
  }) async {
    await _storage.write(key: _cachedUserIdKey, value: id);
    await _storage.write(key: _cachedUserEmailKey, value: email);
    await _storage.write(key: _cachedUserNameKey, value: fullName);
    if (role == null || role.isEmpty) {
      await _storage.delete(key: _cachedUserRoleKey);
    } else {
      await _storage.write(key: _cachedUserRoleKey, value: role);
    }
  }

  Future<StoredUserIdentity?> getUserIdentity() async {
    final values = await Future.wait([
      _storage.read(key: _cachedUserIdKey),
      _storage.read(key: _cachedUserEmailKey),
      _storage.read(key: _cachedUserNameKey),
      _storage.read(key: _cachedUserRoleKey),
    ]);
    final id = values[0];
    final email = values[1];
    final fullName = values[2];
    if (id == null ||
        id.isEmpty ||
        email == null ||
        email.isEmpty ||
        fullName == null ||
        fullName.isEmpty) {
      return null;
    }
    return StoredUserIdentity(
      id: id,
      email: email,
      fullName: fullName,
      role: values[3],
    );
  }

  Future<void> clearAll() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _cachedUserIdKey);
    await _storage.delete(key: _cachedUserEmailKey);
    await _storage.delete(key: _cachedUserNameKey);
    await _storage.delete(key: _cachedUserRoleKey);
  }
}

class StoredUserIdentity {
  final String id;
  final String email;
  final String fullName;
  final String? role;

  const StoredUserIdentity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
  });
}
