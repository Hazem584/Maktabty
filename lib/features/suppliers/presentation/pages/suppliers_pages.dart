import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/routes/app_routes.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/app_loading.dart';
import 'package:maktabty/core/widgets/app_toast.dart';
import 'package:maktabty/features/purchases/domain/entities/purchase_entities.dart';
import 'package:maktabty/features/suppliers/domain/entities/supplier_entities.dart';
import 'package:maktabty/features/suppliers/presentation/cubit/supplier_details_cubit.dart';
import 'package:maktabty/features/suppliers/presentation/cubit/supplier_form_cubit.dart';
import 'package:maktabty/features/suppliers/presentation/cubit/supplier_payment_cubit.dart';
import 'package:maktabty/features/suppliers/presentation/cubit/suppliers_list_cubit.dart';

String _money(BuildContext context, double value) => NumberFormat.currency(locale: Localizations.localeOf(context).toLanguageTag(), name: 'EGP', decimalDigits: 2).format(value);
String _formatDate(BuildContext context, DateTime? value) => value == null ? context.l10n.notAvailable : DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag()).format(value.toLocal());

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({super.key});
  @override Widget build(BuildContext context) => BlocProvider(create: (_) => sl<SuppliersListCubit>()..load(), child: const _SuppliersView());
}

class _SuppliersView extends StatelessWidget {
  const _SuppliersView();
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.suppliers), actions: [IconButton(onPressed: () => context.read<SuppliersListCubit>().load(refresh: true), icon: const Icon(Icons.refresh), tooltip: context.l10n.refresh)]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () async { final changed = await Navigator.of(context).pushNamed(AppRoutes.supplierCreate); if (changed == true && context.mounted) context.read<SuppliersListCubit>().load(refresh: true); }, icon: const Icon(Icons.add), label: Text(context.l10n.addSupplier)),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(AppSpacing.m), child: TextField(onChanged: context.read<SuppliersListCubit>().search, decoration: InputDecoration(labelText: context.l10n.searchSuppliers, prefixIcon: const Icon(Icons.search)))),
        BlocBuilder<SuppliersListCubit, SuppliersListState>(builder: (context, state) => Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m), child: Wrap(spacing: AppSpacing.s, children: [
          ChoiceChip(label: Text(context.l10n.active), selected: state.activeFilter == true, onSelected: (_) => context.read<SuppliersListCubit>().filter(true)),
          ChoiceChip(label: Text(context.l10n.inactive), selected: state.activeFilter == false, onSelected: (_) => context.read<SuppliersListCubit>().filter(false)),
          ChoiceChip(label: Text(context.l10n.all), selected: state.activeFilter == null, onSelected: (_) => context.read<SuppliersListCubit>().filter(null)),
        ]))),
        const SizedBox(height: AppSpacing.s),
        Expanded(child: BlocBuilder<SuppliersListCubit, SuppliersListState>(builder: (context, state) {
          if (state.status == SuppliersListStatus.loading && state.items.isEmpty) return const Center(child: AppLoading());
          if (state.status == SuppliersListStatus.failure && state.items.isEmpty) return _Retry(message: context.localizeFailure(state.failure), onRetry: () => context.read<SuppliersListCubit>().load());
          if (state.items.isEmpty) return Center(child: Text(context.l10n.noSuppliers));
          return RefreshIndicator(onRefresh: () => context.read<SuppliersListCubit>().load(refresh: true), child: NotificationListener<ScrollNotification>(onNotification: (notification) { if (notification.metrics.extentAfter < 240) context.read<SuppliersListCubit>().loadMore(); return false; }, child: ListView.builder(physics: const AlwaysScrollableScrollPhysics(), padding: const EdgeInsets.only(bottom: 96), itemCount: state.items.length + (state.loadingMore ? 1 : 0), itemBuilder: (context, index) {
            if (index == state.items.length) return const Padding(padding: EdgeInsets.all(AppSpacing.m), child: Center(child: AppLoading()));
            final supplier = state.items[index];
            return ListTile(title: Text(supplier.name, maxLines: 1, overflow: TextOverflow.ellipsis), subtitle: Text(supplier.phone ?? context.l10n.notAvailable), leading: Icon(supplier.isActive ? Icons.business : Icons.business_outlined), trailing: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [Text(supplier.isActive ? context.l10n.active : context.l10n.inactive), if (supplier.balance != null) Text(_money(context, supplier.balance!))]), onTap: () async { await Navigator.of(context).pushNamed(AppRoutes.supplierDetails, arguments: supplier.id); if (context.mounted) context.read<SuppliersListCubit>().load(refresh: true); });
          })));
        })),
      ]),
    );
  }
}

