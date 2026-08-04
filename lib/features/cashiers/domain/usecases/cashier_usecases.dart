import 'package:maktabty/features/cashiers/domain/entities/cashier_entity.dart';
import 'package:maktabty/features/cashiers/domain/repositories/cashiers_repository.dart';

class CashierUseCases {
  final CashiersRepository _repository;

  const CashierUseCases(this._repository);

  Future<PaginatedCashiersEntity> getCashiers({
    String? search,
    bool? isActive,
    int page = 1,
    int limit = 20,
  }) => _repository.getCashiers(
    search: search,
    isActive: isActive,
    page: page,
    limit: limit,
  );

  Future<CashierEntity> getCashier(String id) => _repository.getCashier(id);

  Future<CashierEntity> createCashier({required String fullName, required String email, required String password}) => _repository.createCashier(fullName: fullName, email: email, password: password);

  Future<CashierEntity> updateCashier({required String id, String? fullName, String? email}) => _repository.updateCashier(id: id, fullName: fullName, email: email);

  Future<CashierEntity> setCashierStatus({required String id, required bool isActive}) => _repository.setCashierStatus(id: id, isActive: isActive);

  Future<CashierEntity> resetCashierPassword({required String id, required String password}) => _repository.resetCashierPassword(id: id, password: password);
}
