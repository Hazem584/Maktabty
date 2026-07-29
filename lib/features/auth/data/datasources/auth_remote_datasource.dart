import 'package:dio/dio.dart';
import 'package:maktabty/features/auth/data/models/auth_response_model.dart';
import 'package:maktabty/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;
  final Dio _refreshDio;
  static const Duration _authRequestTimeout = Duration(seconds: 20);

  AuthRemoteDataSource(this._dio, this._refreshDio);

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
      options: Options(
        extra: {'skipAuth': true},
        connectTimeout: _authRequestTimeout,
        sendTimeout: _authRequestTimeout,
        receiveTimeout: _authRequestTimeout,
      ),
    );
    // ignore: avoid_print
    print('LOGIN RESPONSE => ${response.data}');
    return _parseAuthResponse(response.data);
  }

  Future<AuthResponseModel> register({
    required String fullName,
    required String email,
    required String password,
    String? role,
  }) async {
    final response = await _dio.post(
      '/auth/register',
      data: {
        'fullName': fullName,
        'email': email,
        'password': password,
        'role': ?role,
      },
      options: Options(
        extra: {'skipAuth': true},
        connectTimeout: _authRequestTimeout,
        sendTimeout: _authRequestTimeout,
        receiveTimeout: _authRequestTimeout,
      ),
    );
    return _parseAuthResponse(response.data);
  }

  Future<UserModel> getMe() async {
    final response = await _dio.get('/auth/me');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final userJson = data['user'] is Map<String, dynamic>
          ? data['user']
          : data;
      return UserModel.fromJson(Map<String, dynamic>.from(userJson));
    }
    return const UserModel(id: '', email: '', fullName: '');
  }

  Future<AuthResponseModel> refresh({required String refreshToken}) async {
    final response = await _refreshDio.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
      options: Options(extra: {'skipAuth': true}),
    );
    return _parseAuthResponse(response.data);
  }

  Future<void> logout({required String refreshToken}) async {
    await _dio.post('/auth/logout', data: {'refreshToken': refreshToken});
  }

  AuthResponseModel _parseAuthResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return AuthResponseModel.fromJson(data);
    }
    return AuthResponseModel(
      user: const UserModel(id: '', email: '', fullName: ''),
      accessToken: '',
      refreshToken: '',
      tokenType: 'Bearer',
    );
  }
}
