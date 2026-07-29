import 'package:maktabty/core/utils/text_sanitizer.dart';
import 'package:maktabty/features/auth/domain/entities/user_entity.dart';

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
    final id = json['id'] ?? json['sub'] ?? '';
    return UserModel(
      id: id.toString(),
      email: (json['email'] ?? '').toString(),
      fullName: TextSanitizer.fixMojibake(
        (json['fullName'] ?? json['name'] ?? '').toString(),
      ),
      role: json['role']?.toString(),
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      fullName: fullName,
      role: role,
    );
  }
}
