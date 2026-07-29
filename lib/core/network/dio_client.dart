import 'package:dio/dio.dart';
import 'package:maktabty/core/network/auth_interceptor.dart';
import 'package:maktabty/core/network/auth_session_manager.dart';
import 'package:maktabty/core/storage/token_storage.dart';

class DioClient {
  final Dio dio;
  final Dio refreshDio;

  DioClient._({required this.dio, required this.refreshDio});

  factory DioClient({
    required TokenStorage tokenStorage,
    required AuthSessionManager sessionManager,
    required String baseUrl,
  }) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      responseType: ResponseType.json,
    );

    final dio = Dio(options);
    final refreshDio = Dio(options);

    dio.interceptors.add(
      AuthInterceptor(
        tokenStorage: tokenStorage,
        refreshDio: refreshDio,
        sessionManager: sessionManager,
      ),
    );

    return DioClient._(dio: dio, refreshDio: refreshDio);
  }
}
