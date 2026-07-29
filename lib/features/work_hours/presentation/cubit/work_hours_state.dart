import 'package:maktabty/features/work_hours/domain/entities/work_day.dart';

enum WorkHoursStatus { idle, loading, success, failure }

class WorkHoursState {
  final WorkHoursStatus loadStatus;
  final WorkHoursStatus saveStatus;
  final List<WorkDayEntity> items;
  final String? loadMessage;
  final String? saveMessage;

  const WorkHoursState({
    required this.loadStatus,
    required this.saveStatus,
    required this.items,
    required this.loadMessage,
    required this.saveMessage,
  });

  factory WorkHoursState.initial() {
    return const WorkHoursState(
      loadStatus: WorkHoursStatus.idle,
      saveStatus: WorkHoursStatus.idle,
      items: [],
      loadMessage: null,
      saveMessage: null,
    );
  }

  WorkHoursState copyWith({
    WorkHoursStatus? loadStatus,
    WorkHoursStatus? saveStatus,
    List<WorkDayEntity>? items,
    String? loadMessage,
    String? saveMessage,
  }) {
    return WorkHoursState(
      loadStatus: loadStatus ?? this.loadStatus,
      saveStatus: saveStatus ?? this.saveStatus,
      items: items ?? this.items,
      loadMessage: loadMessage,
      saveMessage: saveMessage,
    );
  }
}
