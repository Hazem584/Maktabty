import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/network/api_exceptions.dart';
import 'package:maktabty/core/network/auth_session_manager.dart';
import 'package:maktabty/core/storage/token_storage.dart';
import 'package:maktabty/features/auth/domain/usecases/get_me_usecase.dart';
import 'package:maktabty/features/auth/domain/usecases/login_usecase.dart';
import 'package:maktabty/features/auth/domain/usecases/logout_usecase.dart';
import 'package:maktabty/features/auth/domain/usecases/refresh_usecase.dart';
import 'package:maktabty/features/auth/domain/usecases/register_usecase.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  static const Duration _loginTimeout = Duration(seconds: 20);

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetMeUseCase _getMeUseCase;
  final RefreshUseCase _refreshUseCase;
  final TokenStorage _tokenStorage;

  final AuthSessionManager _sessionManager;
  StreamSubscription<AuthSessionEvent>? _sessionSubscription;
  bool _initialized = false;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetMeUseCase getMeUseCase,
    required RefreshUseCase refreshUseCase,
    required TokenStorage tokenStorage,
    required AuthSessionManager sessionManager,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getMeUseCase = getMeUseCase,
        _refreshUseCase = refreshUseCase,
        _tokenStorage = tokenStorage,
        _sessionManager = sessionManager,
        super(AuthState.initial()) {
    _sessionSubscription = _sessionManager.stream.listen((event) {
      if (event == AuthSessionEvent.expired) {
        emit(AuthState.unauthenticated(
          message: 'Session expired. Please sign in again.',
        ));
      }
    });
  }

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    emit(AuthState.loading());
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      emit(AuthState.unauthenticated());
      return;
    }

    try {
      // avoid infinite loading if refresh hangs
      final user = await _refreshUseCase()
          .timeout(const Duration(seconds: 60));
      emit(AuthState.authenticated(user));
    } on ApiException {
      await _tokenStorage.clearAll();
      emit(AuthState.unauthenticated());
    } on TimeoutException {
      await _tokenStorage.clearAll();
      emit(AuthState.unauthenticated(message: 'Request timed out.'));
    } catch (_) {
      await _tokenStorage.clearAll();
      emit(AuthState.unauthenticated());
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthState.loading());
    try {
      final user = await _loginUseCase(
        email: email,
        password: password,
      ).timeout(_loginTimeout);
      emit(AuthState.authenticated(user));
    } on ApiException catch (error) {
      emit(AuthState.failure(error.message));
    } on TimeoutException {
      emit(AuthState.failure('Request timed out. Please try again.'));
    } catch (_) {
      emit(AuthState.failure('Something went wrong. Please try again.'));
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    String? role,
  }) async {
    emit(AuthState.loading());
    try {
      final user = await _registerUseCase(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
      );
      emit(AuthState.authenticated(user));
    } on ApiException catch (error) {
      emit(AuthState.failure(error.message));
    } catch (_) {
      emit(AuthState.failure('Something went wrong. Please try again.'));
    }
  }

  Future<void> getMe() async {
    try {
      final user = await _getMeUseCase();
      emit(AuthState.authenticated(user));
    } on ApiException catch (error) {
      emit(AuthState.failure(error.message));
    } catch (_) {
      emit(AuthState.failure('Something went wrong. Please try again.'));
    }
  }

  Future<void> logout() async {
    emit(AuthState.loading());
    await _logoutUseCase();
    emit(AuthState.unauthenticated());
  }

  @override
  Future<void> close() {
    _sessionSubscription?.cancel();
    return super.close();
  }
}
