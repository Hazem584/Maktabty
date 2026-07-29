import 'package:maktabty/core/utils/text_sanitizer.dart';
import 'package:maktabty/features/work_hours/domain/entities/monthly_work_hours_report.dart';

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
    return TotalsByUserItemModel(
      userId: (json['userId'] ?? '').toString(),
      fullName: TextSanitizer.fixMojibake((json['fullName'] ?? '').toString()),
      email: (json['email'] ?? '').toString(),
      totalMinutes: _toInt(json['totalMinutes']),
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

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class TotalsByDayItemModel {
  final String date;
  final int totalMinutes;

  const TotalsByDayItemModel({
    required this.date,
    required this.totalMinutes,
  });

  factory TotalsByDayItemModel.fromJson(Map<String, dynamic> json) {
    return TotalsByDayItemModel(
      date: (json['date'] ?? '').toString(),
      totalMinutes: _toInt(json['totalMinutes']),
    );
  }

  TotalsByDayItemEntity toEntity() {
    return TotalsByDayItemEntity(
      date: date,
      totalMinutes: totalMinutes,
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
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
    final rawUsers = json['totalsByUser'];
    List<TotalsByUserItemModel> totalsByUser = const [];
    if (rawUsers is List) {
      totalsByUser = rawUsers
          .whereType<Map>()
          .map((item) =>
              TotalsByUserItemModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } else if (rawUsers is List<Map<String, dynamic>>) {
      totalsByUser = rawUsers.map(TotalsByUserItemModel.fromJson).toList();
    }

    final rawDays = json['totalsByDay'];
    List<TotalsByDayItemModel> totalsByDay = const [];
    if (rawDays is List) {
      totalsByDay = rawDays
          .whereType<Map>()
          .map((item) =>
              TotalsByDayItemModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } else if (rawDays is List<Map<String, dynamic>>) {
      totalsByDay = rawDays.map(TotalsByDayItemModel.fromJson).toList();
    }

    return MonthlyWorkHoursReportModel(
      month: (json['month'] ?? '').toString(),
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
