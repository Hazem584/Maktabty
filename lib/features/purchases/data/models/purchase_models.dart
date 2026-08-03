import 'package:maktabty/core/network/data_parsing_exception.dart';
import 'package:maktabty/core/network/json_helpers.dart';
import 'package:maktabty/features/products/data/models/product_model.dart';
import 'package:maktabty/features/purchases/domain/entities/purchase_entities.dart';
import 'package:maktabty/features/suppliers/data/models/supplier_models.dart';

class PurchaseInvoiceModel {
  final PurchaseInvoiceEntity entity;
  const PurchaseInvoiceModel(this.entity);

  factory PurchaseInvoiceModel.fromJson(Map<String, dynamic> json) {
    const op = 'parse purchase invoice';
    final supplierJson = json['supplier'] is Map ? Map<String, dynamic>.from(json['supplier'] as Map) : null;
    final createdBy = json['createdBy'] is Map ? Map<String, dynamic>.from(json['createdBy'] as Map) : null;
    final rawItems = json['items'];
    final items = rawItems is List ? rawItems.map((value) {
      final item = requireStringMap(value, operation: op, field: 'items[]');
      final productJson = item['product'] is Map ? Map<String, dynamic>.from(item['product'] as Map) : null;
      return PurchaseInvoiceItemEntity(
        id: optionalString(item, 'id'),
        productId: requireString(item, const ['productId'], operation: op),
        product: productJson != null && productJson['price'] != null && productJson['stock'] != null ? ProductModel.fromJson(productJson).toEntity() : null,
        quantity: requireInt(item, const ['quantity'], operation: op),
        unitCost: requireDouble(item, const ['unitCost'], operation: op),
        lineTotal: optionalDoubleValue(item, 'lineTotal', operation: op),
      );
    }).toList(growable: false) : const <PurchaseInvoiceItemEntity>[];
    final status = switch (optionalString(json, 'status')?.toUpperCase()) {
      'DRAFT' => PurchaseStatus.draft,
      'POSTED' => PurchaseStatus.posted,
      'CANCELLED' || 'CANCELED' => PurchaseStatus.cancelled,
      _ => PurchaseStatus.unknown,
    };
    return PurchaseInvoiceModel(PurchaseInvoiceEntity(
      id: requireString(json, const ['id'], operation: op),
      purchaseNoInt: optionalIntValue(json, 'purchaseNoInt', operation: op) ?? optionalIntValue(json, 'purchaseNo', operation: op),
      supplier: supplierJson == null ? null : SupplierModel.fromJson(supplierJson).entity,
      supplierId: optionalString(json, 'supplierId') ?? optionalString(supplierJson ?? const <String, dynamic>{}, 'id') ?? '',
      createdByName: createdBy == null ? null : optionalString(createdBy, 'fullName') ?? optionalString(createdBy, 'name'),
      supplierInvoiceNumber: optionalString(json, 'supplierInvoiceNumber'),
      status: status,
      purchasedAt: tolerantDateTime(json, 'purchasedAt'),
      postedAt: tolerantDateTime(json, 'postedAt'),
      subtotalAmount: optionalDoubleValue(json, 'subtotalAmount', operation: op) ?? 0,
      discountAmount: optionalDoubleValue(json, 'discountAmount', operation: op) ?? 0,
      totalAmount: optionalDoubleValue(json, 'totalAmount', operation: op) ?? 0,
      paidAmount: optionalDoubleValue(json, 'paidAmount', operation: op) ?? 0,
      remainingAmount: optionalDoubleValue(json, 'remainingAmount', operation: op) ?? 0,
      notes: optionalString(json, 'notes'),
      items: items,
      createdAt: tolerantDateTime(json, 'createdAt'),
      updatedAt: tolerantDateTime(json, 'updatedAt'),
    ));
  }
}
