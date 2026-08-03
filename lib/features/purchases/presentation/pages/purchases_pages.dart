import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maktabty/core/database/money_minor.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/routes/app_routes.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_loading.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_state.dart';
import 'package:maktabty/features/purchases/domain/entities/purchase_entities.dart';
import 'package:maktabty/features/purchases/presentation/cubit/purchase_details_cubit.dart';
import 'package:maktabty/features/purchases/presentation/cubit/purchase_form_cubit.dart';
import 'package:maktabty/features/purchases/presentation/cubit/purchases_list_cubit.dart';
import 'package:maktabty/features/suppliers/domain/entities/supplier_entities.dart';
import 'package:maktabty/features/suppliers/presentation/cubit/suppliers_list_cubit.dart';

String _purchaseMoney(BuildContext context, double value) => NumberFormat.currency(locale: Localizations.localeOf(context).toLanguageTag(), name: 'EGP', decimalDigits: 2).format(value);
String _purchaseDate(BuildContext context, DateTime? value) => value == null ? context.l10n.notAvailable : DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag()).format(value.toLocal());

class PurchasesScreen extends StatelessWidget {
  const PurchasesScreen({super.key});
  @override Widget build(BuildContext context) => MultiBlocProvider(providers: [BlocProvider(create: (_) => sl<PurchasesListCubit>()..load()), BlocProvider(create: (_) => sl<SuppliersListCubit>()..filter(true))], child: const _PurchasesView());
}

class _PurchasesView extends StatelessWidget {
  const _PurchasesView();
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.purchases), actions: [IconButton(onPressed: () => context.read<PurchasesListCubit>().load(refresh: true), icon: const Icon(Icons.refresh), tooltip: context.l10n.refresh)]),
    floatingActionButton: FloatingActionButton.extended(onPressed: () async { final changed = await Navigator.of(context).pushNamed(AppRoutes.purchaseCreate); if (changed == true && context.mounted) context.read<PurchasesListCubit>().load(refresh: true); }, icon: const Icon(Icons.add), label: Text(context.l10n.createPurchase)),
    body: Column(children: [
      Padding(padding: const EdgeInsets.all(AppSpacing.m), child: TextField(onChanged: context.read<PurchasesListCubit>().search, decoration: InputDecoration(labelText: context.l10n.searchPurchases, prefixIcon: const Icon(Icons.search)))),
      BlocBuilder<PurchasesListCubit, PurchasesListState>(builder: (context, state) => SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m), child: Row(children: [
        BlocBuilder<SuppliersListCubit, SuppliersListState>(builder: (context, suppliers) => SizedBox(width: 220, child: DropdownButtonFormField<String>(initialValue: state.supplierId, isExpanded: true, decoration: InputDecoration(labelText: context.l10n.supplier), items: [DropdownMenuItem<String>(value: null, child: Text(context.l10n.all)), ...suppliers.items.map((supplier) => DropdownMenuItem(value: supplier.id, child: Text(supplier.name, overflow: TextOverflow.ellipsis)))], onChanged: (value) => context.read<PurchasesListCubit>().filters(supplierId: value, status: state.filterStatus, from: state.from, to: state.to)))),
        const SizedBox(width: AppSpacing.s),
        ChoiceChip(label: Text(context.l10n.all), selected: state.filterStatus == null, onSelected: (_) => context.read<PurchasesListCubit>().filters(status: null, supplierId: state.supplierId, from: state.from, to: state.to)), const SizedBox(width: AppSpacing.s),
        ...[PurchaseStatus.draft, PurchaseStatus.posted, PurchaseStatus.cancelled].map((status) => Padding(padding: const EdgeInsetsDirectional.only(end: AppSpacing.s), child: ChoiceChip(label: Text(_statusText(context, status)), selected: state.filterStatus == status, onSelected: (_) => context.read<PurchasesListCubit>().filters(status: status, supplierId: state.supplierId, from: state.from, to: state.to)))),
        ActionChip(avatar: const Icon(Icons.date_range, size: 18), label: Text(context.l10n.dateRange), onPressed: () async { final range = await showDateRangePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime.now().add(const Duration(days: 1)), initialDateRange: state.from != null && state.to != null ? DateTimeRange(start: state.from!, end: state.to!) : null); if (range != null && context.mounted) context.read<PurchasesListCubit>().filters(status: state.filterStatus, supplierId: state.supplierId, from: range.start, to: range.end); }),
      ]))),
      const SizedBox(height: AppSpacing.s),
      Expanded(child: BlocBuilder<PurchasesListCubit, PurchasesListState>(builder: (context, state) {
        if (state.status == PurchasesListStatus.loading && state.items.isEmpty) return const Center(child: AppLoading());
        if (state.status == PurchasesListStatus.failure && state.items.isEmpty) return _PurchaseRetry(message: context.localizeFailure(state.failure), onRetry: () => context.read<PurchasesListCubit>().load());
        if (state.items.isEmpty) return Center(child: Text(context.l10n.noPurchases));
        return RefreshIndicator(onRefresh: () => context.read<PurchasesListCubit>().load(refresh: true), child: NotificationListener<ScrollNotification>(onNotification: (n) { if (n.metrics.extentAfter < 240) context.read<PurchasesListCubit>().loadMore(); return false; }, child: ListView.builder(physics: const AlwaysScrollableScrollPhysics(), padding: const EdgeInsets.only(bottom: 96), itemCount: state.items.length + (state.loadingMore ? 1 : 0), itemBuilder: (context, index) {
          if (index == state.items.length) return const Padding(padding: EdgeInsets.all(AppSpacing.m), child: Center(child: AppLoading()));
          final invoice = state.items[index];
          return Card(child: ListTile(title: Text(invoice.purchaseNoInt == null ? context.l10n.draft : context.l10n.purchaseNumber(invoice.purchaseNoInt!)), subtitle: Text('${invoice.supplier?.name ?? context.l10n.unknownSupplier}\n${invoice.supplierInvoiceNumber ?? _purchaseDate(context, invoice.purchasedAt)}'), isThreeLine: true, leading: _StatusIcon(status: invoice.status), trailing: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [Text(_purchaseMoney(context, invoice.totalAmount)), Text('${context.l10n.remaining}: ${_purchaseMoney(context, invoice.remainingAmount)}')]), onTap: () async { await Navigator.of(context).pushNamed(AppRoutes.purchaseDetails, arguments: invoice.id); if (context.mounted) context.read<PurchasesListCubit>().load(refresh: true); }));
        })));
      })),
    ]),
  );
}

