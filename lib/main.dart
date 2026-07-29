import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maktabty/app.dart';
import 'package:maktabty/core/config/api_config.dart';
import 'package:maktabty/core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    var environment = const <String, String>{};
    try {
      await dotenv.load(fileName: '.env');
      environment = dotenv.env;
    } catch (_) {
      // A dart-define may be used when an asset-based .env is unavailable.
    }
    final apiConfig = ApiConfig.fromEnvironment(environment: environment);
    setupAppDependencies(apiConfig: apiConfig);
    runApp(const App());
  } on ApiConfigurationException catch (error) {
    runApp(_ConfigurationErrorApp(message: error.message));
  } catch (error) {
    runApp(
      _ConfigurationErrorApp(
        message: kDebugMode
            ? 'Application initialization failed: ${error.runtimeType}'
            : 'Application setup is unavailable. Contact support.',
      ),
    );
  }
}

class _ConfigurationErrorApp extends StatelessWidget {
  final String message;

  const _ConfigurationErrorApp({required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              kDebugMode
                  ? message
                  : 'Application setup is unavailable. Contact support.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
