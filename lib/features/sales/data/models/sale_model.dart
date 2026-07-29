import 'package:maktabty/features/sales/data/models/sale_item_model.dart';
import 'package:maktabty/features/sales/data/models/user_mini_model.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';

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
    final rawItems = json['items'];
    List<SaleItemModel> items = const [];
    if (rawItems is List) {
      items = rawItems
          .whereType<Map>()
          .map((item) => SaleItemModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } else if (rawItems is List<Map<String, dynamic>>) {
      items = rawItems.map(SaleItemModel.fromJson).toList();
    }

    final userData = json['user'] ?? json['cashier'];
    UserMiniModel? user;
    if (userData is Map<String, dynamic>) {
      user = UserMiniModel.fromJson(userData);
    } else if (userData is Map) {
      user = UserMiniModel.fromJson(Map<String, dynamic>.from(userData));
    }

    return SaleModel(
      id: (json['id'] ??
              json['_id'] ??
              json['saleId'] ??
              json['sale_id'] ??
              '')
          .toString(),
      items: items,
      totalAmount: _toDouble(json['totalAmount'] ?? json['total']),
      createdAt: _toDate(json['createdAt']),
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

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static DateTime? _toDate(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}

