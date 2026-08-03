import 'package:maktabty/core/network/app_failure_mapper.dart';
import 'package:maktabty/features/stock_movements/data/datasources/stock_movements_remote_datasource.dart';
import 'package:maktabty/features/stock_movements/domain/entities/stock_movement_entities.dart';
import 'package:maktabty/features/stock_movements/domain/repositories/stock_movements_repository.dart';

class StockMovementsRepositoryImpl implements StockMovementsRepository {
  final StockMovementsRemoteDataSource _remote;
  const StockMovementsRepositoryImpl(this._remote);
  @override
  Future<PaginatedStockMovementsEntity> getMovements({String? productId, StockMovementType? type, String? purchaseInvoiceId, String? saleId, DateTime? from, DateTime? to, int page = 1, int limit = 20}) async {
    try {
      final result = await _remote.getMovements(productId: productId, type: type, purchaseInvoiceId: purchaseInvoiceId, saleId: saleId, from: from, to: to, page: page, limit: limit);
      return PaginatedStockMovementsEntity(items: result.items.map((model) => model.entity).toList(growable: false), page: result.page, limit: result.limit, total: result.total);
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }
}
