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

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetMeUseCase getMeUseCase,
    required RefreshUseCase refreshUseCase,
    required TokenStorage tokenStorage,
    required AuthSessionManager sessionManager,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _getMeUseCase = getMeUseCase,
       _refreshUseCase = refreshUseCase,
       _tokenStorage = tokenStorage,
       _sessionManager = sessionManager,
       super(AuthState.initial()) {
    _sessionSubscription = _sessionManager.stream.listen((event) {
      if (!isClosed && event == AuthSessionEvent.expired) {
        emit(
          AuthState.unauthenticated(
            failure: const UnauthorizedFailure(),
          ),
        );
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

      final user = await _refreshUseCase().timeout(_startupTimeout);
      _initialized = true;
      if (!isClosed) emit(AuthState.authenticated(user));
    } on AppFailure catch (failure) {
      if (failure.isUnauthorized) {
        await _tokenStorage.clearAll();
        _initialized = true;
        if (!isClosed) {
          emit(AuthState.unauthenticated(failure: failure));
        }
      } else {
        if (!isClosed) emit(AuthState.startupFailure(failure));
      }
    } on TimeoutException {
      if (!isClosed) {
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
      final user = await _loginUseCase(email: email, password: password);
      if (!isClosed) emit(AuthState.authenticated(user));
    } on AppFailure catch (failure) {
      if (!isClosed) emit(AuthState.failure(failure));
    } on TimeoutException {
      if (!isClosed) {
        emit(
          AuthState.failure(
            const TimeoutFailure(FailureCode.receiveTimeout),
          ),
        );
      }
    } catch (_) {
      if (!isClosed) emit(AuthState.failure(const UnknownFailure()));
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    String? role,
  }) async {
    if (isClosed || state.status == AuthStatus.loading) return;
    emit(AuthState.loading());
    try {
      final user = await _registerUseCase(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
      );
      if (!isClosed) emit(AuthState.authenticated(user));
    } on AppFailure catch (failure) {
      if (!isClosed) emit(AuthState.failure(failure));
    } catch (_) {
      if (!isClosed) emit(AuthState.failure(const UnknownFailure()));
    }
  }

  Future<void> getMe() async {
    try {
      final user = await _getMeUseCase();
      if (!isClosed) emit(AuthState.authenticated(user));
    } on AppFailure catch (failure) {
      if (!isClosed) emit(AuthState.failure(failure));
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
      await _tokenStorage.clearAll();
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
}
