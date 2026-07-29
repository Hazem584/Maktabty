import 'package:maktabty/core/utils/text_sanitizer.dart';
import 'package:maktabty/features/auth/domain/entities/user_entity.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? role;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse authenticated user';
    return UserModel(
      id: requireString(json, const ['id', 'sub'], operation: operation),
      email: requireString(json, const ['email'], operation: operation),
      fullName: TextSanitizer.fixMojibake(
        requireString(json, const ['fullName', 'name'], operation: operation),
      ),
      role: json['role']?.toString(),
    );
  }

  UserEntity toEntity() {
    return UserEntity(id: id, email: email, fullName: fullName, role: role);
  }
}