class PurchaseFormScreen extends StatelessWidget {
  final PurchaseInvoiceEntity? invoice;
  const PurchaseFormScreen({super.key, this.invoice});
  @override Widget build(BuildContext context) => MultiBlocProvider(providers: [
    BlocProvider(create: (_) => sl<PurchaseFormCubit>()),
    BlocProvider(create: (_) => sl<SuppliersListCubit>()..filter(true)),
    BlocProvider(create: (_) => sl<ProductsListCubit>()..loadInitial()),
  ], child: _PurchaseFormView(invoice: invoice));
}

class _PurchaseFormView extends StatefulWidget { final PurchaseInvoiceEntity? invoice; const _PurchaseFormView({this.invoice}); @override State<_PurchaseFormView> createState() => _PurchaseFormViewState(); }
class _PurchaseFormViewState extends State<_PurchaseFormView> {
  SupplierEntity? _supplier; late DateTime _purchasedAt; final _supplierInvoice = TextEditingController(); final _paid = TextEditingController(text: '0.00'); final _discount = TextEditingController(text: '0.00'); final _notes = TextEditingController(); late List<_DraftLine> _lines;
  @override void initState() { super.initState(); final invoice = widget.invoice; _supplier = invoice?.supplier; _purchasedAt = invoice?.purchasedAt ?? DateTime.now(); _supplierInvoice.text = invoice?.supplierInvoiceNumber ?? ''; _paid.text = (invoice?.paidAmount ?? 0).toStringAsFixed(2); _discount.text = (invoice?.discountAmount ?? 0).toStringAsFixed(2); _notes.text = invoice?.notes ?? ''; _lines = invoice == null || invoice.items.isEmpty ? [_DraftLine()] : invoice.items.map((item) => _DraftLine(product: item.product, quantity: item.quantity, cost: item.unitCost)).toList(); }
  @override void dispose() { _supplierInvoice.dispose(); _paid.dispose(); _discount.dispose(); _notes.dispose(); for (final line in _lines) { line.dispose(); } super.dispose(); }
  void _submit(List<ProductEntity> products) {
    if (_supplier == null) { AppToast.show(context.l10n.selectSupplier); return; }
    final paid = MoneyMinor.fromText(_paid.text); final discount = MoneyMinor.fromText(_discount.text);
    if (paid == null || paid < 0 || discount == null || discount < 0) { AppToast.show(context.l10n.invalidNonNegativeAmount); return; }
    final selected = _lines.where((line) => line.product != null).toList();
    if (selected.length != _lines.length || selected.isEmpty) { AppToast.show(context.l10n.addAtLeastOnePurchaseItem); return; }
    final ids = selected.map((line) => line.product!.id).toList(); if (ids.toSet().length != ids.length) { AppToast.show(context.l10n.duplicatePurchaseProduct); return; }
    final inputs = <PurchaseItemInput>[];
    for (final line in selected) { final quantity = int.tryParse(line.quantity.text.trim()); final cost = MoneyMinor.fromText(line.cost.text); if (quantity == null || quantity <= 0 || cost == null || cost <= 0) { AppToast.show(context.l10n.invalidPurchaseItem); return; } inputs.add(PurchaseItemInput(productId: line.product!.id, quantity: quantity, unitCost: cost / 100)); }
    context.read<PurchaseFormCubit>().submit(PurchaseDraftInput(supplierId: _supplier!.id, supplierInvoiceNumber: _supplierInvoice.text, purchasedAt: _purchasedAt, paidAmount: paid / 100, discountAmount: discount / 100, notes: _notes.text, items: inputs), existing: widget.invoice);
  }
  int _subtotalMinor() { var total = 0; for (final line in _lines) { final q = int.tryParse(line.quantity.text) ?? 0; final cost = MoneyMinor.fromText(line.cost.text) ?? 0; total += q * cost; } return total; }
  @override Widget build(BuildContext context) => BlocConsumer<PurchaseFormCubit, PurchaseFormState>(listener: (context, state) { if (state.status == PurchaseFormStatus.success) { AppToast.show(context.l10n.draftSavedNoStockChange); Navigator.of(context).pop(state.invoice ?? true); } else if (state.status == PurchaseFormStatus.failure || state.status == PurchaseFormStatus.conflict) { AppToast.show(context.localizeFailure(state.failure)); } }, builder: (context, formState) {
    final busy = formState.status == PurchaseFormStatus.submitting;
    return Scaffold(appBar: AppBar(title: Text(widget.invoice == null ? context.l10n.createPurchaseDraft : context.l10n.editPurchaseDraft)), body: BlocBuilder<SuppliersListCubit, SuppliersListState>(builder: (context, supplierState) => BlocBuilder<ProductsListCubit, ProductsListState>(builder: (context, productState) => ListView(padding: const EdgeInsets.all(AppSpacing.l), children: [
      if (supplierState.status == SuppliersListStatus.failure) Text(context.l10n.purchasesRequireInternet, style: TextStyle(color: Theme.of(context).colorScheme.error)),
      DropdownButtonFormField<SupplierEntity>(initialValue: _supplier, isExpanded: true, decoration: InputDecoration(labelText: context.l10n.supplier), items: supplierState.items.map((supplier) => DropdownMenuItem(value: supplier, child: Text(supplier.name, overflow: TextOverflow.ellipsis))).toList(), onChanged: busy ? null : (value) => setState(() => _supplier = value)),
      const SizedBox(height: AppSpacing.m), TextField(controller: _supplierInvoice, enabled: !busy, decoration: InputDecoration(labelText: context.l10n.supplierInvoiceNumber)),
      ListTile(contentPadding: EdgeInsets.zero, title: Text(context.l10n.purchaseDate), subtitle: Text(_purchaseDate(context, _purchasedAt)), trailing: const Icon(Icons.calendar_month), onTap: busy ? null : () async { final value = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime.now().add(const Duration(days: 1)), initialDate: _purchasedAt); if (value != null) setState(() => _purchasedAt = value); }),
      Row(children: [Expanded(child: TextField(controller: _paid, enabled: !busy, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: context.l10n.initialPaidAmount))), const SizedBox(width: AppSpacing.m), Expanded(child: TextField(controller: _discount, enabled: !busy, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: context.l10n.discountLabel)))]),
      const SizedBox(height: AppSpacing.m), TextField(controller: _notes, enabled: !busy, maxLines: 2, decoration: InputDecoration(labelText: context.l10n.notes)), const SizedBox(height: AppSpacing.l),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(context.l10n.purchaseItems, style: Theme.of(context).textTheme.titleMedium), IconButton(onPressed: busy ? null : () => setState(() => _lines.add(_DraftLine())), icon: const Icon(Icons.add), tooltip: context.l10n.addItem)]),
      TextField(enabled: !busy, onChanged: context.read<ProductsListCubit>().updateSearch, decoration: InputDecoration(labelText: context.l10n.searchProductsHint, prefixIcon: const Icon(Icons.search))),
      const SizedBox(height: AppSpacing.s),
      ..._lines.indexed.map((entry) => _LineEditor(key: ObjectKey(entry.$2), line: entry.$2, products: productState.products, enabled: !busy, canRemove: _lines.length > 1, onChanged: () => setState(() {}), onRemove: () => setState(() { final removed = _lines.removeAt(entry.$1); removed.dispose(); }))),
      Text('${context.l10n.subtotalPreview}: ${MoneyMinor.format(_subtotalMinor())} EGP', style: Theme.of(context).textTheme.titleMedium), Text(context.l10n.backendTotalsAuthoritative, style: Theme.of(context).textTheme.bodySmall), const SizedBox(height: AppSpacing.l),
      FilledButton(onPressed: busy ? null : () => _submit(productState.products), child: Text(busy ? context.l10n.saving : context.l10n.saveDraft)),
    ]))));
  });
}

