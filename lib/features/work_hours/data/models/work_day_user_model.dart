import 'package:maktabty/core/utils/text_sanitizer.dart';
import 'package:maktabty/features/work_hours/domain/entities/work_day_user.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

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
    const operation = 'parse work day user';
    return WorkDayUserModel(
      id: requireString(json, const ['id'], operation: operation),
      fullName: TextSanitizer.fixMojibake(
        requireString(json, const ['fullName'], operation: operation),
      ),
      email: requireString(json, const ['email'], operation: operation),
      role: requireString(json, const ['role'], operation: operation),
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
