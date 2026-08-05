import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/network/app_failure_mapper.dart';
import 'package:maktabty/core/network/auth_session_manager.dart';
import 'package:maktabty/core/storage/token_storage.dart';
import 'package:maktabty/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:maktabty/features/auth/data/models/auth_response_model.dart';
import 'package:maktabty/features/auth/domain/entities/auth_result_entity.dart';
import 'package:maktabty/features/auth/domain/entities/user_entity.dart';
import 'package:maktabty/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;
  final AuthSessionManager _sessionManager;

  AuthRepositoryImpl({
    required this._remoteDataSource,
    required this._tokenStorage,
    required this._sessionManager,
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
      await _establishSession(response);
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
      await _establishSession(response);
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
    final expectedGeneration = _sessionManager.currentGeneration;
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (!_sessionManager.isCurrent(expectedGeneration)) {
      throw const _StaleAuthSessionException();
    }
    if (refreshToken == null || refreshToken.isEmpty) {
      throw const UnauthorizedFailure();
    }

    try {
      final response = await _remoteDataSource.refresh(
        refreshToken: refreshToken,
      );
      final established = await _sessionManager.establishSessionIfCurrent(
        expectedGeneration: expectedGeneration,
        persistSession: () => _persistTokens(response),
      );
      if (established == null) {
        throw const _StaleAuthSessionException();
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
    String? refreshToken;
    String? accessToken;
    await _sessionManager.endSession(() async {
      try {
        refreshToken = await _tokenStorage.getRefreshToken();
        accessToken = await _tokenStorage.getAccessToken();
      } catch (_) {
        // Local invalidation must still proceed if storage cannot be read.
      } finally {
        await _tokenStorage.clearAll();
      }
    });

    try {
      final tokenForLogout = refreshToken;
      final accessTokenForLogout = accessToken;
      if (tokenForLogout != null && tokenForLogout.isNotEmpty) {
        await _remoteDataSource.logout(
          refreshToken: tokenForLogout,
          accessToken: accessTokenForLogout,
        );
      }
    } catch (_) {
      // Local logout is authoritative when server revocation is unavailable.
    }
  }

  Future<void> _establishSession(AuthResponseModel response) async {
    await _sessionManager.establishSession(() => _persistTokens(response));
  }

  Future<void> _persistTokens(AuthResponseModel response) async {
    if (response.accessToken.isNotEmpty) {
      await _tokenStorage.saveAccessToken(response.accessToken);
    }
    if (response.refreshToken.isNotEmpty) {
      await _tokenStorage.saveRefreshToken(response.refreshToken);
    }
  }
}

class _StaleAuthSessionException implements Exception {
  const _StaleAuthSessionException();
}
