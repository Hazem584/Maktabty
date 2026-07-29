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

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.code,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] ?? '').toString(),
      name: TextSanitizer.fixMojibake((json['name'] ?? '').toString()),
      price: _toDouble(json['price']),
      stock: _toInt(json['stock']),
      code: json['code']?.toString(),
      createdAt: _toDate(json['createdAt']),
      updatedAt: _toDate(json['updatedAt']),
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
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _toDate(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
