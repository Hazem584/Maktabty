import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocaleStorage {
  static const _localeKey = 'app_locale';

  final FlutterSecureStorage _storage;

  LocaleStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveLocaleCode(String code) {
    return _storage.write(key: _localeKey, value: code);
  }

  Future<String?> getLocaleCode() {
    return _storage.read(key: _localeKey);
  }

  Future<void> clearLocale() {
    return _storage.delete(key: _localeKey);
  }
}
