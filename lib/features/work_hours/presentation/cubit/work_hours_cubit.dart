import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/work_hours/domain/usecases/get_work_hours_by_date.dart';
import 'package:maktabty/features/work_hours/domain/usecases/upsert_work_day.dart';
import 'package:maktabty/features/work_hours/domain/validation/work_hours_validator.dart';
import 'package:maktabty/features/work_hours/presentation/cubit/work_hours_state.dart';

class WorkHoursCubit extends Cubit<WorkHoursState> {
  final UpsertWorkDayUseCase _upsertWorkDayUseCase;
  final GetWorkHoursByDateUseCase _getWorkHoursByDateUseCase;

  WorkHoursCubit({
    required this._upsertWorkDayUseCase,
    required this._getWorkHoursByDateUseCase,
  }) : super(WorkHoursState.initial());

  Future<void> loadByDate({required DateTime date, String? userId}) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        loadStatus: WorkHoursStatus.loading,
        items: const [],
        loadFailure: null,
      ),
    );

    try {
      final result = await _getWorkHoursByDateUseCase(
        date: _formatDate(date),
        userId: userId,
      );
      if (isClosed) return;
      emit(
        state.copyWith(
          loadStatus: WorkHoursStatus.success,
          items: result,
          loadFailure: null,
        ),
      );
    } on AppFailure catch (failure) {
      if (isClosed) return;
      emit(
        state.copyWith(
          loadStatus: WorkHoursStatus.failure,
          loadFailure: failure,
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(
          loadStatus: WorkHoursStatus.failure,
          loadFailure: const UnknownFailure(),
        ),
      );
    }
  }

  Future<void> saveWorkDay({
    required DateTime date,
    TimeOfDay? shift1Start,
    TimeOfDay? shift1End,
    TimeOfDay? shift2Start,
    TimeOfDay? shift2End,
  }) async {
    if (isClosed || state.saveStatus == WorkHoursStatus.loading) return;
    final validationError = WorkHoursValidator.validate(
      shift1StartMinutes: _minutes(shift1Start),
      shift1EndMinutes: _minutes(shift1End),
      shift2StartMinutes: _minutes(shift2Start),
      shift2EndMinutes: _minutes(shift2End),
    );
    if (validationError != null) {
      emit(
        state.copyWith(
          saveStatus: WorkHoursStatus.failure,
          saveFailure: null,
          validationError: validationError,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        saveStatus: WorkHoursStatus.loading,
        saveFailure: null,
        validationError: null,
      ),
    );

    try {
      await _upsertWorkDayUseCase(
        date: _formatDate(date),
        shift1Start: _formatTime(shift1Start),
        shift1End: _formatTime(shift1End),
        shift2Start: _formatTime(shift2Start),
        shift2End: _formatTime(shift2End),
      );
      if (isClosed) return;
      emit(
        state.copyWith(
          saveStatus: WorkHoursStatus.success,
          saveFailure: null,
          validationError: null,
        ),
      );
      if (isClosed) return;
      await loadByDate(date: date);
    } on AppFailure catch (failure) {
      if (isClosed) return;
      emit(
        state.copyWith(
          saveStatus: WorkHoursStatus.failure,
          saveFailure: failure,
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(
          saveStatus: WorkHoursStatus.failure,
          saveFailure: const UnknownFailure(),
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String? _formatTime(TimeOfDay? time) {
    if (time == null) return null;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  int? _minutes(TimeOfDay? time) =>
      time == null ? null : time.hour * 60 + time.minute;
}
