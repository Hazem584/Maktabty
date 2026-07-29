import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/network/api_exceptions.dart';
import 'package:maktabty/features/work_hours/domain/usecases/get_work_hours_by_date.dart';
import 'package:maktabty/features/work_hours/domain/usecases/upsert_work_day.dart';
import 'package:maktabty/features/work_hours/presentation/cubit/work_hours_state.dart';

class WorkHoursCubit extends Cubit<WorkHoursState> {
  final UpsertWorkDayUseCase _upsertWorkDayUseCase;
  final GetWorkHoursByDateUseCase _getWorkHoursByDateUseCase;

  WorkHoursCubit({
    required UpsertWorkDayUseCase upsertWorkDayUseCase,
    required GetWorkHoursByDateUseCase getWorkHoursByDateUseCase,
  })  : _upsertWorkDayUseCase = upsertWorkDayUseCase,
        _getWorkHoursByDateUseCase = getWorkHoursByDateUseCase,
        super(WorkHoursState.initial());

  Future<void> loadByDate({required DateTime date, String? userId}) async {
    if (isClosed) return;
    emit(state.copyWith(
      loadStatus: WorkHoursStatus.loading,
      loadMessage: null,
    ));

    try {
      final result = await _getWorkHoursByDateUseCase(
        date: _formatDate(date),
        userId: userId,
      );
      if (isClosed) return;
      emit(state.copyWith(
        loadStatus: WorkHoursStatus.success,
        items: result,
      ));
    } on ApiException catch (error) {
      if (isClosed) return;
      emit(state.copyWith(
        loadStatus: WorkHoursStatus.failure,
        loadMessage: _mapError(error),
      ));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(
        loadStatus: WorkHoursStatus.failure,
        loadMessage: 'Something went wrong. Please try again.',
      ));
    }
  }

  Future<void> saveWorkDay({
    required DateTime date,
    TimeOfDay? shift1Start,
    TimeOfDay? shift1End,
    TimeOfDay? shift2Start,
    TimeOfDay? shift2End,
  }) async {
    if ((shift1Start != null && shift1End == null) ||
        (shift1Start == null && shift1End != null)) {
      emit(state.copyWith(
        saveStatus: WorkHoursStatus.failure,
        saveMessage: 'Shift 1 requires both start and end time.',
      ));
      return;
    }
    if ((shift2Start != null && shift2End == null) ||
        (shift2Start == null && shift2End != null)) {
      if (isClosed) return;
      emit(state.copyWith(
        saveStatus: WorkHoursStatus.failure,
        saveMessage: 'Shift 2 requires both start and end time.',
      ));
      return;
    }

    if (isClosed) return;
    emit(state.copyWith(
      saveStatus: WorkHoursStatus.loading,
      saveMessage: null,
    ));

    try {
      await _upsertWorkDayUseCase(
        date: _formatDate(date),
        shift1Start: _formatTime(shift1Start),
        shift1End: _formatTime(shift1End),
        shift2Start: _formatTime(shift2Start),
        shift2End: _formatTime(shift2End),
      );
      if (isClosed) return;
      emit(state.copyWith(saveStatus: WorkHoursStatus.success));
      if (isClosed) return;
      await loadByDate(date: date);
    } on ApiException catch (error) {
      if (isClosed) return;
      emit(state.copyWith(
        saveStatus: WorkHoursStatus.failure,
        saveMessage: _mapError(error),
      ));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(
        saveStatus: WorkHoursStatus.failure,
        saveMessage: 'Something went wrong. Please try again.',
      ));
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

  String _mapError(ApiException error) {
    final status = error.statusCode;
    if (status == 401) {
      return 'Session expired. Please sign in again.';
    }
    if (status == 403) {
      return 'Access denied. Owner or cashier role required.';
    }
    return error.message;
  }
}
