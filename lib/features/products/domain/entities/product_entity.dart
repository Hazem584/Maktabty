import 'package:equatable/equatable.dart';
import 'package:maktabty/core/utils/copy_with_sentinel.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String? code;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? category;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.code,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  ProductEntity copyWith({
    String? id,
    String? name,
    double? price,
    int? stock,
    Object? code = stateFieldUnchanged,
    Object? createdAt = stateFieldUnchanged,
    Object? updatedAt = stateFieldUnchanged,
    Object? category = stateFieldUnchanged,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      code: identical(code, stateFieldUnchanged) ? this.code : code as String?,
      createdAt: identical(createdAt, stateFieldUnchanged)
          ? this.createdAt
          : createdAt as DateTime?,
      updatedAt: identical(updatedAt, stateFieldUnchanged)
          ? this.updatedAt
          : updatedAt as DateTime?,
      category: identical(category, stateFieldUnchanged)
          ? this.category
          : category as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    stock,
    code,
    createdAt,
    updatedAt,
    category,
  ];
}
