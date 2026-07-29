import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_loading.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:maktabty/features/work_hours/presentation/cubit/work_hours_cubit.dart';
import 'package:maktabty/features/work_hours/presentation/cubit/work_hours_state.dart';
import 'package:maktabty/features/work_hours/presentation/pages/monthly_work_hours_screen.dart';
import 'package:maktabty/features/work_hours/presentation/widgets/day_picker_card.dart';
import 'package:maktabty/features/work_hours/presentation/widgets/saved_day_tile.dart';
import 'package:maktabty/features/work_hours/presentation/widgets/shift_time_card.dart';
import 'package:maktabty/features/work_hours/presentation/widgets/work_hours_summary_card.dart';

class AddWorkHoursScreenBody extends StatefulWidget {
  const AddWorkHoursScreenBody({super.key});

  @override
  State<AddWorkHoursScreenBody> createState() => _AddWorkHoursScreenBodyState();
}

class _AddWorkHoursScreenBodyState extends State<AddWorkHoursScreenBody> {
  DateTime _selectedDate = DateTime.now();

  bool _shift1Worked = true;
  bool _shift2Worked = false;

  TimeOfDay _shift1Start = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _shift1End = const TimeOfDay(hour: 16, minute: 0);
  TimeOfDay _shift2Start = const TimeOfDay(hour: 17, minute: 0);
  TimeOfDay _shift2End = const TimeOfDay(hour: 22, minute: 0);

  @override
  void initState() {
    super.initState();
    context.read<WorkHoursCubit>().loadByDate(date: _selectedDate);
  }

  bool get _shift1Valid =>
      !_shift1Worked || _isEndAfterStart(_shift1Start, _shift1End);
  bool get _shift2Valid =>
      !_shift2Worked || _isEndAfterStart(_shift2Start, _shift2End);

  bool get _hasInvalidTimes => !_shift1Valid || !_shift2Valid;

  double? get _totalHours {
    if (_hasInvalidTimes) {
      return null;
    }
    double total = 0;
    if (_shift1Worked) {
      total += _durationHours(_shift1Start, _shift1End);
    }
    if (_shift2Worked) {
      total += _durationHours(_shift2Start, _shift2End);
    }
    return total;
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      context.read<WorkHoursCubit>().loadByDate(date: picked);
    }
  }

  Future<void> _pickTime({
    required TimeOfDay initial,
    required ValueChanged<TimeOfDay> onPicked,
  }) async {
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      onPicked(picked);
    }
  }

  void _saveEntry() {
    if (_hasInvalidTimes) {
      AppToast.show(context.l10n.fixInvalidShiftTimes);
      return;
    }

    context.read<WorkHoursCubit>().saveWorkDay(
      date: _selectedDate,
      shift1Start: _shift1Worked ? _shift1Start : null,
      shift1End: _shift1Worked ? _shift1End : null,
      shift2Start: _shift2Worked ? _shift2Start : null,
      shift2End: _shift2Worked ? _shift2End : null,
    );
  }

  void _openMonthly() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const MonthlyWorkHoursScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final totalHours = _totalHours;
    final isOwner = context.select<AuthCubit, bool>((cubit) {
      return cubit.state.user?.role?.toUpperCase() == 'OWNER';
    });

    return BlocListener<WorkHoursCubit, WorkHoursState>(
      listenWhen: (previous, current) =>
          previous.saveStatus != current.saveStatus ||
          previous.loadStatus != current.loadStatus,
      listener: (context, state) {
        if (state.saveStatus == WorkHoursStatus.failure) {
          AppToast.show(
            state.saveMessage ?? context.l10n.unableToSaveWorkHours,
          );
        }
        if (state.saveStatus == WorkHoursStatus.success) {
          AppToast.show(context.l10n.workHoursSaved);
        }
        if (state.loadStatus == WorkHoursStatus.failure) {
          AppToast.show(
            state.loadMessage ?? context.l10n.unableToLoadWorkHours,
          );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DayPickerCard(
              dateLabel: _formatDate(_selectedDate),
              onPick: _pickDate,
            ),
            const SizedBox(height: AppSpacing.l),
            if (isOwner)
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: _openMonthly,
                  icon: const Icon(Icons.bar_chart_outlined),
                  label: Text(context.l10n.monthlyReport),
                ),
              ),
            if (isOwner) const SizedBox(height: AppSpacing.m),
            if (!isOwner) ...[
              Text(
                context.l10n.shifts,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.s),
              ShiftTimeCard(
                title: context.l10n.shift1,
                worked: _shift1Worked,
                startTime: _shift1Start,
                endTime: _shift1End,
                isValid: _shift1Valid,
                onToggleWorked: (value) {
                  setState(() {
                    _shift1Worked = value;
                  });
                },
                onPickStart: () {
                  _pickTime(
                    initial: _shift1Start,
                    onPicked: (time) => setState(() => _shift1Start = time),
                  );
                },
                onPickEnd: () {
                  _pickTime(
                    initial: _shift1End,
                    onPicked: (time) => setState(() => _shift1End = time),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.m),
              ShiftTimeCard(
                title: context.l10n.shift2,
                worked: _shift2Worked,
                startTime: _shift2Start,
                endTime: _shift2End,
                isValid: _shift2Valid,
                onToggleWorked: (value) {
                  setState(() {
                    _shift2Worked = value;
                  });
                },
                onPickStart: () {
                  _pickTime(
                    initial: _shift2Start,
                    onPicked: (time) => setState(() => _shift2Start = time),
                  );
                },
                onPickEnd: () {
                  _pickTime(
                    initial: _shift2End,
                    onPicked: (time) => setState(() => _shift2End = time),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.l),
              WorkHoursSummaryCard(totalHours: totalHours),
              const SizedBox(height: AppSpacing.m),
              SizedBox(
                width: double.infinity,
                child: BlocBuilder<WorkHoursCubit, WorkHoursState>(
                  buildWhen: (previous, current) =>
                      previous.saveStatus != current.saveStatus,
                  builder: (context, state) {
                    final isSaving =
                        state.saveStatus == WorkHoursStatus.loading;
                    return ElevatedButton(
                      onPressed: (totalHours == null || isSaving)
                          ? null
                          : _saveEntry,
                      child: isSaving
                          ? AppLoading(
                              size: 20,
                              lineWidth: 2,
                              color: Theme.of(context).colorScheme.onPrimary,
                            )
                          : Text(context.l10n.save),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            Text(
              isOwner ? context.l10n.cashierWorkHours : context.l10n.savedDays,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s),
            BlocBuilder<WorkHoursCubit, WorkHoursState>(
              buildWhen: (previous, current) =>
                  previous.loadStatus != current.loadStatus ||
                  previous.items != current.items,
              builder: (context, state) {
                if (state.loadStatus == WorkHoursStatus.loading &&
                    state.items.isEmpty) {
                  return const Center(child: AppLoading());
                }

                if (state.items.isEmpty) {
                  return Text(
                    isOwner
                        ? context.l10n.noWorkHoursForDay
                        : context.l10n.noSavedDays,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  );
                }

                return Column(
                  children: state.items.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.s),
                      child: SavedDayTile(entry: entry),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _isEndAfterStart(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return endMinutes > startMinutes;
  }

  double _durationHours(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return (endMinutes - startMinutes) / 60.0;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[date.month - 1];
    return '$month ${date.day}, ${date.year}';
  }
}
