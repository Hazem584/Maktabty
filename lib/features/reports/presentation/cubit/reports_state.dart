import 'package:maktabty/features/reports/domain/entities/daily_report.dart';
import 'package:maktabty/features/reports/domain/entities/monthly_report.dart';
import 'package:equatable/equatable.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/utils/copy_with_sentinel.dart';

enum ReportsStatus { idle, loading, success, failure }

class ReportsState extends Equatable {
  final ReportsStatus dailyStatus;
  final ReportsStatus monthlyStatus;
  final DailyReportEntity? dailyReport;
  final MonthlyReportEntity? monthlyReport;
  final AppFailure? dailyFailure;
  final AppFailure? monthlyFailure;

  const ReportsState({
    required this.dailyStatus,
    required this.monthlyStatus,
    required this.dailyReport,
    required this.monthlyReport,
    required this.dailyFailure,
    required this.monthlyFailure,
  });

  factory ReportsState.initial() {
    return const ReportsState(
      dailyStatus: ReportsStatus.idle,
      monthlyStatus: ReportsStatus.idle,
      dailyReport: null,
      monthlyReport: null,
      dailyFailure: null,
      monthlyFailure: null,
    );
  }

  ReportsState copyWith({
    ReportsStatus? dailyStatus,
    ReportsStatus? monthlyStatus,
    Object? dailyReport = stateFieldUnchanged,
    Object? monthlyReport = stateFieldUnchanged,
    Object? dailyFailure = stateFieldUnchanged,
    Object? monthlyFailure = stateFieldUnchanged,
  }) {
    return ReportsState(
      dailyStatus: dailyStatus ?? this.dailyStatus,
      monthlyStatus: monthlyStatus ?? this.monthlyStatus,
      dailyReport: identical(dailyReport, stateFieldUnchanged)
          ? this.dailyReport
          : dailyReport as DailyReportEntity?,
      monthlyReport: identical(monthlyReport, stateFieldUnchanged)
          ? this.monthlyReport
          : monthlyReport as MonthlyReportEntity?,
      dailyFailure: identical(dailyFailure, stateFieldUnchanged)
          ? this.dailyFailure
          : dailyFailure as AppFailure?,
      monthlyFailure: identical(monthlyFailure, stateFieldUnchanged)
          ? this.monthlyFailure
          : monthlyFailure as AppFailure?,
    );
  }

  @override
  List<Object?> get props => [
    dailyStatus,
    monthlyStatus,
    dailyReport,
    monthlyReport,
    dailyFailure,
    monthlyFailure,
  ];
}
