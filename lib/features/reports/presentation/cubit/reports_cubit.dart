import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/network/api_exceptions.dart';
import 'package:maktabty/features/reports/domain/usecases/get_daily_report.dart';
import 'package:maktabty/features/reports/domain/usecases/get_monthly_report.dart';
import 'package:maktabty/features/reports/presentation/cubit/reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final GetDailyReportUseCase _getDailyReportUseCase;
  final GetMonthlyReportUseCase _getMonthlyReportUseCase;

  ReportsCubit({
    required GetDailyReportUseCase getDailyReportUseCase,
    required GetMonthlyReportUseCase getMonthlyReportUseCase,
  })  : _getDailyReportUseCase = getDailyReportUseCase,
        _getMonthlyReportUseCase = getMonthlyReportUseCase,
        super(ReportsState.initial());

  Future<void> loadDaily({DateTime? date}) async {
    if (state.dailyStatus == ReportsStatus.loading) return;
    emit(state.copyWith(
      dailyStatus: ReportsStatus.loading,
      dailyMessage: null,
    ));

    try {
      final report = await _getDailyReportUseCase(
        date: date != null ? _formatDate(date) : null,
      );
      emit(state.copyWith(
        dailyStatus: ReportsStatus.success,
        dailyReport: report,
      ));
    } on ApiException catch (error) {
      emit(state.copyWith(
        dailyStatus: ReportsStatus.failure,
        dailyMessage: _mapError(error),
      ));
    } catch (_) {
      emit(state.copyWith(
        dailyStatus: ReportsStatus.failure,
        dailyMessage: 'Something went wrong. Please try again.',
      ));
    }
  }

  Future<void> loadMonthly({DateTime? month}) async {
    if (state.monthlyStatus == ReportsStatus.loading) return;
    emit(state.copyWith(
      monthlyStatus: ReportsStatus.loading,
      monthlyMessage: null,
    ));

    try {
      final report = await _getMonthlyReportUseCase(
        month: month != null ? _formatMonth(month) : null,
      );
      emit(state.copyWith(
        monthlyStatus: ReportsStatus.success,
        monthlyReport: report,
      ));
    } on ApiException catch (error) {
      emit(state.copyWith(
        monthlyStatus: ReportsStatus.failure,
        monthlyMessage: _mapError(error),
      ));
    } catch (_) {
      emit(state.copyWith(
        monthlyStatus: ReportsStatus.failure,
        monthlyMessage: 'Something went wrong. Please try again.',
      ));
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
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
