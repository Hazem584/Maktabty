import 'package:maktabty/features/sales/domain/entities/sale_item_entity.dart';
import 'package:maktabty/features/sales/domain/entities/user_mini_entity.dart';
import 'package:equatable/equatable.dart';

class SaleEntity extends Equatable {
  final String id;
  final List<SaleItemEntity> items;
  final double totalAmount;
  final DateTime? createdAt;
  final UserMiniEntity? user;

  const SaleEntity({
    required this.id,
    required this.items,
    required this.totalAmount,
    this.createdAt,
    this.user,
  });

  @override
  List<Object?> get props => [id, items, totalAmount, createdAt, user];
}
