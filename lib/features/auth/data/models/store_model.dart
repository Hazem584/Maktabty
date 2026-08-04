import 'package:maktabty/core/network/data_parsing_exception.dart';
import 'package:maktabty/core/utils/text_sanitizer.dart';
import 'package:maktabty/features/auth/domain/entities/store_entity.dart';

class StoreModel {
  final String id;
  final String name;

  const StoreModel({required this.id, required this.name});

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse registered store';
    return StoreModel(
      id: requireString(json, const ['id'], operation: operation),
      name: TextSanitizer.fixMojibake(
        requireString(json, const ['name'], operation: operation),
      ),
    );
  }

  StoreEntity toEntity() => StoreEntity(id: id, name: name);
}
