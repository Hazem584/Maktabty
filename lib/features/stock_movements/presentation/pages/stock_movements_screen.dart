import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_loading.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_state.dart';
import 'package:maktabty/features/stock_movements/domain/entities/stock_movement_entities.dart';
import 'package:maktabty/features/stock_movements/presentation/cubit/stock_movements_cubit.dart';

class StockMovementsScreen extends StatelessWidget {
  final String? productId;
  final String? purchaseInvoiceId;
  final String? saleId;
  const StockMovementsScreen({super.key, this.productId, this.purchaseInvoiceId, this.saleId});
  @override Widget build(BuildContext context) => MultiBlocProvider(providers: [
    BlocProvider(create: (_) => sl<StockMovementsCubit>()..filters(productId: productId, purchaseId: purchaseInvoiceId, saleId: saleId)),
    BlocProvider(create: (_) => sl<ProductsListCubit>()..loadInitial()),
  ], child: const _StockMovementsView());
}

class _StockMovementsView extends StatefulWidget { const _StockMovementsView(); @override State<_StockMovementsView> createState() => _StockMovementsViewState(); }
class _StockMovementsViewState extends State<_StockMovementsView> {
  final _purchase = TextEditingController(); final _sale = TextEditingController();
  @override void dispose() { _purchase.dispose(); _sale.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(context.l10n.stockMovements), actions: [IconButton(onPressed: () => context.read<StockMovementsCubit>().load(), icon: const Icon(Icons.refresh), tooltip: context.l10n.refresh)]), body: Column(children: [
    Padding(padding: const EdgeInsets.all(AppSpacing.m), child: ExpansionTile(tilePadding: EdgeInsets.zero, title: Text(context.l10n.filters), children: [
      BlocBuilder<ProductsListCubit, ProductsListState>(builder: (context, products) => BlocBuilder<StockMovementsCubit, StockMovementsState>(builder: (context, state) => DropdownButtonFormField<String>(initialValue: products.products.any((p) => p.id == state.productId) ? state.productId : null, isExpanded: true, decoration: InputDecoration(labelText: context.l10n.productName), items: [DropdownMenuItem<String>(value: null, child: Text(context.l10n.all)), ...products.products.map((product) => DropdownMenuItem(value: product.id, child: Text(product.name, overflow: TextOverflow.ellipsis)))], onChanged: (value) => context.read<StockMovementsCubit>().filters(productId: value, type: state.type, purchaseId: state.purchaseId, saleId: state.saleId, from: state.from, to: state.to)))),
      const SizedBox(height: AppSpacing.s), BlocBuilder<StockMovementsCubit, StockMovementsState>(builder: (context, state) => DropdownButtonFormField<StockMovementType>(initialValue: state.type, decoration: InputDecoration(labelText: context.l10n.movementType), items: [DropdownMenuItem<StockMovementType>(value: null, child: Text(context.l10n.all)), ...StockMovementType.values.where((type) => type != StockMovementType.unknown).map((type) => DropdownMenuItem(value: type, child: Text(_movementType(context, type))))], onChanged: (value) => context.read<StockMovementsCubit>().filters(productId: state.productId, type: value, purchaseId: state.purchaseId, saleId: state.saleId, from: state.from, to: state.to))),
      const SizedBox(height: AppSpacing.s), Row(children: [Expanded(child: TextField(controller: _purchase, decoration: InputDecoration(labelText: context.l10n.purchaseInvoiceId))), const SizedBox(width: AppSpacing.s), Expanded(child: TextField(controller: _sale, decoration: InputDecoration(labelText: context.l10n.saleId)))]),
      BlocBuilder<StockMovementsCubit, StockMovementsState>(builder: (context, state) => Align(alignment: AlignmentDirectional.centerStart, child: ActionChip(avatar: const Icon(Icons.date_range, size: 18), label: Text(context.l10n.dateRange), onPressed: () async { final range = await showDateRangePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime.now().add(const Duration(days: 1)), initialDateRange: state.from != null && state.to != null ? DateTimeRange(start: state.from!, end: state.to!) : null); if (range != null && context.mounted) context.read<StockMovementsCubit>().filters(productId: state.productId, type: state.type, purchaseId: state.purchaseId, saleId: state.saleId, from: range.start, to: range.end); }))),
      Align(alignment: AlignmentDirectional.centerEnd, child: FilledButton(onPressed: () { final state = context.read<StockMovementsCubit>().state; context.read<StockMovementsCubit>().filters(productId: state.productId, type: state.type, purchaseId: _purchase.text.trim().isEmpty ? null : _purchase.text.trim(), saleId: _sale.text.trim().isEmpty ? null : _sale.text.trim(), from: state.from, to: state.to); }, child: Text(context.l10n.applyFilters))),
    ])),
    Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m), child: Text(context.l10n.movementHistoryNotice, style: Theme.of(context).textTheme.bodySmall)),
    const SizedBox(height: AppSpacing.s), Expanded(child: BlocBuilder<StockMovementsCubit, StockMovementsState>(builder: (context, state) {
      if (state.status == StockMovementsStatus.loading && state.items.isEmpty) return const Center(child: AppLoading());
      if (state.status == StockMovementsStatus.failure && state.items.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text(context.localizeFailure(state.failure)), FilledButton(onPressed: () => context.read<StockMovementsCubit>().load(), child: Text(context.l10n.retry))]));
      if (state.items.isEmpty) return Center(child: Text(context.l10n.noStockMovements));
      return RefreshIndicator(onRefresh: () => context.read<StockMovementsCubit>().load(), child: NotificationListener<ScrollNotification>(onNotification: (n) { if (n.metrics.extentAfter < 240) context.read<StockMovementsCubit>().load(replace: false); return false; }, child: ListView.builder(physics: const AlwaysScrollableScrollPhysics(), itemCount: state.items.length + (state.loadingMore ? 1 : 0), itemBuilder: (context, index) {
        if (index == state.items.length) return const Center(child: AppLoading()); final movement = state.items[index]; final positive = movement.quantityDelta >= 0; final date = movement.occurredAt ?? movement.createdAt;
        final related = movement.purchaseNumber ?? movement.saleReference ?? movement.purchaseInvoiceId ?? movement.saleId;
        return ListTile(leading: CircleAvatar(backgroundColor: (positive ? Colors.green : Theme.of(context).colorScheme.error).withValues(alpha: .12), child: Text('${positive ? '+' : ''}${movement.quantityDelta}', style: TextStyle(color: positive ? Colors.green.shade800 : Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold))), title: Text(movement.productName ?? movement.productId, maxLines: 1, overflow: TextOverflow.ellipsis), subtitle: Text('${_movementType(context, movement.type)} · ${context.l10n.stockBeforeAfter(movement.stockBefore, movement.stockAfter)}\n${movement.reason ?? context.l10n.notAvailable}${related == null ? '' : '\n${context.l10n.reference}: $related'}${movement.createdByName == null ? '' : ' · ${movement.createdByName}'}'), isThreeLine: true, trailing: Text(date == null ? context.l10n.notAvailable : DateFormat.yMd(Localizations.localeOf(context).toLanguageTag()).add_Hm().format(date.toLocal()), textAlign: TextAlign.end));
      })));
    })),
  ]));
}

String _movementType(BuildContext context, StockMovementType type) => switch (type) { StockMovementType.openingStock => context.l10n.openingStock, StockMovementType.purchase => context.l10n.purchaseMovement, StockMovementType.purchaseReversal => context.l10n.purchaseReversal, StockMovementType.sale => context.l10n.saleMovement, StockMovementType.saleReversal => context.l10n.saleReversal, StockMovementType.manualAdjustment => context.l10n.manualAdjustment, StockMovementType.unknown => context.l10n.unknownStatus };
