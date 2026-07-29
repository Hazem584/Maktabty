import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/network/api_exceptions.dart';
import 'package:maktabty/features/work_hours/domain/usecases/get_monthly_work_hours.dart';
import 'package:maktabty/features/work_hours/presentation/cubit/monthly_work_hours_state.dart';

class MonthlyWorkHoursCubit extends Cubit<MonthlyWorkHoursState> {
  final GetMonthlyWorkHoursUseCase _getMonthlyWorkHoursUseCase;

  MonthlyWorkHoursCubit({
    required GetMonthlyWorkHoursUseCase getMonthlyWorkHoursUseCase,
  }) : _getMonthlyWorkHoursUseCase = getMonthlyWorkHoursUseCase,
       super(MonthlyWorkHoursState.initial());

  Future<void> load({required DateTime month}) async {
    emit(state.copyWith(status: MonthlyWorkHoursStatus.loading, message: null));

    try {
      final report = await _getMonthlyWorkHoursUseCase(
        month: _formatMonth(month),
      );
      emit(
        state.copyWith(status: MonthlyWorkHoursStatus.success, report: report),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: MonthlyWorkHoursStatus.failure,
          message: _mapError(error),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: MonthlyWorkHoursStatus.failure,
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  String _formatMonth(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$year-$month';
  }

  String _mapError(ApiException error) {
    final status = error.statusCode;
    if (status == 401) {
      return 'Session expired. Please sign in again.';
    }
    if (status == 403) {
      return 'Access denied. Owner role required.';
    }
    return error.message;
  }
}
