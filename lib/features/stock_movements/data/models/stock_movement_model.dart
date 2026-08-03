import 'package:maktabty/core/network/data_parsing_exception.dart';
import 'package:maktabty/core/network/json_helpers.dart';
import 'package:maktabty/features/stock_movements/domain/entities/stock_movement_entities.dart';

class StockMovementModel {
  final StockMovementEntity entity;
  const StockMovementModel(this.entity);

  factory StockMovementModel.fromJson(Map<String, dynamic> json) {
    const op = 'parse stock movement';
    Map<String, dynamic>? relation(String key) => json[key] is Map ? Map<String, dynamic>.from(json[key] as Map) : null;
    final product = relation('product');
    final purchase = relation('purchaseInvoice') ?? relation('purchase');
    final sale = relation('sale');
    final user = relation('createdBy') ?? relation('user');
    final type = switch (optionalString(json, 'type')?.toUpperCase()) {
      'OPENING_STOCK' => StockMovementType.openingStock,
      'PURCHASE' => StockMovementType.purchase,
      'PURCHASE_REVERSAL' => StockMovementType.purchaseReversal,
      'SALE' => StockMovementType.sale,
      'SALE_REVERSAL' => StockMovementType.saleReversal,
      'MANUAL_ADJUSTMENT' => StockMovementType.manualAdjustment,
      _ => StockMovementType.unknown,
    };
    return StockMovementModel(StockMovementEntity(
      id: requireString(json, const ['id'], operation: op),
      productId: optionalString(json, 'productId') ?? optionalString(product ?? const <String, dynamic>{}, 'id') ?? '',
      productName: optionalString(product ?? const <String, dynamic>{}, 'name') ?? optionalString(json, 'productName'),
      type: type,
      quantityDelta: requireInt(json, const ['quantityDelta'], operation: op),
      stockBefore: requireInt(json, const ['stockBefore'], operation: op),
      stockAfter: requireInt(json, const ['stockAfter'], operation: op),
      unitCost: optionalDoubleValue(json, 'unitCost', operation: op),
      purchaseInvoiceId: optionalString(json, 'purchaseInvoiceId'),
      purchaseNumber: optionalString(purchase ?? const <String, dynamic>{}, 'purchaseNumber') ?? optionalString(purchase ?? const <String, dynamic>{}, 'purchaseNo'),
      saleId: optionalString(json, 'saleId'),
      saleReference: optionalString(sale ?? const <String, dynamic>{}, 'receiptNo') ?? optionalString(sale ?? const <String, dynamic>{}, 'reference'),
      createdByName: optionalString(user ?? const <String, dynamic>{}, 'fullName') ?? optionalString(user ?? const <String, dynamic>{}, 'name'),
      reason: optionalString(json, 'reason'),
      occurredAt: tolerantDateTime(json, 'occurredAt'),
      createdAt: tolerantDateTime(json, 'createdAt'),
    ));
  }
}
