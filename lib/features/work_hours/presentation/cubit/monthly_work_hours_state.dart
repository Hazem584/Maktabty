import 'package:maktabty/features/work_hours/domain/entities/monthly_work_hours_report.dart';

import 'package:equatable/equatable.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/utils/copy_with_sentinel.dart';

enum MonthlyWorkHoursStatus { idle, loading, success, failure }

class MonthlyWorkHoursState extends Equatable {
  final MonthlyWorkHoursStatus status;
  final MonthlyWorkHoursReportEntity? report;
  final AppFailure? failure;

  const MonthlyWorkHoursState({
    required this.status,
    required this.report,
    required this.failure,
  });

  factory MonthlyWorkHoursState.initial() {
    return const MonthlyWorkHoursState(
      status: MonthlyWorkHoursStatus.idle,
      report: null,
      failure: null,
    );
  }

  MonthlyWorkHoursState copyWith({
    MonthlyWorkHoursStatus? status,
    Object? report = stateFieldUnchanged,
    Object? failure = stateFieldUnchanged,
  }) {
    return MonthlyWorkHoursState(
      status: status ?? this.status,
      report: identical(report, stateFieldUnchanged)
          ? this.report
          : report as MonthlyWorkHoursReportEntity?,
      failure: identical(failure, stateFieldUnchanged)
          ? this.failure
          : failure as AppFailure?,
    );
  }

  @override
  List<Object?> get props => [status, report, failure];
}
