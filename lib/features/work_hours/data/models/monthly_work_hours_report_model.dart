import 'package:maktabty/core/utils/text_sanitizer.dart';
import 'package:maktabty/features/work_hours/domain/entities/monthly_work_hours_report.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class TotalsByUserItemModel {
  final String userId;
  final String fullName;
  final String email;
  final int totalMinutes;

  const TotalsByUserItemModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.totalMinutes,
  });

  factory TotalsByUserItemModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse monthly work-hours user';
    return TotalsByUserItemModel(
      userId: requireString(json, const ['userId'], operation: operation),
      fullName: TextSanitizer.fixMojibake(
        requireString(json, const ['fullName'], operation: operation),
      ),
      email: requireString(json, const ['email'], operation: operation),
      totalMinutes: requireInt(json, const [
        'totalMinutes',
      ], operation: operation),
    );
  }

  TotalsByUserItemEntity toEntity() {
    return TotalsByUserItemEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      totalMinutes: totalMinutes,
    );
  }
}

class TotalsByDayItemModel {
  final String date;
  final int totalMinutes;

  const TotalsByDayItemModel({required this.date, required this.totalMinutes});

  factory TotalsByDayItemModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse monthly work-hours day';
    return TotalsByDayItemModel(
      date: requireString(json, const ['date'], operation: operation),
      totalMinutes: requireInt(json, const [
        'totalMinutes',
      ], operation: operation),
    );
  }

  TotalsByDayItemEntity toEntity() {
    return TotalsByDayItemEntity(date: date, totalMinutes: totalMinutes);
  }
}

class MonthlyWorkHoursReportModel {
  final String month;
  final List<TotalsByUserItemModel> totalsByUser;
  final List<TotalsByDayItemModel> totalsByDay;

  const MonthlyWorkHoursReportModel({
    required this.month,
    required this.totalsByUser,
    required this.totalsByDay,
  });

  factory MonthlyWorkHoursReportModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse monthly work-hours report';
    final totalsByUser = requireList(json, 'totalsByUser', operation: operation)
        .map(
          (item) => TotalsByUserItemModel.fromJson(
            requireStringMap(
              item,
              operation: operation,
              field: 'totalsByUser[]',
            ),
          ),
        )
        .toList(growable: false);
    final totalsByDay = requireList(json, 'totalsByDay', operation: operation)
        .map(
          (item) => TotalsByDayItemModel.fromJson(
            requireStringMap(
              item,
              operation: operation,
              field: 'totalsByDay[]',
            ),
          ),
        )
        .toList(growable: false);

    return MonthlyWorkHoursReportModel(
      month: requireString(json, const ['month'], operation: operation),
      totalsByUser: totalsByUser,
      totalsByDay: totalsByDay,
    );
  }

  MonthlyWorkHoursReportEntity toEntity() {
    return MonthlyWorkHoursReportEntity(
      month: month,
      totalsByUser: totalsByUser.map((item) => item.toEntity()).toList(),
      totalsByDay: totalsByDay.map((item) => item.toEntity()).toList(),
    );
  }
}
