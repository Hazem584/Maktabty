import 'package:maktabty/features/work_hours/domain/entities/work_day_user.dart';

class WorkDayEntity {
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
  final WorkDayUserEntity? user;

  const WorkDayEntity({
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
}
