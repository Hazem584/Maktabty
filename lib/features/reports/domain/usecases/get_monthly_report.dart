import 'package:maktabty/features/reports/domain/entities/monthly_report.dart';
import 'package:maktabty/features/reports/domain/repositories/reports_repository.dart';

class GetMonthlyReportUseCase {
  final ReportsRepository _repository;

  const GetMonthlyReportUseCase(this._repository);

  Future<MonthlyReportEntity> call({String? month}) {
    return _repository.getMonthlyReport(month: month);
  }
}