class SupplierFormScreen extends StatelessWidget {
  final SupplierEntity? supplier;
  const SupplierFormScreen({super.key, this.supplier});
  @override Widget build(BuildContext context) => BlocProvider(create: (_) => sl<SupplierFormCubit>(), child: _SupplierFormView(supplier: supplier));
}

class _SupplierFormView extends StatefulWidget {
  final SupplierEntity? supplier;
  const _SupplierFormView({this.supplier});
  @override State<_SupplierFormView> createState() => _SupplierFormViewState();
}

class _SupplierFormViewState extends State<_SupplierFormView> {
  final _key = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _fields;
  late bool _active;
  @override void initState() { super.initState(); final s = widget.supplier; _active = s?.isActive ?? true; _fields = {'name': TextEditingController(text: s?.name), 'phone': TextEditingController(text: s?.phone), 'email': TextEditingController(text: s?.email), 'address': TextEditingController(text: s?.address), 'tax': TextEditingController(text: s?.taxNumber), 'notes': TextEditingController(text: s?.notes)}; }
  @override void dispose() { for (final controller in _fields.values) { controller.dispose(); } super.dispose(); }
  String? _optional(String key) { final value = _fields[key]!.text.trim(); return value.isEmpty ? null : value; }
  Future<void> _save() async {
    if (!_key.currentState!.validate()) return;
    if (widget.supplier?.isActive == true && !_active) {
      final confirmed = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(title: Text(context.l10n.deactivateSupplierTitle), content: Text(context.l10n.deactivateSupplierMessage), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(context.l10n.cancel)), FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text(context.l10n.deactivate))]));
      if (confirmed != true || !mounted) return;
    }
    context.read<SupplierFormCubit>().submit(existing: widget.supplier, name: _fields['name']!.text, phone: _optional('phone'), email: _optional('email'), address: _optional('address'), taxNumber: _optional('tax'), notes: _optional('notes'), isActive: widget.supplier == null ? null : _active);
  }
  @override Widget build(BuildContext context) => BlocConsumer<SupplierFormCubit, SupplierFormState>(listener: (context, state) { if (state.status == SupplierFormStatus.success) Navigator.of(context).pop(true); if (state.status == SupplierFormStatus.failure || state.status == SupplierFormStatus.conflict) AppToast.show(context.localizeFailure(state.failure)); }, builder: (context, state) {
    final busy = state.status == SupplierFormStatus.submitting;
    InputDecoration decoration(String label) => InputDecoration(labelText: label);
    return Scaffold(appBar: AppBar(title: Text(widget.supplier == null ? context.l10n.addSupplier : context.l10n.editSupplier)), body: Form(key: _key, child: ListView(padding: const EdgeInsets.all(AppSpacing.l), children: [
      TextFormField(controller: _fields['name'], enabled: !busy, decoration: decoration(context.l10n.supplierName), validator: (value) => value?.trim().isEmpty == true ? context.l10n.requiredField : null),
      const SizedBox(height: AppSpacing.m), TextFormField(controller: _fields['phone'], enabled: !busy, keyboardType: TextInputType.phone, decoration: decoration(context.l10n.phoneLabel)),
      const SizedBox(height: AppSpacing.m), TextFormField(controller: _fields['email'], enabled: !busy, keyboardType: TextInputType.emailAddress, decoration: decoration(context.l10n.emailAddress), validator: (value) { final text = value?.trim() ?? ''; return text.isNotEmpty && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text) ? context.l10n.invalidEmail : null; }),
      const SizedBox(height: AppSpacing.m), TextFormField(controller: _fields['address'], enabled: !busy, decoration: decoration(context.l10n.address)),
      const SizedBox(height: AppSpacing.m), TextFormField(controller: _fields['tax'], enabled: !busy, decoration: decoration(context.l10n.taxNumberLabel)),
      const SizedBox(height: AppSpacing.m), TextFormField(controller: _fields['notes'], enabled: !busy, maxLines: 3, decoration: decoration(context.l10n.notes)),
      if (widget.supplier != null) SwitchListTile(value: _active, onChanged: busy ? null : (value) => setState(() => _active = value), title: Text(context.l10n.activeSupplier)),
      const SizedBox(height: AppSpacing.l), FilledButton(onPressed: busy ? null : _save, child: Text(busy ? context.l10n.saving : context.l10n.save)),
    ])));
  });
}

