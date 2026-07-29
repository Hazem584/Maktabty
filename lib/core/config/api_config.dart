import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfigurationException implements Exception {
  final String message;

  const ApiConfigurationException(this.message);

  @override
  String toString() => 'ApiConfigurationException: $message';
}

class ApiConfig {
  static const String _dartDefineUrl = String.fromEnvironment('API_BASE_URL');

  final String baseUrl;

  const ApiConfig._(this.baseUrl);

  factory ApiConfig.fromValue(String? value) {
    return ApiConfig._(_validateAndNormalize(value));
  }

  factory ApiConfig.fromEnvironment({
    Map<String, String>? environment,
    String? dartDefineUrl,
  }) {
    final define = (dartDefineUrl ?? _dartDefineUrl).trim();
    final envValue = (environment ?? dotenv.env)['API_BASE_URL'];
    return ApiConfig.fromValue(define.isNotEmpty ? define : envValue);
  }

  static String _validateAndNormalize(String? value) {
    final raw = value?.trim();
    if (raw == null || raw.isEmpty) {
      throw const ApiConfigurationException(
        'API_BASE_URL is missing. Copy .env.example to .env or provide '
        '--dart-define=API_BASE_URL=<url>.',
      );
    }

    final uri = Uri.tryParse(raw);
    final validScheme = uri?.scheme == 'http' || uri?.scheme == 'https';
    if (uri == null ||
        !uri.isAbsolute ||
        !validScheme ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw const ApiConfigurationException(
        'API_BASE_URL must be an absolute HTTP or HTTPS URL without '
        'credentials, a query, or a fragment.',
      );
    }

    if (uri.host.toLowerCase() == 'api.example.com') {
      throw const ApiConfigurationException(
        'API_BASE_URL still uses the api.example.com placeholder.',
      );
    }

    final normalizedPath = uri.path == '/'
        ? ''
        : uri.path.replaceFirst(RegExp(r'/+$'), '');
    return uri.replace(path: normalizedPath).toString();
  }
}
