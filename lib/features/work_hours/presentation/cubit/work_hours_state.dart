import 'package:maktabty/features/work_hours/domain/entities/work_day.dart';

import 'package:equatable/equatable.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/utils/copy_with_sentinel.dart';
import 'package:maktabty/core/validation/validation_result.dart';

enum WorkHoursStatus { idle, loading, success, failure }

class WorkHoursState extends Equatable {
  final WorkHoursStatus loadStatus;
  final WorkHoursStatus saveStatus;
  final List<WorkDayEntity> items;
  final AppFailure? loadFailure;
  final AppFailure? saveFailure;
  final ValidationKey? validationError;

  const WorkHoursState({
    required this.loadStatus,
    required this.saveStatus,
    required this.items,
    required this.loadFailure,
    required this.saveFailure,
    required this.validationError,
  });

  factory WorkHoursState.initial() {
    return const WorkHoursState(
      loadStatus: WorkHoursStatus.idle,
      saveStatus: WorkHoursStatus.idle,
      items: [],
      loadFailure: null,
      saveFailure: null,
      validationError: null,
    );
  }

  WorkHoursState copyWith({
    WorkHoursStatus? loadStatus,
    WorkHoursStatus? saveStatus,
    List<WorkDayEntity>? items,
    Object? loadFailure = stateFieldUnchanged,
    Object? saveFailure = stateFieldUnchanged,
    Object? validationError = stateFieldUnchanged,
  }) {
    return WorkHoursState(
      loadStatus: loadStatus ?? this.loadStatus,
      saveStatus: saveStatus ?? this.saveStatus,
      items: items ?? this.items,
      loadFailure: identical(loadFailure, stateFieldUnchanged)
          ? this.loadFailure
          : loadFailure as AppFailure?,
      saveFailure: identical(saveFailure, stateFieldUnchanged)
          ? this.saveFailure
          : saveFailure as AppFailure?,
      validationError: identical(validationError, stateFieldUnchanged)
          ? this.validationError
          : validationError as ValidationKey?,
    );
  }

  @override
  List<Object?> get props => [
    loadStatus,
    saveStatus,
    items,
    loadFailure,
    saveFailure,
    validationError,
  ];
}
