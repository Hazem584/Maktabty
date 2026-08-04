import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/routes/app_routes.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_loading.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/features/cashiers/presentation/cubit/cashiers_list_cubit.dart';
import 'package:maktabty/features/cashiers/presentation/widgets/cashier_list_tile.dart';

class CashiersScreen extends StatelessWidget {
  const CashiersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CashiersListCubit>()..load(),
      child: const _CashiersView(),
    );
  }
}

class _CashiersView extends StatelessWidget {
  const _CashiersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.cashiers),
        actions: [
          IconButton(
            onPressed: () => context.read<CashiersListCubit>().load(refresh: true),
            icon: const Icon(Icons.refresh),
            tooltip: context.l10n.refresh,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final changed = await Navigator.of(context).pushNamed(AppRoutes.cashierCreate);
          if (changed != null && context.mounted) context.read<CashiersListCubit>().load(refresh: true);
        },
        icon: const Icon(Icons.person_add_alt_1),
        label: Text(context.l10n.addCashier),
      ),
      body: BlocListener<CashiersListCubit, CashiersListState>(
        listenWhen: (previous, current) =>
            previous.failure != current.failure &&
            current.failure != null &&
            current.items.isNotEmpty,
        listener: (context, state) => AppToast.show(
          context.localizeFailure(
            state.failure,
            notFoundFallback: context.l10n.cashierUnavailable,
          ),
        ),
        child: Column(
          children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: TextField(
              onChanged: context.read<CashiersListCubit>().search,
              decoration: InputDecoration(labelText: context.l10n.searchCashiers, prefixIcon: const Icon(Icons.search)),
            ),
          ),
          BlocBuilder<CashiersListCubit, CashiersListState>(
            buildWhen: (previous, current) => previous.activeFilter != current.activeFilter,
            builder: (context, state) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              child: Wrap(
                spacing: AppSpacing.s,
                children: [
                  ChoiceChip(label: Text(context.l10n.all), selected: state.activeFilter == null, onSelected: (_) => context.read<CashiersListCubit>().filter(null)),
                  ChoiceChip(label: Text(context.l10n.active), selected: state.activeFilter == true, onSelected: (_) => context.read<CashiersListCubit>().filter(true)),
                  ChoiceChip(label: Text(context.l10n.disabled), selected: state.activeFilter == false, onSelected: (_) => context.read<CashiersListCubit>().filter(false)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Expanded(
            child: BlocBuilder<CashiersListCubit, CashiersListState>(
              builder: (context, state) {
                if (state.status == CashiersListStatus.loading && state.items.isEmpty) return const Center(child: AppLoading());
                if (state.status == CashiersListStatus.failure && state.items.isEmpty) {
                  return _Retry(message: context.localizeFailure(state.failure, notFoundFallback: context.l10n.cashierUnavailable), onRetry: () => context.read<CashiersListCubit>().load());
                }
                if (state.items.isEmpty) return Center(child: Text(context.l10n.noCashiers));
                return RefreshIndicator(
                  onRefresh: () => context.read<CashiersListCubit>().load(refresh: true),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.extentAfter < 240) context.read<CashiersListCubit>().loadMore();
                      return false;
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(AppSpacing.m, 0, AppSpacing.m, 96),
                      itemCount: state.items.length + (state.loadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.items.length) return const Padding(padding: EdgeInsets.all(AppSpacing.m), child: Center(child: AppLoading()));
                        final cashier = state.items[index];
                        return CashierListTile(
                          cashier: cashier,
                          onTap: () async {
                            await Navigator.of(context).pushNamed(AppRoutes.cashierDetails, arguments: cashier.id);
                            if (context.mounted) context.read<CashiersListCubit>().load(refresh: true);
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          ],
        ),
      ),
    );
  }
}

class _Retry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _Retry({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(AppSpacing.l), child: Column(mainAxisSize: MainAxisSize.min, children: [Text(message, textAlign: TextAlign.center), const SizedBox(height: AppSpacing.s), FilledButton(onPressed: onRetry, child: Text(context.l10n.retry))])));
}
