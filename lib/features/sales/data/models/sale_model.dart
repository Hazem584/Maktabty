import 'package:maktabty/features/sales/data/models/sale_item_model.dart';
import 'package:maktabty/features/sales/data/models/user_mini_model.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class SaleModel {
  final String id;
  final List<SaleItemModel> items;
  final double totalAmount;
  final DateTime? createdAt;
  final UserMiniModel? user;

  const SaleModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    required this.user,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse sale';
    final items = requireList(json, 'items', operation: operation)
        .map(
          (item) => SaleItemModel.fromJson(
            requireStringMap(item, operation: operation, field: 'items[]'),
          ),
        )
        .toList(growable: false);

    final userData = json['user'] ?? json['cashier'];
    UserMiniModel? user;
    if (userData is Map<String, dynamic>) {
      user = UserMiniModel.fromJson(userData);
    } else if (userData is Map) {
      user = UserMiniModel.fromJson(Map<String, dynamic>.from(userData));
    }

    return SaleModel(
      id: requireString(json, const [
        'id',
        '_id',
        'saleId',
        'sale_id',
      ], operation: operation),
      items: items,
      totalAmount: requireDouble(json, const [
        'totalAmount',
        'total',
      ], operation: operation),
      createdAt: requireDateTime(json, const [
        'createdAt',
      ], operation: operation),
      user: user,
    );
  }

  SaleEntity toEntity() {
    return SaleEntity(
      id: id,
      items: items.map((item) => item.toEntity()).toList(),
      totalAmount: totalAmount,
      createdAt: createdAt,
      user: user?.toEntity(),
    );
  }
}
