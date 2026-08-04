import 'package:maktabty/core/utils/text_sanitizer.dart';
import 'package:maktabty/features/auth/domain/entities/user_entity.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? role;
  final String? storeId;
  final bool? isActive;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.role,
    this.storeId,
    this.isActive,
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
      storeId: _optionalText(json['storeId']),
      isActive: _optionalBool(json['isActive']),
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      fullName: fullName,
      role: role,
      storeId: storeId,
      isActive: isActive,
    );
  }
}

String? _optionalText(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

bool? _optionalBool(Object? value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    if (value.toLowerCase() == 'true') return true;
    if (value.toLowerCase() == 'false') return false;
  }
  return null;
}
