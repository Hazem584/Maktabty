import 'package:maktabty/core/utils/text_sanitizer.dart';
import 'package:maktabty/features/work_hours/domain/entities/work_day_user.dart';

class WorkDayUserModel {
  final String id;
  final String fullName;
  final String email;
  final String role;

  const WorkDayUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory WorkDayUserModel.fromJson(Map<String, dynamic> json) {
    return WorkDayUserModel(
      id: (json['id'] ?? '').toString(),
      fullName: TextSanitizer.fixMojibake((json['fullName'] ?? '').toString()),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
    );
  }

  WorkDayUserEntity toEntity() {
    return WorkDayUserEntity(
      id: id,
      fullName: fullName,
      email: email,
      role: role,
    );
  }
}
