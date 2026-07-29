import 'package:maktabty/features/work_hours/domain/entities/monthly_work_hours_report.dart';
import 'package:maktabty/features/work_hours/domain/entities/work_day.dart';

abstract class WorkHoursRepository {
  Future<WorkDayEntity> upsertWorkDay({
    required String date,
    String? shift1Start,
    String? shift1End,
    String? shift2Start,
    String? shift2End,
  });

  Future<List<WorkDayEntity>> getByDate({
    required String date,
    String? userId,
  });

  Future<MonthlyWorkHoursReportEntity> getMonthly({required String month});
}
