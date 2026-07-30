import 'package:equatable/equatable.dart';

class TotalsByUserItemEntity extends Equatable {
  final String userId;
  final String fullName;
  final String email;
  final int totalMinutes;

  const TotalsByUserItemEntity({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.totalMinutes,
  });

  @override
  List<Object?> get props => [userId, fullName, email, totalMinutes];
}

class TotalsByDayItemEntity extends Equatable {
  final String date;
  final int totalMinutes;

  const TotalsByDayItemEntity({required this.date, required this.totalMinutes});

  @override
  List<Object?> get props => [date, totalMinutes];
}

class MonthlyWorkHoursReportEntity extends Equatable {
  final String month;
  final List<TotalsByUserItemEntity> totalsByUser;
  final List<TotalsByDayItemEntity> totalsByDay;

  const MonthlyWorkHoursReportEntity({
    required this.month,
    required this.totalsByUser,
    required this.totalsByDay,
  });

  @override
  List<Object?> get props => [month, totalsByUser, totalsByDay];
}
