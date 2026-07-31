import 'package:maktabty/features/reports/domain/entities/daily_report.dart';
import 'package:maktabty/features/reports/domain/repositories/reports_repository.dart';

class GetDailyReportUseCase {
  final ReportsRepository _repository;

  const GetDailyReportUseCase(this._repository);

  Future<DailyReportEntity> call({String? date}) {
    return _repository.getDailyReport(date: date);
  }
}
