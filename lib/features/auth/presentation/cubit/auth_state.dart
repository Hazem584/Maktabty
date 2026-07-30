import 'package:equatable/equatable.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/utils/copy_with_sentinel.dart';
import 'package:maktabty/features/auth/domain/entities/user_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  startupFailure,
  failure,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final AppFailure? failure;

  const AuthState({required this.status, this.user, this.failure});

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);

  factory AuthState.authenticated(UserEntity user) =>
      AuthState(status: AuthStatus.authenticated, user: user);

  factory AuthState.unauthenticated({AppFailure? failure}) =>
      AuthState(status: AuthStatus.unauthenticated, failure: failure);

  factory AuthState.startupFailure(AppFailure failure) =>
      AuthState(status: AuthStatus.startupFailure, failure: failure);

  factory AuthState.failure(AppFailure failure) =>
      AuthState(status: AuthStatus.failure, failure: failure);

  AuthState copyWith({
    AuthStatus? status,
    Object? user = stateFieldUnchanged,
    Object? failure = stateFieldUnchanged,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: identical(user, stateFieldUnchanged)
          ? this.user
          : user as UserEntity?,
      failure: identical(failure, stateFieldUnchanged)
          ? this.failure
          : failure as AppFailure?,
    );
  }

  @override
  List<Object?> get props => [status, user, failure];
}
