import 'package:equatable/equatable.dart';

class CashierEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String storeId;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CashierEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.storeId,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    role,
    storeId,
    isActive,
    createdAt,
    updatedAt,
  ];
}

class PaginatedCashiersEntity extends Equatable {
  final List<CashierEntity> items;
  final int page;
  final int limit;
  final int total;

  const PaginatedCashiersEntity({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  bool get hasMore => total > 0 && items.length < total;

  @override
  List<Object?> get props => [items, page, limit, total];
}