class _DraftLine { ProductEntity? product; final TextEditingController quantity; final TextEditingController cost; _DraftLine({this.product, int quantity = 1, double? cost}) : quantity = TextEditingController(text: quantity.toString()), cost = TextEditingController(text: cost?.toStringAsFixed(2) ?? ''); void dispose() { quantity.dispose(); cost.dispose(); } }
class _LineEditor extends StatelessWidget { final _DraftLine line; final List<ProductEntity> products; final bool enabled; final bool canRemove; final VoidCallback onChanged; final VoidCallback onRemove; const _LineEditor({super.key, required this.line, required this.products, required this.enabled, required this.canRemove, required this.onChanged, required this.onRemove}); @override Widget build(BuildContext context) { final options = [...products]; if (line.product != null && !options.contains(line.product)) options.insert(0, line.product!); return Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.m), child: Column(children: [
  DropdownButtonFormField<ProductEntity>(initialValue: line.product, isExpanded: true, decoration: InputDecoration(labelText: context.l10n.productName), items: options.map((product) => DropdownMenuItem(value: product, child: Text(product.name, overflow: TextOverflow.ellipsis))).toList(), onChanged: !enabled ? null : (product) { line.product = product; if (line.cost.text.isEmpty && product?.lastPurchasePrice != null) line.cost.text = product!.lastPurchasePrice!.toStringAsFixed(2); onChanged(); }),
  if (line.product != null) Align(alignment: AlignmentDirectional.centerStart, child: Text('${context.l10n.inStockLabel}: ${line.product!.stock} · ${context.l10n.lastPurchasePrice}: ${line.product!.lastPurchasePrice?.toStringAsFixed(2) ?? context.l10n.notAvailable} · ${context.l10n.averageCost}: ${line.product!.averageCost?.toStringAsFixed(2) ?? context.l10n.notAvailable}', style: Theme.of(context).textTheme.bodySmall)),
  const SizedBox(height: AppSpacing.s), Row(children: [Expanded(child: TextField(controller: line.quantity, enabled: enabled, keyboardType: TextInputType.number, onChanged: (_) => onChanged(), decoration: InputDecoration(labelText: context.l10n.quantity))), const SizedBox(width: AppSpacing.s), Expanded(child: TextField(controller: line.cost, enabled: enabled, keyboardType: const TextInputType.numberWithOptions(decimal: true), onChanged: (_) => onChanged(), decoration: InputDecoration(labelText: context.l10n.unitCost))), if (canRemove) IconButton(onPressed: enabled ? onRemove : null, icon: const Icon(Icons.remove_circle_outline), tooltip: context.l10n.removeItem)]),
]))); } }

