import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/reports/domain/usecases/get_daily_report.dart';
import 'package:maktabty/features/reports/domain/usecases/get_monthly_report.dart';
import 'package:maktabty/features/reports/presentation/cubit/reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final GetDailyReportUseCase _getDailyReportUseCase;
  final GetMonthlyReportUseCase _getMonthlyReportUseCase;

  ReportsCubit({
    required GetDailyReportUseCase getDailyReportUseCase,
    required GetMonthlyReportUseCase getMonthlyReportUseCase,
  }) : _getDailyReportUseCase = getDailyReportUseCase,
       _getMonthlyReportUseCase = getMonthlyReportUseCase,
       super(ReportsState.initial());

  Future<void> loadDaily({DateTime? date}) async {
    if (isClosed || state.dailyStatus == ReportsStatus.loading) return;
    emit(
      state.copyWith(
        dailyStatus: ReportsStatus.loading,
        dailyReport: null,
        dailyFailure: null,
      ),
    );

    try {
      final report = await _getDailyReportUseCase(
        date: date != null ? _formatDate(date) : null,
      );
      if (!isClosed) {
        emit(
          state.copyWith(
            dailyStatus: ReportsStatus.success,
            dailyReport: report,
            dailyFailure: null,
          ),
        );
      }
    } on AppFailure catch (failure) {
      if (!isClosed) {
        emit(
          state.copyWith(
            dailyStatus: ReportsStatus.failure,
            dailyReport: null,
            dailyFailure: failure,
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            dailyStatus: ReportsStatus.failure,
            dailyReport: null,
            dailyFailure: const UnknownFailure(),
          ),
        );
      }
    }
  }

  Future<void> loadMonthly({DateTime? month}) async {
    if (isClosed || state.monthlyStatus == ReportsStatus.loading) return;
    emit(
      state.copyWith(
        monthlyStatus: ReportsStatus.loading,
        monthlyReport: null,
        monthlyFailure: null,
      ),
    );

    try {
      final report = await _getMonthlyReportUseCase(
        month: month != null ? _formatMonth(month) : null,
      );
      if (!isClosed) {
        emit(
          state.copyWith(
            monthlyStatus: ReportsStatus.success,
            monthlyReport: report,
            monthlyFailure: null,
          ),
        );
      }
    } on AppFailure catch (failure) {
      if (!isClosed) {
        emit(
          state.copyWith(
            monthlyStatus: ReportsStatus.failure,
            monthlyReport: null,
            monthlyFailure: failure,
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            monthlyStatus: ReportsStatus.failure,
            monthlyReport: null,
            monthlyFailure: const UnknownFailure(),
          ),
        );
      }
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

}
