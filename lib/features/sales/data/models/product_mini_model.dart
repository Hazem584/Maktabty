import 'package:maktabty/core/utils/text_sanitizer.dart';
import 'package:maktabty/features/sales/domain/entities/product_mini_entity.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class ProductMiniModel {
  final String id;
  final String name;
  final String? code;

  const ProductMiniModel({required this.id, required this.name, this.code});

  factory ProductMiniModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse sale product';
    return ProductMiniModel(
      id: requireString(json, const ['id'], operation: operation),
      name: TextSanitizer.fixMojibake(
        requireString(json, const ['name'], operation: operation),
      ),
      code: json['code']?.toString(),
    );
  }

  ProductMiniEntity toEntity() {
    return ProductMiniEntity(id: id, name: name, code: code);
  }
}
