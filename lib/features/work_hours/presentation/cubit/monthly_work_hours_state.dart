import 'package:maktabty/features/work_hours/domain/entities/monthly_work_hours_report.dart';

enum MonthlyWorkHoursStatus { idle, loading, success, failure }

class MonthlyWorkHoursState {
  final MonthlyWorkHoursStatus status;
  final MonthlyWorkHoursReportEntity? report;
  final String? message;

  const MonthlyWorkHoursState({
    required this.status,
    required this.report,
    required this.message,
  });

  factory MonthlyWorkHoursState.initial() {
    return const MonthlyWorkHoursState(
      status: MonthlyWorkHoursStatus.idle,
      report: null,
      message: null,
    );
  }

  MonthlyWorkHoursState copyWith({
    MonthlyWorkHoursStatus? status,
    MonthlyWorkHoursReportEntity? report,
    String? message,
  }) {
    return MonthlyWorkHoursState(
      status: status ?? this.status,
      report: report ?? this.report,
      message: message,
    );
  }
}
