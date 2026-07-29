import 'package:maktabty/core/utils/text_sanitizer.dart';
import 'package:maktabty/features/sales/domain/entities/user_mini_entity.dart';

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
    return UserMiniModel(
      id: (json['id'] ?? '').toString(),
      fullName: TextSanitizer.fixMojibake((json['fullName'] ?? json['name'] ?? '').toString()),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
    );
  }

  UserMiniEntity toEntity() {
    return UserMiniEntity(
      id: id,
      fullName: fullName,
      email: email,
      role: role,
    );
  }
}

