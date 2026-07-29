class TotalsByUserItemEntity {
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
}

class TotalsByDayItemEntity {
  final String date;
  final int totalMinutes;

  const TotalsByDayItemEntity({
    required this.date,
    required this.totalMinutes,
  });
}

class MonthlyWorkHoursReportEntity {
  final String month;
  final List<TotalsByUserItemEntity> totalsByUser;
  final List<TotalsByDayItemEntity> totalsByDay;

  const MonthlyWorkHoursReportEntity({
    required this.month,
    required this.totalsByUser,
    required this.totalsByDay,
  });
}
