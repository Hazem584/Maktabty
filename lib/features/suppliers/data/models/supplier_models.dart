import 'package:maktabty/core/network/data_parsing_exception.dart';
import 'package:maktabty/core/network/json_helpers.dart';
import 'package:maktabty/features/suppliers/domain/entities/supplier_entities.dart';

class SupplierModel {
  final SupplierEntity entity;
  const SupplierModel(this.entity);

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    const op = 'parse supplier';
    return SupplierModel(SupplierEntity(
      id: requireString(json, const ['id'], operation: op),
      name: requireString(json, const ['name'], operation: op),
      phone: optionalString(json, 'phone'),
      email: optionalString(json, 'email'),
      address: optionalString(json, 'address'),
      taxNumber: optionalString(json, 'taxNumber'),
      notes: optionalString(json, 'notes'),
      isActive: optionalBoolValue(json, 'isActive', true),
      createdAt: tolerantDateTime(json, 'createdAt'),
      updatedAt: tolerantDateTime(json, 'updatedAt'),
      balance: optionalDoubleValue(json, 'balance', operation: op) ?? optionalDoubleValue(json, 'outstandingBalance', operation: op),
    ));
  }
}

class SupplierPaymentModel {
  final SupplierPaymentEntity entity;
  const SupplierPaymentModel(this.entity);

  factory SupplierPaymentModel.fromJson(Map<String, dynamic> json) {
    const op = 'parse supplier payment';
    final purchase = json['purchase'] is Map ? Map<String, dynamic>.from(json['purchase'] as Map) : const <String, dynamic>{};
    final method = switch (optionalString(json, 'paymentMethod')?.toUpperCase()) {
      'CASH' => SupplierPaymentMethod.cash,
      'CARD' => SupplierPaymentMethod.card,
      'BANK_TRANSFER' => SupplierPaymentMethod.bankTransfer,
      'OTHER' => SupplierPaymentMethod.other,
      _ => SupplierPaymentMethod.unknown,
    };
    return SupplierPaymentModel(SupplierPaymentEntity(
      id: requireString(json, const ['id'], operation: op),
      supplierId: requireString(json, const ['supplierId'], operation: op),
      purchaseInvoiceId: requireString(json, const ['purchaseInvoiceId', 'purchaseId'], operation: op),
      purchaseNumber: optionalString(json, 'purchaseNumber') ?? optionalString(purchase, 'purchaseNumber') ?? optionalString(purchase, 'purchaseNo'),
      amount: requireDouble(json, const ['amount'], operation: op),
      method: method,
      paidAt: tolerantDateTime(json, 'paidAt') ?? tolerantDateTime(json, 'createdAt'),
      reference: optionalString(json, 'reference'),
      notes: optionalString(json, 'notes'),
    ));
  }
}

class SupplierStatementModel {
  final SupplierStatementEntity entity;
  const SupplierStatementModel(this.entity);

  factory SupplierStatementModel.fromJson(Map<String, dynamic> json) {
    const op = 'parse supplier statement';
    final totals = json['totals'] is Map ? Map<String, dynamic>.from(json['totals'] as Map) : json;
    final raw = json['entries'] ?? json['transactions'] ?? json['data'];
    final entries = raw is List ? raw.map((value) {
      final item = requireStringMap(value, operation: op, field: 'entries[]');
      final type = switch (optionalString(item, 'type')?.toUpperCase()) {
        'PURCHASE' || 'INVOICE' => SupplierStatementEntryType.purchase,
        'PAYMENT' || 'SUPPLIER_PAYMENT' => SupplierStatementEntryType.payment,
        _ => SupplierStatementEntryType.unknown,
      };
      return SupplierStatementEntryEntity(
        id: requireString(item, const ['id', 'transactionId'], operation: op),
        type: type,
        occurredAt: tolerantDateTime(item, 'occurredAt') ?? tolerantDateTime(item, 'date') ?? tolerantDateTime(item, 'createdAt'),
        reference: optionalString(item, 'reference') ?? optionalString(item, 'purchaseNumber') ?? optionalString(item, 'invoiceNumber'),
        debitAmount: optionalDoubleValue(item, 'debitAmount', operation: op) ?? optionalDoubleValue(item, 'debit', operation: op) ?? 0,
        creditAmount: optionalDoubleValue(item, 'creditAmount', operation: op) ?? optionalDoubleValue(item, 'credit', operation: op) ?? 0,
        balance: optionalDoubleValue(item, 'balance', operation: op),
      );
    }).toList(growable: false) : const <SupplierStatementEntryEntity>[];
    return SupplierStatementModel(SupplierStatementEntity(
      entries: entries,
      totalPurchases: optionalDoubleValue(totals, 'totalPurchases', operation: op),
      totalPaid: optionalDoubleValue(totals, 'totalPaid', operation: op),
      outstandingBalance: optionalDoubleValue(totals, 'outstandingBalance', operation: op) ?? optionalDoubleValue(totals, 'balance', operation: op),
    ));
  }
}
