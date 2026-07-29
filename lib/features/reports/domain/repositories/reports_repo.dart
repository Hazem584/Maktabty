import 'package:maktabty/features/reports/domain/entities/daily_report.dart';
import 'package:maktabty/features/reports/domain/entities/monthly_report.dart';

abstract class ReportsRepository {
  Future<DailyReportEntity> getDailyReport({String? date});

  Future<MonthlyReportEntity> getMonthlyReport({String? month});
}
