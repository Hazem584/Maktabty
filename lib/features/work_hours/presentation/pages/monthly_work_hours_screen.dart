import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_loading.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:maktabty/features/work_hours/domain/entities/monthly_work_hours_report.dart';
import 'package:maktabty/features/work_hours/presentation/cubit/monthly_work_hours_cubit.dart';
import 'package:maktabty/features/work_hours/presentation/cubit/monthly_work_hours_state.dart';

class MonthlyWorkHoursScreen extends StatelessWidget {
  const MonthlyWorkHoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isOwner = context.select<AuthCubit, bool>((cubit) {
      return cubit.state.user?.role?.toUpperCase() == 'OWNER';
    });

    if (!isOwner) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(context.l10n.accessDeniedOwner),
          ),
        ),
      );
    }

    return BlocProvider<MonthlyWorkHoursCubit>(
      create: (_) => sl<MonthlyWorkHoursCubit>()
        ..load(month: DateTime.now()),
      child: const _MonthlyWorkHoursBody(),
    );
  }
}

class _MonthlyWorkHoursBody extends StatefulWidget {
  const _MonthlyWorkHoursBody();

  @override
  State<_MonthlyWorkHoursBody> createState() => _MonthlyWorkHoursBodyState();
}

class _MonthlyWorkHoursBodyState extends State<_MonthlyWorkHoursBody> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  Future<void> _pickMonth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(now.year - 2, 1, 1),
      lastDate: DateTime(now.year + 1, 12, 31),
      helpText: 'Select month (pick any day)',
    );
    if (picked != null) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
      });
      context.read<MonthlyWorkHoursCubit>().load(month: picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.monthlyWorkHours),
      ),
      body: BlocConsumer<MonthlyWorkHoursCubit, MonthlyWorkHoursState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == MonthlyWorkHoursStatus.failure) {
            AppToast.show(state.message ?? context.l10n.unableToLoadReport);
          }
        },
        builder: (context, state) {
          if (state.status == MonthlyWorkHoursStatus.loading &&
              state.report == null) {
            return const Center(child: AppLoading());
          }

          final report = state.report;
          if (report == null) {
            return Center(
              child: Text(
                state.message ?? context.l10n.noReportData,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.l),
            children: [
              _MonthHeader(
                monthLabel: _formatMonth(_selectedMonth),
                onPick: _pickMonth,
              ),
              const SizedBox(height: AppSpacing.l),
              Text(context.l10n.totalsByUser,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.s),
              _TotalsByUserList(items: report.totalsByUser),
              const SizedBox(height: AppSpacing.l),
              Text(context.l10n.totalsByDay,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.s),
              _TotalsByDayList(items: report.totalsByDay),
            ],
          );
        },
      ),
    );
  }

  String _formatMonth(DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat.yMMMM(locale).format(date);
  }
}

class _MonthHeader extends StatelessWidget {
  final String monthLabel;
  final VoidCallback onPick;

  const _MonthHeader({
    required this.monthLabel,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.l),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.selectMonth,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  monthLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onPick,
            child: Text(context.l10n.pick),
          ),
        ],
      ),
    );
  }
}

class _TotalsByUserList extends StatelessWidget {
  final List<TotalsByUserItemEntity> items;

  const _TotalsByUserList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(
        context.l10n.noUsersYet,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Theme.of(context).colorScheme.outline),
      );
    }

    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.s),
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadii.l),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.person_outline),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.fullName,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      item.email,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatMinutes(item.totalMinutes),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _TotalsByDayList extends StatelessWidget {
  final List<TotalsByDayItemEntity> items;

  const _TotalsByDayList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(
        context.l10n.noDaysYet,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Theme.of(context).colorScheme.outline),
      );
    }

    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.s),
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadii.l),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 18),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Text(
                  item.date,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                _formatMinutes(item.totalMinutes),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

String _formatMinutes(int minutes) {
  final hours = minutes ~/ 60;
  final mins = minutes % 60;
  if (hours == 0) return '${mins}m';
  if (mins == 0) return '${hours}h';
  return '${hours}h ${mins}m';
}

