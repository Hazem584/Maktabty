import 'package:maktabty/features/work_hours/data/models/work_day_user_model.dart';
import 'package:maktabty/features/work_hours/domain/entities/work_day.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class WorkDayModel {
  final String id;
  final String userId;
  final DateTime? date;
  final DateTime? shift1Start;
  final DateTime? shift1End;
  final DateTime? shift2Start;
  final DateTime? shift2End;
  final int totalMinutes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final WorkDayUserModel? user;

  const WorkDayModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.shift1Start,
    required this.shift1End,
    required this.shift2Start,
    required this.shift2End,
    required this.totalMinutes,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory WorkDayModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse work day';
    WorkDayUserModel? user;
    final rawUser = json['user'];
    if (rawUser is Map<String, dynamic>) {
      user = WorkDayUserModel.fromJson(rawUser);
    } else if (rawUser is Map) {
      user = WorkDayUserModel.fromJson(Map<String, dynamic>.from(rawUser));
    }

    return WorkDayModel(
      id: requireString(json, const ['id'], operation: operation),
      userId: requireString(json, const ['userId'], operation: operation),
      date: requireDateTime(json, const ['date'], operation: operation),
      shift1Start: optionalDateTime(json, 'shift1Start', operation: operation),
      shift1End: optionalDateTime(json, 'shift1End', operation: operation),
      shift2Start: optionalDateTime(json, 'shift2Start', operation: operation),
      shift2End: optionalDateTime(json, 'shift2End', operation: operation),
      totalMinutes: requireInt(json, const [
        'totalMinutes',
      ], operation: operation),
      createdAt: optionalDateTime(json, 'createdAt', operation: operation),
      updatedAt: optionalDateTime(json, 'updatedAt', operation: operation),
      user: user,
    );
  }

  WorkDayEntity toEntity() {
    return WorkDayEntity(
      id: id,
      userId: userId,
      date: date,
      shift1Start: shift1Start,
      shift1End: shift1End,
      shift2Start: shift2Start,
      shift2End: shift2End,
      totalMinutes: totalMinutes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      user: user?.toEntity(),
    );
  }
}
