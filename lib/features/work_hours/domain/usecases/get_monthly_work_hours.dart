import 'package:maktabty/features/work_hours/domain/entities/monthly_work_hours_report.dart';
import 'package:maktabty/features/work_hours/domain/repositories/work_hours_repository.dart';

class GetMonthlyWorkHoursUseCase {
  final WorkHoursRepository _repository;

  const GetMonthlyWorkHoursUseCase(this._repository);

  Future<MonthlyWorkHoursReportEntity> call({required String month}) {
    return _repository.getMonthly(month: month);
  }
}