class PurchaseDetailsScreen extends StatelessWidget { final String purchaseId; const PurchaseDetailsScreen({super.key, required this.purchaseId}); @override Widget build(BuildContext context) => BlocProvider(create: (_) => sl<PurchaseDetailsCubit>()..load(purchaseId), child: _PurchaseDetailsView(purchaseId: purchaseId)); }
class _PurchaseDetailsView extends StatelessWidget {
  final String purchaseId; const _PurchaseDetailsView({required this.purchaseId});
  Future<bool> _confirm(BuildContext context, String title, String message, String action) async => await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: Text(title), content: Text(message), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: Text(context.l10n.cancel)), FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(action))])) ?? false;
  @override Widget build(BuildContext context) => BlocConsumer<PurchaseDetailsCubit, PurchaseDetailsState>(listener: (context, state) { if (state.status == PurchaseDetailsStatus.posted) AppToast.show(context.l10n.purchasePosted); if (state.status == PurchaseDetailsStatus.timeoutUnverified) AppToast.show(context.l10n.postTimeoutRetryHelp); if (state.status == PurchaseDetailsStatus.failure || state.status == PurchaseDetailsStatus.conflict) AppToast.show(context.localizeFailure(state.failure)); }, builder: (context, state) {
    final invoice = state.invoice; final busy = state.status == PurchaseDetailsStatus.posting || state.status == PurchaseDetailsStatus.deleting;
    return Scaffold(appBar: AppBar(title: Text(context.l10n.purchaseDetails), actions: [IconButton(onPressed: busy ? null : () => context.read<PurchaseDetailsCubit>().load(purchaseId), icon: const Icon(Icons.refresh), tooltip: context.l10n.refresh)]), body: invoice == null && state.status == PurchaseDetailsStatus.loading ? const Center(child: AppLoading()) : invoice == null ? _PurchaseRetry(message: context.localizeFailure(state.failure), onRetry: () => context.read<PurchaseDetailsCubit>().load(purchaseId)) : ListView(padding: const EdgeInsets.all(AppSpacing.l), children: [
      Wrap(spacing: AppSpacing.m, runSpacing: AppSpacing.s, children: [Chip(avatar: _StatusIcon(status: invoice.status), label: Text(_statusText(context, invoice.status))), Text(invoice.purchaseNoInt == null ? context.l10n.draft : context.l10n.purchaseNumber(invoice.purchaseNoInt!)), Text(invoice.supplier?.name ?? context.l10n.unknownSupplier)]),
      _DetailRow(context.l10n.supplierInvoiceNumber, invoice.supplierInvoiceNumber ?? context.l10n.notAvailable), _DetailRow(context.l10n.purchaseDate, _purchaseDate(context, invoice.purchasedAt)), _DetailRow(context.l10n.postingDate, _purchaseDate(context, invoice.postedAt)), if (invoice.createdByName != null) _DetailRow(context.l10n.createdBy, invoice.createdByName!),
      const Divider(), Text(context.l10n.purchaseItems, style: Theme.of(context).textTheme.titleMedium), ...invoice.items.map((item) => ListTile(contentPadding: EdgeInsets.zero, title: Text(item.product?.name ?? item.productId), subtitle: Text('${context.l10n.quantity}: ${item.quantity} · ${context.l10n.unitCost}: ${_purchaseMoney(context, item.unitCost)}'), trailing: Text(_purchaseMoney(context, item.lineTotal ?? item.quantity * item.unitCost)))),
      const Divider(), _DetailRow(context.l10n.subtotalLabel, _purchaseMoney(context, invoice.subtotalAmount)), _DetailRow(context.l10n.discountLabel, _purchaseMoney(context, invoice.discountAmount)), _DetailRow(context.l10n.totalLabel, _purchaseMoney(context, invoice.totalAmount)), _DetailRow(context.l10n.paidAmountLabel, _purchaseMoney(context, invoice.paidAmount)), _DetailRow(context.l10n.remaining, _purchaseMoney(context, invoice.remainingAmount)), if (invoice.notes != null) _DetailRow(context.l10n.notes, invoice.notes!),
      if (invoice.isDraft) ...[const SizedBox(height: AppSpacing.m), Wrap(spacing: AppSpacing.s, runSpacing: AppSpacing.s, children: [OutlinedButton.icon(onPressed: busy ? null : () async { final changed = await Navigator.of(context).pushNamed(AppRoutes.purchaseEdit, arguments: invoice); if (changed != null && context.mounted) context.read<PurchaseDetailsCubit>().load(invoice.id); }, icon: const Icon(Icons.edit), label: Text(context.l10n.edit)), OutlinedButton.icon(onPressed: busy ? null : () async { if (await _confirm(context, context.l10n.deleteDraftTitle, context.l10n.deleteDraftMessage, context.l10n.delete) && context.mounted && await context.read<PurchaseDetailsCubit>().deleteDraft() && context.mounted) Navigator.of(context).pop(true); }, icon: const Icon(Icons.delete_outline), label: Text(context.l10n.delete)), FilledButton.icon(onPressed: busy ? null : () async { if (await _confirm(context, context.l10n.postPurchaseTitle, context.l10n.postPurchaseWarning, context.l10n.postInvoice) && context.mounted) context.read<PurchaseDetailsCubit>().post(); }, icon: busy ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.publish), label: Text(context.l10n.postInvoice))])],
      if (invoice.isPosted && invoice.supplier != null && (MoneyMinor.fromDouble(invoice.remainingAmount) ?? 0) > 0) FilledButton.icon(onPressed: () => Navigator.of(context).pushNamed(AppRoutes.supplierPayment, arguments: invoice.supplier), icon: const Icon(Icons.payments), label: Text(context.l10n.recordPayment)),
      if (invoice.isPosted) OutlinedButton.icon(onPressed: () => Navigator.of(context).pushNamed(AppRoutes.stockMovements, arguments: {'purchaseInvoiceId': invoice.id}), icon: const Icon(Icons.swap_vert), label: Text(context.l10n.stockMovements)),
    ]));
  });
}