class SupplierDetailsScreen extends StatelessWidget {
  final String supplierId;
  const SupplierDetailsScreen({super.key, required this.supplierId});
  @override Widget build(BuildContext context) => BlocProvider(create: (_) => sl<SupplierDetailsCubit>()..load(supplierId), child: _SupplierDetailsView(supplierId: supplierId));
}

class _SupplierDetailsView extends StatelessWidget {
  final String supplierId;
  const _SupplierDetailsView({required this.supplierId});
  @override Widget build(BuildContext context) => BlocBuilder<SupplierDetailsCubit, SupplierDetailsState>(builder: (context, state) {
    final supplier = state.supplier;
    return Scaffold(appBar: AppBar(title: Text(supplier?.name ?? context.l10n.supplierDetails), actions: [IconButton(onPressed: () async { final range = await showDateRangePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime.now().add(const Duration(days: 1))); if (range != null && context.mounted) context.read<SupplierDetailsCubit>().load(supplierId, from: range.start, to: range.end); }, icon: const Icon(Icons.date_range), tooltip: context.l10n.dateRange), IconButton(onPressed: () => context.read<SupplierDetailsCubit>().load(supplierId), icon: const Icon(Icons.refresh), tooltip: context.l10n.refresh)]), body: state.status == SupplierDetailsStatus.loading && supplier == null ? const Center(child: AppLoading()) : state.status == SupplierDetailsStatus.failure && supplier == null ? _Retry(message: context.localizeFailure(state.failure), onRetry: () => context.read<SupplierDetailsCubit>().load(supplierId)) : supplier == null ? Center(child: Text(context.l10n.noSupplierData)) : RefreshIndicator(onRefresh: () => context.read<SupplierDetailsCubit>().load(supplierId), child: ListView(padding: const EdgeInsets.all(AppSpacing.l), children: [
      _Section(title: context.l10n.supplierInformation, children: [Text(supplier.name, style: Theme.of(context).textTheme.titleMedium), Text(supplier.phone ?? context.l10n.notAvailable), Text(supplier.email ?? context.l10n.notAvailable), Text(supplier.address ?? context.l10n.notAvailable)]),
      _Section(title: context.l10n.outstandingBalance, children: [Text(_money(context, state.statement?.outstandingBalance ?? supplier.balance ?? 0), style: Theme.of(context).textTheme.headlineSmall)]),
      Row(children: [Expanded(child: FilledButton.icon(onPressed: () async { await Navigator.of(context).pushNamed(AppRoutes.supplierPayment, arguments: supplier); if (context.mounted) context.read<SupplierDetailsCubit>().load(supplierId); }, icon: const Icon(Icons.payments), label: Text(context.l10n.recordPayment))), const SizedBox(width: AppSpacing.s), Expanded(child: OutlinedButton.icon(onPressed: () async { final changed = await Navigator.of(context).pushNamed(AppRoutes.supplierEdit, arguments: supplier); if (changed == true && context.mounted) context.read<SupplierDetailsCubit>().load(supplierId); }, icon: const Icon(Icons.edit), label: Text(context.l10n.edit)))]),
      _Section(title: context.l10n.purchaseInvoices, children: state.purchases.isEmpty ? [Text(context.l10n.noPurchaseInvoices)] : state.purchases.map((invoice) => ListTile(contentPadding: EdgeInsets.zero, title: Text(invoice.purchaseNoInt?.toString() ?? context.l10n.draft), subtitle: Text(invoice.supplierInvoiceNumber ?? _formatDate(context, invoice.purchasedAt)), trailing: Text(_money(context, invoice.remainingAmount)), onTap: () => Navigator.of(context).pushNamed(AppRoutes.purchaseDetails, arguments: invoice.id))).toList()),
      _Section(title: context.l10n.payments, children: state.payments.isEmpty ? [Text(context.l10n.noPayments)] : state.payments.map((payment) => ListTile(contentPadding: EdgeInsets.zero, title: Text(_money(context, payment.amount)), subtitle: Text(payment.reference ?? _formatDate(context, payment.paidAt)))).toList()),
      _Statement(statement: state.statement),
    ])));
  });
}

