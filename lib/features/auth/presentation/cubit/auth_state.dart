import 'package:maktabty/features/auth/domain/entities/user_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  failure,
}

class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final String? message;

  const AuthState({
    required this.status,
    this.user,
    this.message,
  });

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);

  factory AuthState.authenticated(UserEntity user) =>
      AuthState(status: AuthStatus.authenticated, user: user);

  factory AuthState.unauthenticated({String? message}) =>
      AuthState(status: AuthStatus.unauthenticated, message: message);

  factory AuthState.failure(String message) =>
      AuthState(status: AuthStatus.failure, message: message);

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }
}
