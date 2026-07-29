import 'package:maktabty/core/utils/text_sanitizer.dart';
import 'package:maktabty/features/sales/domain/entities/user_mini_entity.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class UserMiniModel {
  final String id;
  final String fullName;
  final String email;
  final String role;

  const UserMiniModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory UserMiniModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse sale user';
    return UserMiniModel(
      id: requireString(json, const ['id'], operation: operation),
      fullName: TextSanitizer.fixMojibake(
        requireString(json, const ['fullName', 'name'], operation: operation),
      ),
      email: requireString(json, const ['email'], operation: operation),
      role: requireString(json, const ['role'], operation: operation),
    );
  }

  UserMiniEntity toEntity() {
    return UserMiniEntity(id: id, fullName: fullName, email: email, role: role);
  }
}
