import 'package:equatable/equatable.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';

enum LocalSaleSyncStatus {
  pending('PENDING'),
  syncing('SYNCING'),
  synced('SYNCED'),
  failed('FAILED'),
  stockConflict('STOCK_CONFLICT'),
  idempotencyConflict('IDEMPOTENCY_CONFLICT');

  final String databaseValue;

  const LocalSaleSyncStatus(this.databaseValue);

  static LocalSaleSyncStatus fromDatabase(String value) {
    return LocalSaleSyncStatus.values.firstWhere(
      (status) => status.databaseValue == value.toUpperCase(),
      orElse: () => LocalSaleSyncStatus.failed,
    );
  }

  bool get canRetry =>
      this == LocalSaleSyncStatus.pending || this == LocalSaleSyncStatus.failed;
}

class LocalSaleItemEntity extends Equatable {
  final String productId;
  final String productName;
  final String? productCode;
  final int quantity;
  final double sellingPrice;
  final double? unitPriceOverride;

  const LocalSaleItemEntity({
    required this.productId,
    required this.productName,
    required this.productCode,
    required this.quantity,
    required this.sellingPrice,
    required this.unitPriceOverride,
  });

  double get effectiveUnitPrice => unitPriceOverride ?? sellingPrice;
  double get lineTotal => effectiveUnitPrice * quantity;

  @override
  List<Object?> get props => [
    productId,
    productName,
    productCode,
    quantity,
    sellingPrice,
    unitPriceOverride,
  ];
}

class LocalSaleEntity extends Equatable {
  final int localId;
  final String clientSaleId;
  final String storeId;
  final String ownerUserId;
  final DateTime occurredAt;
  final PaymentMethod paymentMethod;
  final double? paidAmount;
  final double? cashAmount;
  final double? cardAmount;
  final double discountAmount;
  final LocalSaleSyncStatus syncStatus;
  final String? serverSaleId;
  final int? receiptNoInt;
  final int syncAttempts;
  final DateTime? lastSyncAttemptAt;
  final String? lastErrorCode;
  final String? lastErrorMessage;
  final String? conflictProductId;
  final int? conflictRequestedQuantity;
  final int? conflictAvailableQuantity;
  final DateTime createdLocallyAt;
  final DateTime updatedLocallyAt;
  final List<LocalSaleItemEntity> items;
  final ReceiptEntity? confirmedReceipt;

  const LocalSaleEntity({
    required this.localId,
    required this.clientSaleId,
    required this.storeId,
    required this.ownerUserId,
    required this.occurredAt,
    required this.paymentMethod,
    required this.paidAmount,
    required this.cashAmount,
    required this.cardAmount,
    required this.discountAmount,
    required this.syncStatus,
    required this.serverSaleId,
    required this.receiptNoInt,
    required this.syncAttempts,
    required this.lastSyncAttemptAt,
    required this.lastErrorCode,
    required this.lastErrorMessage,
    required this.conflictProductId,
    required this.conflictRequestedQuantity,
    required this.conflictAvailableQuantity,
    required this.createdLocallyAt,
    required this.updatedLocallyAt,
    required this.items,
    required this.confirmedReceipt,
  });

  double get totalAmount =>
      items.fold<double>(0, (total, item) => total + item.lineTotal) -
      discountAmount;

  String get temporaryReference => clientSaleId.split('-').first.toUpperCase();

  @override
  List<Object?> get props => [
    localId,
    clientSaleId,
    storeId,
    ownerUserId,
    occurredAt,
    paymentMethod,
    paidAmount,
    cashAmount,
    cardAmount,
    discountAmount,
    syncStatus,
    serverSaleId,
    receiptNoInt,
    syncAttempts,
    lastSyncAttemptAt,
    lastErrorCode,
    lastErrorMessage,
    conflictProductId,
    conflictRequestedQuantity,
    conflictAvailableQuantity,
    createdLocallyAt,
    updatedLocallyAt,
    items,
    confirmedReceipt,
  ];
}