class _Statement extends StatelessWidget {
  final SupplierStatementEntity? statement;
  const _Statement({this.statement});
  @override Widget build(BuildContext context) { final value = statement; if (value == null) return _Section(title: context.l10n.statement, children: [Text(context.l10n.noStatementEntries)]); return _Section(title: context.l10n.statement, children: [Wrap(spacing: AppSpacing.l, runSpacing: AppSpacing.s, children: [Text('${context.l10n.totalPurchases}: ${_money(context, value.totalPurchases ?? 0)}'), Text('${context.l10n.totalPaid}: ${_money(context, value.totalPaid ?? 0)}'), Text('${context.l10n.outstandingBalance}: ${_money(context, value.outstandingBalance ?? 0)}')]), const Divider(), if (value.entries.isEmpty) Text(context.l10n.noStatementEntries), ...value.entries.map((entry) => ListTile(contentPadding: EdgeInsets.zero, title: Text(entry.reference ?? context.l10n.notAvailable), subtitle: Text(_formatDate(context, entry.occurredAt)), trailing: Text('${context.l10n.debit}: ${_money(context, entry.debitAmount)}\n${context.l10n.credit}: ${_money(context, entry.creditAmount)}', textAlign: TextAlign.end)))]); }
}

class SupplierPaymentScreen extends StatelessWidget {
  final SupplierEntity supplier;
  const SupplierPaymentScreen({super.key, required this.supplier});
  @override Widget build(BuildContext context) => BlocProvider(create: (_) => sl<SupplierPaymentCubit>()..loadInvoices(supplier.id), child: _PaymentView(supplier: supplier));
}

