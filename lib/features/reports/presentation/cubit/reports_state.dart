import 'package:maktabty/features/reports/domain/entities/daily_report.dart';
import 'package:maktabty/features/reports/domain/entities/monthly_report.dart';

enum ReportsStatus { idle, loading, success, failure }

class ReportsState {
  final ReportsStatus dailyStatus;
  final ReportsStatus monthlyStatus;
  final DailyReportEntity? dailyReport;
  final MonthlyReportEntity? monthlyReport;
  final String? dailyMessage;
  final String? monthlyMessage;

  const ReportsState({
    required this.dailyStatus,
    required this.monthlyStatus,
    required this.dailyReport,
    required this.monthlyReport,
    required this.dailyMessage,
    required this.monthlyMessage,
  });

  factory ReportsState.initial() {
    return const ReportsState(
      dailyStatus: ReportsStatus.idle,
      monthlyStatus: ReportsStatus.idle,
      dailyReport: null,
      monthlyReport: null,
      dailyMessage: null,
      monthlyMessage: null,
    );
  }

  ReportsState copyWith({
    ReportsStatus? dailyStatus,
    ReportsStatus? monthlyStatus,
    DailyReportEntity? dailyReport,
    MonthlyReportEntity? monthlyReport,
    String? dailyMessage,
    String? monthlyMessage,
  }) {
    return ReportsState(
      dailyStatus: dailyStatus ?? this.dailyStatus,
      monthlyStatus: monthlyStatus ?? this.monthlyStatus,
      dailyReport: dailyReport ?? this.dailyReport,
      monthlyReport: monthlyReport ?? this.monthlyReport,
      dailyMessage: dailyMessage,
      monthlyMessage: monthlyMessage,
    );
  }
}
