import 'package:maktabty/core/utils/text_sanitizer.dart';
import 'package:maktabty/features/sales/domain/entities/product_mini_entity.dart';

class ProductMiniModel {
  final String id;
  final String name;
  final String? code;

  const ProductMiniModel({
    required this.id,
    required this.name,
    this.code,
  });

  factory ProductMiniModel.fromJson(Map<String, dynamic> json) {
    return ProductMiniModel(
      id: (json['id'] ?? '').toString(),
      name: TextSanitizer.fixMojibake((json['name'] ?? '').toString()),
      code: json['code']?.toString(),
    );
  }

  ProductMiniEntity toEntity() {
    return ProductMiniEntity(
      id: id,
      name: name,
      code: code,
    );
  }
}

