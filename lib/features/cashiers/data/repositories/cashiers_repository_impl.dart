import 'package:maktabty/core/network/app_failure_mapper.dart';
import 'package:maktabty/features/cashiers/data/datasources/cashiers_remote_datasource.dart';
import 'package:maktabty/features/cashiers/domain/entities/cashier_entity.dart';
import 'package:maktabty/features/cashiers/domain/repositories/cashiers_repository.dart';

class CashiersRepositoryImpl implements CashiersRepository {
  final CashiersRemoteDataSource _remote;
  const CashiersRepositoryImpl(this._remote);

  Future<T> _guard<T>(Future<T> Function() action) async {
    try { return await action(); } catch (error) { throw AppFailureMapper.fromException(error); }
  }

  @override
  Future<PaginatedCashiersEntity> getCashiers({String? search, bool? isActive, int page = 1, int limit = 20}) => _guard(() async {
    final result = await _remote.getCashiers(search: search, isActive: isActive, page: page, limit: limit);
    final cashiers = result.items
        .map((model) => model.entity)
        .where((cashier) => cashier.role.trim().toUpperCase() == 'CASHIER')
        .toList(growable: false);
    return PaginatedCashiersEntity(items: cashiers, page: result.page, limit: result.limit, total: result.total);
  });

  @override
  Future<CashierEntity> getCashier(String id) => _guard(() async => (await _remote.getCashier(id)).entity);

  @override
  Future<CashierEntity> createCashier({required String fullName, required String email, required String password}) => _guard(() async => (await _remote.createCashier({'fullName': fullName.trim(), 'email': email.trim().toLowerCase(), 'password': password})).entity);

  @override
  Future<CashierEntity> updateCashier({required String id, String? fullName, String? email}) => _guard(() async => (await _remote.updateCashier(id, {if (fullName != null && fullName.trim().isNotEmpty) 'fullName': fullName.trim(), if (email != null && email.trim().isNotEmpty) 'email': email.trim().toLowerCase()})).entity);

  @override
  Future<CashierEntity> setCashierStatus({required String id, required bool isActive}) => _guard(() async => (await _remote.setCashierStatus(id, isActive)).entity);

  @override
  Future<CashierEntity> resetCashierPassword({required String id, required String password}) => _guard(() async => (await _remote.resetCashierPassword(id, password)).entity);
}
