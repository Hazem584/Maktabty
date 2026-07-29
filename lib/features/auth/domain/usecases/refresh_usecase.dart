import 'package:maktabty/features/auth/domain/entities/user_entity.dart';
import 'package:maktabty/features/auth/domain/repositories/auth_repository.dart';

class RefreshUseCase {
  final AuthRepository _repository;

  const RefreshUseCase(this._repository);

  Future<UserEntity> call() {
    return _repository.refresh();
  }
}
