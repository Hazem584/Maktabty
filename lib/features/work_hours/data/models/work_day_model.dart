import 'package:maktabty/features/work_hours/data/models/work_day_user_model.dart';
import 'package:maktabty/features/work_hours/domain/entities/work_day.dart';

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
    WorkDayUserModel? user;
    final rawUser = json['user'];
    if (rawUser is Map<String, dynamic>) {
      user = WorkDayUserModel.fromJson(rawUser);
    } else if (rawUser is Map) {
      user = WorkDayUserModel.fromJson(Map<String, dynamic>.from(rawUser));
    }

    return WorkDayModel(
      id: (json['id'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      date: _toDate(json['date']),
      shift1Start: _toDate(json['shift1Start']),
      shift1End: _toDate(json['shift1End']),
      shift2Start: _toDate(json['shift2Start']),
      shift2End: _toDate(json['shift2End']),
      totalMinutes: _toInt(json['totalMinutes']),
      createdAt: _toDate(json['createdAt']),
      updatedAt: _toDate(json['updatedAt']),
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

  static DateTime? _toDate(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
