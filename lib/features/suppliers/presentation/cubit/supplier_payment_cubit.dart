import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/database/money_minor.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/purchases/domain/entities/purchase_entities.dart';
import 'package:maktabty/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:maktabty/features/suppliers/domain/entities/supplier_entities.dart';
import 'package:maktabty/features/suppliers/domain/usecases/supplier_usecases.dart';

enum SupplierPaymentStatus { initial, loading, ready, submitting, success, failure, conflict, validation }
class SupplierPaymentState extends Equatable {
  final SupplierPaymentStatus status;
  final List<PurchaseInvoiceEntity> invoices;
  final SupplierPaymentEntity? payment;
  final AppFailure? failure;
  const SupplierPaymentState({required this.status, this.invoices = const [], this.payment, this.failure});
  @override List<Object?> get props => [status, invoices, payment, failure];
}

class SupplierPaymentCubit extends Cubit<SupplierPaymentState> {
  final SupplierUseCases _suppliers;
  final PurchaseUseCases _purchases;
  SupplierPaymentCubit(this._suppliers, this._purchases) : super(const SupplierPaymentState(status: SupplierPaymentStatus.initial));
  Future<void> loadInvoices(String supplierId) async {
    emit(const SupplierPaymentState(status: SupplierPaymentStatus.loading));
    try {
      final page = await _purchases.getPurchases(supplierId: supplierId, status: PurchaseStatus.posted, page: 1, limit: 100);
      final invoices = page.items.where((item) => (MoneyMinor.fromDouble(item.remainingAmount) ?? 0) > 0).toList(growable: false);
      if (!isClosed) emit(SupplierPaymentState(status: SupplierPaymentStatus.ready, invoices: invoices));
    } on AppFailure catch (failure) { if (!isClosed) emit(SupplierPaymentState(status: SupplierPaymentStatus.failure, failure: failure)); }
  }
  Future<void> submit({required String supplierId, required PurchaseInvoiceEntity invoice, required String amountText, required SupplierPaymentMethod method, required DateTime paidAt, String? reference, String? notes}) async {
    if (state.status == SupplierPaymentStatus.submitting) return;
    final amountMinor = MoneyMinor.fromText(amountText);
    final remainingMinor = MoneyMinor.fromDouble(invoice.remainingAmount) ?? 0;
    if (amountMinor == null || amountMinor <= 0 || amountMinor > remainingMinor) { emit(SupplierPaymentState(status: SupplierPaymentStatus.validation, invoices: state.invoices)); return; }
    emit(SupplierPaymentState(status: SupplierPaymentStatus.submitting, invoices: state.invoices));
    try {
      final payment = await _suppliers.createPayment(supplierId: supplierId, purchaseInvoiceId: invoice.id, amount: amountMinor / 100, method: method, paidAt: paidAt, reference: reference, notes: notes);
      try {
        await Future.wait([_suppliers.getStatement(supplierId), _purchases.getPurchase(invoice.id)]);
      } catch (_) {
        // The payment response is authoritative; the caller refreshes the
        // supplier details again after this screen closes.
      }
      if (!isClosed) emit(SupplierPaymentState(status: SupplierPaymentStatus.success, invoices: state.invoices, payment: payment));
    } on AppFailure catch (failure) {
      if (!isClosed) emit(SupplierPaymentState(status: failure.code == FailureCode.conflict ? SupplierPaymentStatus.conflict : SupplierPaymentStatus.failure, invoices: state.invoices, failure: failure));
    }
  }
}
