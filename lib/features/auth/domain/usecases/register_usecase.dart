import 'package:maktabty/features/auth/domain/entities/auth_result_entity.dart';
import 'package:maktabty/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  Future<AuthResultEntity> call({
    required String fullName,
    required String storeName,
    required String email,
    required String password,
  }) {
    return _repository.register(
      fullName: fullName,
      storeName: storeName,
      email: email,
      password: password,
    );
  }
}
