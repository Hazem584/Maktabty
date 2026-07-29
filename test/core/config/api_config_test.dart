import 'package:flutter_test/flutter_test.dart';
import 'package:maktabty/core/config/api_config.dart';

void main() {
  group('ApiConfig', () {
    test('accepts HTTP and HTTPS URLs and removes trailing slashes', () {
      expect(
        ApiConfig.fromValue('http://10.0.2.2:3000/').baseUrl,
        'http://10.0.2.2:3000',
      );
      expect(
        ApiConfig.fromValue('https://api.maktabty.test/v1///').baseUrl,
        'https://api.maktabty.test/v1',
      );
    });

    test('dart define takes precedence over dotenv values', () {
      final config = ApiConfig.fromEnvironment(
        environment: const {'API_BASE_URL': 'http://localhost:3000'},
        dartDefineUrl: 'https://api.maktabty.test',
      );
      expect(config.baseUrl, 'https://api.maktabty.test');
    });

    for (final value in <String?>[
      null,
      '',
      'api.local',
      'ftp://api.local',
      'https://api.example.com',
      'https://user:password@api.local',
      'https://api.local?token=secret',
      'https://api.local/#fragment',
    ]) {
      test('rejects invalid value: $value', () {
        expect(
          () => ApiConfig.fromValue(value),
          throwsA(isA<ApiConfigurationException>()),
        );
      });
    }
  });
}