class _DetailRow extends StatelessWidget { final String label; final String value; const _DetailRow(this.label, this.value); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))), Expanded(flex: 2, child: Text(value, textAlign: TextAlign.end))])); }
class _StatusIcon extends StatelessWidget { final PurchaseStatus status; const _StatusIcon({required this.status}); @override Widget build(BuildContext context) { final color = switch (status) { PurchaseStatus.draft => Theme.of(context).colorScheme.secondary, PurchaseStatus.posted => Colors.green.shade700, PurchaseStatus.cancelled => Theme.of(context).colorScheme.error, PurchaseStatus.unknown => Theme.of(context).colorScheme.outline }; return Icon(status == PurchaseStatus.posted ? Icons.check_circle : Icons.description_outlined, color: color); } }
String _statusText(BuildContext context, PurchaseStatus status) => switch (status) { PurchaseStatus.draft => context.l10n.draft, PurchaseStatus.posted => context.l10n.posted, PurchaseStatus.cancelled => context.l10n.cancelled, PurchaseStatus.unknown => context.l10n.unknownStatus };
class _PurchaseRetry extends StatelessWidget { final String message; final VoidCallback onRetry; const _PurchaseRetry({required this.message, required this.onRetry}); @override Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text(message), FilledButton(onPressed: onRetry, child: Text(context.l10n.retry))])); }
