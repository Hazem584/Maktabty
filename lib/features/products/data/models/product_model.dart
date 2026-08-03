import 'package:maktabty/core/network/data_parsing_exception.dart';
import 'package:maktabty/core/utils/text_sanitizer.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';

class ProductModel {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String? code;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? category;
  final double? lastPurchasePrice;
  final double? averageCost;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.code,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.lastPurchasePrice,
    this.averageCost,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse product';
    return ProductModel(
      id: requireString(json, const ['id'], operation: operation),
      name: TextSanitizer.fixMojibake(
        requireString(json, const ['name'], operation: operation),
      ),
      price: requireDouble(json, const ['price'], operation: operation),
      stock: requireInt(json, const ['stock'], operation: operation),
      code: json['code']?.toString(),
      createdAt: optionalDateTime(json, 'createdAt', operation: operation),
      updatedAt: optionalDateTime(json, 'updatedAt', operation: operation),
      category: json['category'] is String
          ? TextSanitizer.fixMojibake(json['category'] as String)
          : null,
      lastPurchasePrice: _optionalDouble(json['lastPurchasePrice']),
      averageCost: _optionalDouble(json['averageCost']),
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      price: price,
      stock: stock,
      code: code,
      createdAt: createdAt,
      updatedAt: updatedAt,
      category: category,
      lastPurchasePrice: lastPurchasePrice,
      averageCost: averageCost,
    );
  }

  static double? _optionalDouble(Object? value) {
    if (value == null) return null;
    if (value is num && value.isFinite) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value.trim());
      if (parsed != null && parsed.isFinite) return parsed;
    }
    throw const DataParsingException(
      operation: 'parse product',
      expected: 'number, numeric string, or null',
      field: 'purchase cost',
    );
  }
}
