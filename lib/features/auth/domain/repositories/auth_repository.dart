import 'package:maktabty/features/auth/domain/entities/auth_result_entity.dart';
import 'package:maktabty/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<AuthResultEntity> login({required String email, required String password});

  Future<AuthResultEntity> register({
    required String fullName,
    required String storeName,
    required String email,
    required String password,
  });

  Future<AuthResultEntity> refresh();

  Future<UserEntity> getMe();

  Future<void> logout();
}
