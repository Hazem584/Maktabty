import 'package:maktabty/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> register({
    required String fullName,
    required String email,
    required String password,
    String? role,
  });

  Future<UserEntity> refresh();

  Future<UserEntity> getMe();

  Future<void> logout();
}
