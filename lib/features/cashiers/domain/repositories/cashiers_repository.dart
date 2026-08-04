import 'package:maktabty/features/cashiers/domain/entities/cashier_entity.dart';

abstract class CashiersRepository {
  Future<PaginatedCashiersEntity> getCashiers({
    String? search,
    bool? isActive,
    int page = 1,
    int limit = 20,
  });

  Future<CashierEntity> getCashier(String id);

  Future<CashierEntity> createCashier({
    required String fullName,
    required String email,
    required String password,
  });

  Future<CashierEntity> updateCashier({
    required String id,
    String? fullName,
    String? email,
  });

  Future<CashierEntity> setCashierStatus({
    required String id,
    required bool isActive,
  });

  Future<CashierEntity> resetCashierPassword({
    required String id,
    required String password,
  });
}
