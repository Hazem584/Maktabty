import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_loading.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:maktabty/features/reports/presentation/cubit/reports_cubit.dart';
import 'package:maktabty/features/reports/presentation/cubit/reports_state.dart';
import 'package:maktabty/features/reports/presentation/widgets/daily_breakdown_list.dart';
import 'package:maktabty/features/reports/presentation/widgets/summary_cards.dart';
import 'package:maktabty/features/reports/presentation/widgets/top_products_list.dart';
import 'package:maktabty/features/sales/presentation/pages/sales_by_date_screen.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isOwner = context.select<AuthCubit, bool>((cubit) {
      return cubit.state.user?.role?.toUpperCase() == 'OWNER';
    });

    if (!isOwner) {
      return Scaffold(
        body: SafeArea(
          child: Center(child: Text(context.l10n.accessDeniedOwner)),
        ),
      );
    }

    return BlocProvider<ReportsCubit>(
      create: (_) => sl<ReportsCubit>()
        ..loadDaily()
        ..loadMonthly(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.reportsTitle),
            bottom: TabBar(
              tabs: [
                Tab(text: context.l10n.daily),
                Tab(text: context.l10n.monthly),
              ],
            ),
          ),
          body: const SafeArea(
            child: TabBarView(
              children: [_DailyReportTab(), _MonthlyReportTab()],
            ),
          ),
        ),
      ),
    );
  }
}

class _DailyReportTab extends StatefulWidget {
  const _DailyReportTab();

  @override
  State<_DailyReportTab> createState() => _DailyReportTabState();
}

class _DailyReportTabState extends State<_DailyReportTab> {
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      context.read<ReportsCubit>().loadDaily(date: picked);
    }
  }

  String _dateLabel(String? date) {
    if (_selectedDate != null) {
      final locale = Localizations.localeOf(context).languageCode;
      return _formatDisplayDate(_selectedDate!, locale);
    }
    if (date != null && date.isNotEmpty) {
      return date;
    }
    return context.l10n.todayLabel;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        final report = state.dailyReport;
        final isLoading = state.dailyStatus == ReportsStatus.loading;
        final isFailure = state.dailyStatus == ReportsStatus.failure;

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.l),
          children: [
            _HeaderCard(
              title: context.l10n.dailyReport,
              subtitle: _dateLabel(report?.date),
              onAction: _pickDate,
              actionLabel: context.l10n.pickDate,
            ),
            const SizedBox(height: AppSpacing.l),
            if (isLoading)
              const Center(child: AppLoading())
            else if (isFailure)
              _ErrorCard(
                message: state.dailyMessage == null
                    ? context.l10n.unableToLoadReport
                    : context.localizeAppError(state.dailyMessage!),
                onRetry: () =>
                    context.read<ReportsCubit>().loadDaily(date: _selectedDate),
              )
            else if (report == null)
              _EmptyCard(message: context.l10n.noReportData)
            else ...[
              SummaryCards(
                totalSalesAmount: report.totalSalesAmount,
                totalOrders: report.totalOrders,
                totalItemsSold: report.totalItemsSold,
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                context.l10n.topProducts,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.s),
              TopProductsList(items: report.topProducts),
            ],
          ],
        );
      },
    );
  }
}

class _MonthlyReportTab extends StatefulWidget {
  const _MonthlyReportTab();

  @override
  State<_MonthlyReportTab> createState() => _MonthlyReportTabState();
}

class _MonthlyReportTabState extends State<_MonthlyReportTab> {
  DateTime? _selectedMonth;

  Future<void> _pickMonth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth ?? DateTime(now.year, now.month, 1),
      firstDate: DateTime(now.year - 2, 1, 1),
      lastDate: DateTime(now.year + 1, 12, 31),
      helpText: 'Select month (pick any day)',
    );
    if (picked != null) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month, 1);
      });
      context.read<ReportsCubit>().loadMonthly(month: picked);
    }
  }

  String _monthLabel(String? month) {
    if (_selectedMonth != null) {
      final locale = Localizations.localeOf(context).languageCode;
      return _formatDisplayMonth(_selectedMonth!, locale);
    }
    if (month != null && month.isNotEmpty) {
      return month;
    }
    return context.l10n.thisMonth;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        final report = state.monthlyReport;
        final isLoading = state.monthlyStatus == ReportsStatus.loading;
        final isFailure = state.monthlyStatus == ReportsStatus.failure;

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.l),
          children: [
            _HeaderCard(
              title: context.l10n.monthlyReportTitle,
              subtitle: _monthLabel(report?.month),
              onAction: _pickMonth,
              actionLabel: context.l10n.pickMonth,
            ),
            const SizedBox(height: AppSpacing.l),
            if (isLoading)
              const Center(child: AppLoading())
            else if (isFailure)
              _ErrorCard(
                message: state.monthlyMessage == null
                    ? context.l10n.unableToLoadReport
                    : context.localizeAppError(state.monthlyMessage!),
                onRetry: () => context.read<ReportsCubit>().loadMonthly(
                  month: _selectedMonth,
                ),
              )
            else if (report == null)
              _EmptyCard(message: context.l10n.noReportData)
            else ...[
              SummaryCards(
                totalSalesAmount: report.totalSalesAmount,
                totalOrders: report.totalOrders,
                totalItemsSold: report.totalItemsSold,
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                context.l10n.dailyBreakdown,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.s),
              DailyBreakdownList(
                items: report.dailyBreakdown,
                onItemTap: (item) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          SalesByDateScreen(date: item.date, sales: item.sales),
                    ),
                  );
                },
              ),
            ],
          ],
        );
      },
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onAction;
  final String actionLabel;

  const _HeaderCard({
    required this.title,
    required this.subtitle,
    required this.onAction,
    required this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.l),
        border: Border.all(color: colorScheme.outlineVariant),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadii.m),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.error),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colorScheme.error),
            ),
          ),
          TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;

  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadii.m),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}

String _formatDisplayDate(DateTime date, [String? locale]) {
  return DateFormat.yMMMd(locale).format(date);
}

String _formatDisplayMonth(DateTime date, [String? locale]) {
  return DateFormat.yMMMM(locale).format(date);
}
