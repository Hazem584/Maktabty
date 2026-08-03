import 'package:equatable/equatable.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/suppliers/domain/entities/supplier_entities.dart';

enum PurchaseStatus { draft, posted, cancelled, unknown }

class PurchaseInvoiceItemEntity extends Equatable {
  final String? id;
  final String productId;
  final ProductEntity? product;
  final int quantity;
  final double unitCost;
  final double? lineTotal;

  const PurchaseInvoiceItemEntity({this.id, required this.productId, this.product, required this.quantity, required this.unitCost, this.lineTotal});

  @override
  List<Object?> get props => [id, productId, product, quantity, unitCost, lineTotal];
}

class PurchaseInvoiceEntity extends Equatable {
  final String id;
  final int? purchaseNoInt;
  final SupplierEntity? supplier;
  final String supplierId;
  final String? createdByName;
  final String? supplierInvoiceNumber;
  final PurchaseStatus status;
  final DateTime? purchasedAt;
  final DateTime? postedAt;
  final double subtotalAmount;
  final double discountAmount;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String? notes;
  final List<PurchaseInvoiceItemEntity> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PurchaseInvoiceEntity({required this.id, required this.supplierId, required this.status, required this.subtotalAmount, required this.discountAmount, required this.totalAmount, required this.paidAmount, required this.remainingAmount, required this.items, this.purchaseNoInt, this.supplier, this.createdByName, this.supplierInvoiceNumber, this.purchasedAt, this.postedAt, this.notes, this.createdAt, this.updatedAt});

  bool get isDraft => status == PurchaseStatus.draft;
  bool get isPosted => status == PurchaseStatus.posted;

  @override
  List<Object?> get props => [id, purchaseNoInt, supplier, supplierId, createdByName, supplierInvoiceNumber, status, purchasedAt, postedAt, subtotalAmount, discountAmount, totalAmount, paidAmount, remainingAmount, notes, items, createdAt, updatedAt];
}

class PurchaseItemInput extends Equatable {
  final String productId;
  final int quantity;
  final double unitCost;
  const PurchaseItemInput({required this.productId, required this.quantity, required this.unitCost});
  Map<String, Object> toJson() => {'productId': productId, 'quantity': quantity, 'unitCost': unitCost};
  @override
  List<Object?> get props => [productId, quantity, unitCost];
}

class PurchaseDraftInput extends Equatable {
  final String supplierId;
  final String? supplierInvoiceNumber;
  final DateTime purchasedAt;
  final double paidAmount;
  final double discountAmount;
  final String? notes;
  final List<PurchaseItemInput> items;
  const PurchaseDraftInput({required this.supplierId, required this.purchasedAt, required this.paidAmount, required this.discountAmount, required this.items, this.supplierInvoiceNumber, this.notes});

  Map<String, Object?> toJson() => {
    'supplierId': supplierId,
    if (supplierInvoiceNumber?.trim().isNotEmpty == true) 'supplierInvoiceNumber': supplierInvoiceNumber!.trim(),
    'purchasedAt': purchasedAt.toIso8601String(),
    'paidAmount': paidAmount,
    'discountAmount': discountAmount,
    if (notes?.trim().isNotEmpty == true) 'notes': notes!.trim(),
    'items': items.map((item) => item.toJson()).toList(growable: false),
  };

  @override
  List<Object?> get props => [supplierId, supplierInvoiceNumber, purchasedAt, paidAmount, discountAmount, notes, items];
}

class PaginatedPurchasesEntity extends Equatable {
  final List<PurchaseInvoiceEntity> items;
  final int page;
  final int limit;
  final int total;
  const PaginatedPurchasesEntity({required this.items, required this.page, required this.limit, required this.total});
  @override
  List<Object?> get props => [items, page, limit, total];
}