class _PaymentView extends StatefulWidget { final SupplierEntity supplier; const _PaymentView({required this.supplier}); @override State<_PaymentView> createState() => _PaymentViewState(); }
class _PaymentViewState extends State<_PaymentView> {
  final _amount = TextEditingController(); final _reference = TextEditingController(); final _notes = TextEditingController(); PurchaseInvoiceEntity? _invoice; SupplierPaymentMethod _method = SupplierPaymentMethod.cash; DateTime _date = DateTime.now();
  @override void dispose() { _amount.dispose(); _reference.dispose(); _notes.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => BlocConsumer<SupplierPaymentCubit, SupplierPaymentState>(listener: (context, state) { if (state.status == SupplierPaymentStatus.success) { AppToast.show(context.l10n.paymentRecorded); Navigator.of(context).pop(true); } else if (state.status == SupplierPaymentStatus.validation) { AppToast.show(context.l10n.invalidPaymentAmount); } else if (state.status == SupplierPaymentStatus.failure || state.status == SupplierPaymentStatus.conflict) { AppToast.show(context.localizeFailure(state.failure)); } }, builder: (context, state) {
    final busy = state.status == SupplierPaymentStatus.submitting;
    return Scaffold(appBar: AppBar(title: Text(context.l10n.recordSupplierPayment)), body: state.status == SupplierPaymentStatus.loading ? const Center(child: AppLoading()) : ListView(padding: const EdgeInsets.all(AppSpacing.l), children: [
      Text(widget.supplier.name, style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: AppSpacing.m),
      DropdownButtonFormField<PurchaseInvoiceEntity>(initialValue: _invoice, decoration: InputDecoration(labelText: context.l10n.purchaseInvoice), items: state.invoices.map((invoice) => DropdownMenuItem(value: invoice, child: Text('${invoice.purchaseNoInt ?? context.l10n.draft} · ${_money(context, invoice.remainingAmount)}'))).toList(), onChanged: busy ? null : (value) => setState(() => _invoice = value)),
      const SizedBox(height: AppSpacing.m), TextField(controller: _amount, enabled: !busy, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: context.l10n.amount, helperText: _invoice == null ? null : context.l10n.remainingAmount(_money(context, _invoice!.remainingAmount)))),
      const SizedBox(height: AppSpacing.m), DropdownButtonFormField<SupplierPaymentMethod>(initialValue: _method, decoration: InputDecoration(labelText: context.l10n.paymentMethodLabel), items: [SupplierPaymentMethod.cash, SupplierPaymentMethod.card, SupplierPaymentMethod.bankTransfer, SupplierPaymentMethod.other].map((method) => DropdownMenuItem(value: method, child: Text(_paymentMethod(context, method)))).toList(), onChanged: busy ? null : (value) => setState(() => _method = value!)),
      ListTile(contentPadding: EdgeInsets.zero, title: Text(context.l10n.paidDate), subtitle: Text(_formatDate(context, _date)), trailing: const Icon(Icons.calendar_month), onTap: busy ? null : () async { final picked = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime.now().add(const Duration(days: 1)), initialDate: _date); if (picked != null) setState(() => _date = picked); }),
      TextField(controller: _reference, enabled: !busy, decoration: InputDecoration(labelText: context.l10n.reference)), const SizedBox(height: AppSpacing.m), TextField(controller: _notes, enabled: !busy, maxLines: 3, decoration: InputDecoration(labelText: context.l10n.notes)), const SizedBox(height: AppSpacing.l),
      FilledButton(onPressed: busy || _invoice == null ? null : () => context.read<SupplierPaymentCubit>().submit(supplierId: widget.supplier.id, invoice: _invoice!, amountText: _amount.text, method: _method, paidAt: _date, reference: _reference.text, notes: _notes.text), child: Text(busy ? context.l10n.saving : context.l10n.recordPayment)),
    ]));
  });
}

String _paymentMethod(BuildContext context, SupplierPaymentMethod method) => switch (method) { SupplierPaymentMethod.cash => context.l10n.cashPayment, SupplierPaymentMethod.card => context.l10n.cardPayment, SupplierPaymentMethod.bankTransfer => context.l10n.bankTransfer, SupplierPaymentMethod.other || SupplierPaymentMethod.unknown => context.l10n.other };

class _Section extends StatelessWidget { final String title; final List<Widget> children; const _Section({required this.title, required this.children}); @override Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: AppSpacing.m), child: Padding(padding: const EdgeInsets.all(AppSpacing.m), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleMedium), const Divider(), ...children]))); }
class _Retry extends StatelessWidget { final String message; final VoidCallback onRetry; const _Retry({required this.message, required this.onRetry}); @override Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text(message), const SizedBox(height: AppSpacing.s), FilledButton(onPressed: onRetry, child: Text(context.l10n.retry))])); }
