import 'package:equatable/equatable.dart';

enum StockMovementType { openingStock, purchase, purchaseReversal, sale, saleReversal, manualAdjustment, unknown }

class StockMovementEntity extends Equatable {
  final String id;
  final String productId;
  final String? productName;
  final StockMovementType type;
  final int quantityDelta;
  final int stockBefore;
  final int stockAfter;
  final double? unitCost;
  final String? purchaseInvoiceId;
  final String? purchaseNumber;
  final String? saleId;
  final String? saleReference;
  final String? createdByName;
  final String? reason;
  final DateTime? occurredAt;
  final DateTime? createdAt;

  const StockMovementEntity({required this.id, required this.productId, required this.type, required this.quantityDelta, required this.stockBefore, required this.stockAfter, this.productName, this.unitCost, this.purchaseInvoiceId, this.purchaseNumber, this.saleId, this.saleReference, this.createdByName, this.reason, this.occurredAt, this.createdAt});

  @override
  List<Object?> get props => [id, productId, productName, type, quantityDelta, stockBefore, stockAfter, unitCost, purchaseInvoiceId, purchaseNumber, saleId, saleReference, createdByName, reason, occurredAt, createdAt];
}

class PaginatedStockMovementsEntity extends Equatable {
  final List<StockMovementEntity> items;
  final int page;
  final int limit;
  final int total;
  const PaginatedStockMovementsEntity({required this.items, required this.page, required this.limit, required this.total});
  @override
  List<Object?> get props => [items, page, limit, total];
}
