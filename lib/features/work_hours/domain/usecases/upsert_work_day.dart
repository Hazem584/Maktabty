import 'package:maktabty/features/work_hours/domain/entities/work_day.dart';
import 'package:maktabty/features/work_hours/domain/repositories/work_hours_repository.dart';

class UpsertWorkDayUseCase {
  final WorkHoursRepository _repository;

  const UpsertWorkDayUseCase(this._repository);

  Future<WorkDayEntity> call({
    required String date,
    String? shift1Start,
    String? shift1End,
    String? shift2Start,
    String? shift2End,
  }) {
    return _repository.upsertWorkDay(
      date: date,
      shift1Start: shift1Start,
      shift1End: shift1End,
      shift2Start: shift2Start,
      shift2End: shift2End,
    );
  }
}
