import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  const ApiConfig._();

  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.example.com';
}
