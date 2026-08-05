import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/network/auth_session_manager.dart';
import 'package:maktabty/core/storage/token_storage.dart';
import 'package:maktabty/features/auth/domain/usecases/get_me_usecase.dart';
import 'package:maktabty/features/auth/domain/usecases/login_usecase.dart';
import 'package:maktabty/features/auth/domain/usecases/logout_usecase.dart';
import 'package:maktabty/features/auth/domain/usecases/refresh_usecase.dart';
import 'package:maktabty/features/auth/domain/usecases/register_usecase.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_state.dart';
import 'package:maktabty/features/auth/domain/entities/user_entity.dart';

class AuthCubit extends Cubit<AuthState> {
  static const Duration _loginTimeout = Duration(seconds: 90);
  static const Duration _startupTimeout = Duration(seconds: 90);

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetMeUseCase _getMeUseCase;
  final RefreshUseCase _refreshUseCase;
  final TokenStorage _tokenStorage;

  final AuthSessionManager _sessionManager;
  StreamSubscription<AuthSessionEvent>? _sessionSubscription;
  bool _initialized = false;
  bool _initializing = false;
  bool _refreshingAuthenticatedUser = false;

  AuthCubit({
    required this._loginUseCase,
    required this._registerUseCase,
    required this._logoutUseCase,
    required this._getMeUseCase,
    required this._refreshUseCase,
    required this._tokenStorage,
    required this._sessionManager,
  }) : super(AuthState.initial()) {
    _sessionSubscription = _sessionManager.stream.listen((event) {
      if (!isClosed &&
          (event.type == AuthSessionEventType.expired ||
              event.type == AuthSessionEventType.accountDisabled)) {
        emit(AuthState.unauthenticated(failure: event.failure));
      } else if (!isClosed &&
          event.type == AuthSessionEventType.refreshed &&
          state.status == AuthStatus.authenticated) {
        unawaited(_reloadTrustedUserAfterRefresh(event.generation));
      }
    });
  }

  Future<void> initialize() async {
    if (_initialized || _initializing) return;
    if (isClosed) return;
    _initializing = true;

    emit(AuthState.loading());
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _initialized = true;
        if (!isClosed) emit(AuthState.unauthenticated());
        return;
      }

