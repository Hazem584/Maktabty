import 'package:equatable/equatable.dart';

class SupplierEntity extends Equatable {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? taxNumber;
  final String? notes;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? balance;

  const SupplierEntity({
    required this.id,
    required this.name,
    required this.isActive,
    this.phone,
    this.email,
    this.address,
    this.taxNumber,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.balance,
  });

  @override
  List<Object?> get props => [id, name, phone, email, address, taxNumber, notes, isActive, createdAt, updatedAt, balance];
}

enum SupplierPaymentMethod { cash, card, bankTransfer, other, unknown }

class SupplierPaymentEntity extends Equatable {
  final String id;
  final String supplierId;
  final String purchaseInvoiceId;
  final String? purchaseNumber;
  final double amount;
  final SupplierPaymentMethod method;
  final DateTime? paidAt;
  final String? reference;
  final String? notes;

  const SupplierPaymentEntity({required this.id, required this.supplierId, required this.purchaseInvoiceId, required this.amount, required this.method, this.purchaseNumber, this.paidAt, this.reference, this.notes});

  @override
  List<Object?> get props => [id, supplierId, purchaseInvoiceId, purchaseNumber, amount, method, paidAt, reference, notes];
}

enum SupplierStatementEntryType { purchase, payment, unknown }

class SupplierStatementEntryEntity extends Equatable {
  final String id;
  final SupplierStatementEntryType type;
  final DateTime? occurredAt;
  final String? reference;
  final double debitAmount;
  final double creditAmount;
  final double? balance;

  const SupplierStatementEntryEntity({required this.id, required this.type, required this.debitAmount, required this.creditAmount, this.occurredAt, this.reference, this.balance});

  @override
  List<Object?> get props => [id, type, occurredAt, reference, debitAmount, creditAmount, balance];
}

class SupplierStatementEntity extends Equatable {
  final List<SupplierStatementEntryEntity> entries;
  final double? totalPurchases;
  final double? totalPaid;
  final double? outstandingBalance;

  const SupplierStatementEntity({required this.entries, this.totalPurchases, this.totalPaid, this.outstandingBalance});

  @override
  List<Object?> get props => [entries, totalPurchases, totalPaid, outstandingBalance];
}

class PaginatedSuppliersEntity extends Equatable {
  final List<SupplierEntity> items;
  final int page;
  final int limit;
  final int total;

  const PaginatedSuppliersEntity({required this.items, required this.page, required this.limit, required this.total});

  @override
  List<Object?> get props => [items, page, limit, total];
}
