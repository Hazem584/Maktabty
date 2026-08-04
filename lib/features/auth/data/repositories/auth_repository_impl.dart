import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/network/app_failure_mapper.dart';
import 'package:maktabty/core/storage/token_storage.dart';
import 'package:maktabty/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:maktabty/features/auth/domain/entities/auth_result_entity.dart';
import 'package:maktabty/features/auth/domain/entities/user_entity.dart';
import 'package:maktabty/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl({
    required this._remoteDataSource,
    required this._tokenStorage,
  });

  @override
  Future<AuthResultEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      if (response.accessToken.isNotEmpty) {
        await _tokenStorage.saveAccessToken(response.accessToken);
      }
      if (response.refreshToken.isNotEmpty) {
        await _tokenStorage.saveRefreshToken(response.refreshToken);
      }
      return AuthResultEntity(
        user: response.user.toEntity(),
        store: response.store?.toEntity(),
      );
    } catch (error) {
      final failure = AppFailureMapper.fromException(error);
      if (failure is UnauthorizedFailure) {
        throw const ValidationFailure(code: FailureCode.invalidCredentials);
      }
      throw failure;
    }
  }

  @override
  Future<AuthResultEntity> register({
    required String fullName,
    required String storeName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.register(
        fullName: fullName,
        storeName: storeName,
        email: email,
        password: password,
      );
      if (response.accessToken.isNotEmpty) {
        await _tokenStorage.saveAccessToken(response.accessToken);
      }
      if (response.refreshToken.isNotEmpty) {
        await _tokenStorage.saveRefreshToken(response.refreshToken);
      }
      return AuthResultEntity(
        user: response.user.toEntity(),
        store: response.store?.toEntity(),
      );
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }

  @override
  Future<AuthResultEntity> refresh() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw const UnauthorizedFailure();
    }

    try {
      final response = await _remoteDataSource.refresh(
        refreshToken: refreshToken,
      );
      if (response.accessToken.isNotEmpty) {
        await _tokenStorage.saveAccessToken(response.accessToken);
      }
      if (response.refreshToken.isNotEmpty) {
        await _tokenStorage.saveRefreshToken(response.refreshToken);
      }
      return AuthResultEntity(
        user: response.user.toEntity(),
        store: response.store?.toEntity(),
      );
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }

  @override
  Future<UserEntity> getMe() async {
    try {
      final user = await _remoteDataSource.getMe();
      return user.toEntity();
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }

  @override
  Future<void> logout() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _remoteDataSource.logout(refreshToken: refreshToken);
      }
    } catch (_) {
      // Ignore logout API failures; clear tokens locally.
    } finally {
      await _tokenStorage.clearAll();
    }
  }
}
