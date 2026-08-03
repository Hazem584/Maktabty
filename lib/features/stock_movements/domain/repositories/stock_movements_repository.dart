import 'package:maktabty/features/stock_movements/domain/entities/stock_movement_entities.dart';

abstract class StockMovementsRepository {
  Future<PaginatedStockMovementsEntity> getMovements({String? productId, StockMovementType? type, String? purchaseInvoiceId, String? saleId, DateTime? from, DateTime? to, int page = 1, int limit = 20});
}
