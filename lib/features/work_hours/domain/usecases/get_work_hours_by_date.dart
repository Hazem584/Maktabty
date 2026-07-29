import 'package:maktabty/features/work_hours/domain/entities/work_day.dart';
import 'package:maktabty/features/work_hours/domain/repositories/work_hours_repository.dart';

class GetWorkHoursByDateUseCase {
  final WorkHoursRepository _repository;

  const GetWorkHoursByDateUseCase(this._repository);

  Future<List<WorkDayEntity>> call({
    required String date,
    String? userId,
  }) {
    return _repository.getByDate(date: date, userId: userId);
  }
}