      final result = await _refreshUseCase().timeout(_startupTimeout);
      final user = result.user;
      if (!user.hasTrustedStoreMembership) {
        await _endCurrentSession();
        _initialized = true;
        if (!isClosed) {
          emit(
            AuthState.unauthenticated(failure: const UnauthorizedFailure()),
          );
        }
        return;
      }
      await _cacheUserSafely(user);
      _initialized = true;
      if (!isClosed) emit(AuthState.authenticated(user));
    } on AppFailure catch (failure) {
      if (failure.isUnauthorized || failure is AccountDisabledFailure) {
        await _endCurrentSession();
        _initialized = true;
        if (!isClosed) {
          emit(AuthState.unauthenticated(failure: failure));
        }
      } else {
        final cachedUser = await _readCachedUser();
        if (cachedUser != null) {
          _initialized = true;
          if (!isClosed) emit(AuthState.authenticated(cachedUser));
        } else if (!isClosed) {
          emit(AuthState.startupFailure(failure));
        }
      }
    } on TimeoutException {
      final cachedUser = await _readCachedUser();
      if (cachedUser != null) {
        _initialized = true;
        if (!isClosed) emit(AuthState.authenticated(cachedUser));
      } else if (!isClosed) {
        emit(
          AuthState.startupFailure(
            const TimeoutFailure(FailureCode.receiveTimeout),
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(AuthState.startupFailure(const UnknownFailure()));
      }
    } finally {
      _initializing = false;
    }
  }

  Future<void> retryInitialization() => initialize();

  Future<void> login({required String email, required String password}) async {
    if (isClosed || state.status == AuthStatus.loading) return;
    emit(AuthState.loading());
    try {
      final result = await _loginUseCase(email: email, password: password);
      final user = result.user;
      if (!user.hasTrustedStoreMembership) {
        await _endCurrentSession();
        if (!isClosed) {
          emit(AuthState.failure(const UnauthorizedFailure()));
        }
        return;
      }
      await _cacheUserSafely(user);
      if (!isClosed) emit(AuthState.authenticated(user));
    } on AppFailure catch (failure) {
      if (!isClosed) emit(AuthState.failure(failure));
    } on TimeoutException {
      if (!isClosed) {
        emit(
          AuthState.failure(const TimeoutFailure(FailureCode.receiveTimeout)),
        );
      }
    } catch (_) {
      if (!isClosed) emit(AuthState.failure(const UnknownFailure()));
    }
  }

  Future<void> register({
    required String fullName,
    required String storeName,
    required String email,
    required String password,
  }) async {
    if (isClosed || state.status == AuthStatus.loading) return;
    emit(AuthState.loading());
    try {
      final result = await _registerUseCase(
        fullName: fullName,
        storeName: storeName,
        email: email,
        password: password,
      );
      final user = result.user;
      if (!user.hasTrustedStoreMembership) {
        await _endCurrentSession();
        if (!isClosed) {
          emit(AuthState.failure(const UnauthorizedFailure()));
        }
        return;
      }
      await _cacheUserSafely(user);
      if (!isClosed) emit(AuthState.authenticated(user));
    } on AppFailure catch (failure) {
      if (!isClosed) emit(AuthState.failure(failure));
    } catch (_) {
      if (!isClosed) emit(AuthState.failure(const UnknownFailure()));
    }
  }

  Future<void> getMe() async {
    final expectedGeneration = _sessionManager.currentGeneration;
    try {
      final user = await _getMeUseCase();
      if (!_sessionManager.isCurrent(expectedGeneration)) return;
      if (!user.hasTrustedStoreMembership) {
        await _expireSession(
          expectedGeneration,
          const UnauthorizedFailure(),
        );
        return;
      }
      await _cacheUserSafely(user, expectedGeneration: expectedGeneration);
      if (!isClosed && _sessionManager.isCurrent(expectedGeneration)) {
        emit(AuthState.authenticated(user));
      }
    } on AppFailure catch (failure) {
      if (failure.isUnauthorized || failure is AccountDisabledFailure) {
        await _expireSession(expectedGeneration, failure);
      } else if (!isClosed) {
        emit(AuthState.failure(failure));
      }
    } catch (_) {
      if (!isClosed) emit(AuthState.failure(const UnknownFailure()));
    }
  }

  Future<void> logout() async {
    if (isClosed) return;
    emit(AuthState.loading());
    try {
      await _logoutUseCase().timeout(_loginTimeout);
    } catch (_) {
      await _endCurrentSession();
    } finally {
      _initialized = true;
      if (!isClosed) emit(AuthState.unauthenticated());
    }
  }

  @override
  Future<void> close() async {
    await _sessionSubscription?.cancel();
    await super.close();
  }

  Future<void> _cacheUserSafely(
    UserEntity user, {
    int? expectedGeneration,
  }) async {
    try {
      Future<void> saveIdentity() {
        return _tokenStorage.saveUserIdentity(
          id: user.id,
          email: user.email,
          fullName: user.fullName,
          role: user.role,
          storeId: user.storeId,
          isActive: user.isActive,
        );
      }

      if (expectedGeneration == null) {
        await saveIdentity();
      } else {
        await _sessionManager.updateSessionIfCurrent(
          expectedGeneration: expectedGeneration,
          updateSession: saveIdentity,
        );
      }
    } catch (_) {
      // Authentication remains valid even if optional identity caching fails.
    }
  }

  Future<UserEntity?> _readCachedUser() async {
    try {
      final stored = await _tokenStorage.getUserIdentity();
      if (stored == null ||
          stored.storeId?.trim().isEmpty != false ||
          stored.isActive != true) {
        return null;
      }
      final user = UserEntity(
        id: stored.id,
        email: stored.email,
        fullName: stored.fullName,
        role: stored.role,
        storeId: stored.storeId,
        isActive: stored.isActive,
      );
      return user.hasTrustedStoreMembership ? user : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _reloadTrustedUserAfterRefresh(int expectedGeneration) async {
    if (_refreshingAuthenticatedUser ||
        isClosed ||
        !_sessionManager.isCurrent(expectedGeneration)) {
      return;
    }
    _refreshingAuthenticatedUser = true;
    try {
      final user = await _getMeUseCase();
      if (!_sessionManager.isCurrent(expectedGeneration)) return;
      if (!user.hasTrustedStoreMembership) {
        await _expireSession(
          expectedGeneration,
          const UnauthorizedFailure(),
        );
        return;
      }
      await _cacheUserSafely(
        user,
        expectedGeneration: expectedGeneration,
      );
      if (!isClosed && _sessionManager.isCurrent(expectedGeneration)) {
        emit(AuthState.authenticated(user));
      }
    } on AppFailure catch (failure) {
      if (failure.isUnauthorized || failure is AccountDisabledFailure) {
        await _expireSession(expectedGeneration, failure);
      }
    } catch (_) {
      // Keep the current trusted identity on a temporary refresh-follow-up error.
    } finally {
      _refreshingAuthenticatedUser = false;
    }
  }

  Future<void> _endCurrentSession() async {
    await _sessionManager.endSession(_tokenStorage.clearAll);
  }

  Future<void> _expireSession(
    int expectedGeneration,
    AppFailure failure,
  ) async {
    await _sessionManager.invalidateSessionIfCurrent(
      expectedGeneration: expectedGeneration,
      clearSession: _tokenStorage.clearAll,
      failure: failure,
    );
  }
}
