import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/work_hours/domain/usecases/get_monthly_work_hours.dart';
import 'package:maktabty/features/work_hours/presentation/cubit/monthly_work_hours_state.dart';

class MonthlyWorkHoursCubit extends Cubit<MonthlyWorkHoursState> {
  final GetMonthlyWorkHoursUseCase _getMonthlyWorkHoursUseCase;

  MonthlyWorkHoursCubit({
    required GetMonthlyWorkHoursUseCase getMonthlyWorkHoursUseCase,
  }) : _getMonthlyWorkHoursUseCase = getMonthlyWorkHoursUseCase,
       super(MonthlyWorkHoursState.initial());

  Future<void> load({required DateTime month}) async {
    if (isClosed || state.status == MonthlyWorkHoursStatus.loading) return;
    emit(
      state.copyWith(
        status: MonthlyWorkHoursStatus.loading,
        report: null,
        failure: null,
      ),
    );

    try {
      final report = await _getMonthlyWorkHoursUseCase(
        month: _formatMonth(month),
      );
      if (!isClosed) {
        emit(
          state.copyWith(
            status: MonthlyWorkHoursStatus.success,
            report: report,
            failure: null,
          ),
        );
      }
    } on AppFailure catch (failure) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: MonthlyWorkHoursStatus.failure,
            report: null,
            failure: failure,
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: MonthlyWorkHoursStatus.failure,
            report: null,
            failure: const UnknownFailure(),
          ),
        );
      }
    }
  }

  String _formatMonth(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$year-$month';
  }

}
