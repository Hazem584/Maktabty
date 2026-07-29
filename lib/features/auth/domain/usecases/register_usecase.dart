import 'package:maktabty/features/auth/domain/entities/user_entity.dart';
import 'package:maktabty/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  Future<UserEntity> call({
    required String fullName,
    required String email,
    required String password,
    String? role,
  }) {
    return _repository.register(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
    );
  }
}
