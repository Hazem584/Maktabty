import 'package:maktabty/features/auth/domain/entities/user_entity.dart';
import 'package:maktabty/features/auth/domain/repositories/auth_repository.dart';

class GetMeUseCase {
  final AuthRepository _repository;

  const GetMeUseCase(this._repository);

  Future<UserEntity> call() {
    return _repository.getMe();
  }
}
