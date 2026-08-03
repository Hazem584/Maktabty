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
  final bool isActive;
  final DateTime? archivedAt;
  final String? archiveReason;

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
    this.isActive = true,
    this.archivedAt,
    this.archiveReason,
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
      isActive: _parseActive(json['isActive']),
      archivedAt: _optionalSafeDate(json['archivedAt']),
      archiveReason: _optionalText(json['archiveReason']),
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
      isActive: isActive,
      archivedAt: archivedAt,
      archiveReason: archiveReason,
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

  static bool _parseActive(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      if (value.toLowerCase() == 'false') return false;
      if (value.toLowerCase() == 'true') return true;
    }
    return true;
  }

  static DateTime? _optionalSafeDate(Object? value) {
    if (value is! String || value.trim().isEmpty) return null;
    return DateTime.tryParse(value.trim());
  }

  static String? _optionalText(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
