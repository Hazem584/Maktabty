import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:maktabty/features/purchases/domain/entities/purchase_entities.dart';
import 'package:maktabty/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:maktabty/features/suppliers/domain/usecases/supplier_usecases.dart';

enum PurchaseDetailsStatus { initial, loading, ready, deleting, posting, posted, timeoutUnverified, failure, conflict }
class PurchaseDetailsState extends Equatable {
  final PurchaseDetailsStatus status;
  final PurchaseInvoiceEntity? invoice;
  final AppFailure? failure;
  const PurchaseDetailsState(this.status, {this.invoice, this.failure});
  @override List<Object?> get props => [status, invoice, failure];
}

class PurchaseDetailsCubit extends Cubit<PurchaseDetailsState> {
  final PurchaseUseCases _purchases;
  final SupplierUseCases _suppliers;
  final GetProductByIdUseCase _getProduct;
  PurchaseDetailsCubit(this._purchases, this._suppliers, this._getProduct) : super(const PurchaseDetailsState(PurchaseDetailsStatus.initial));
  Future<void> load(String id) async {
    emit(PurchaseDetailsState(PurchaseDetailsStatus.loading, invoice: state.invoice));
    try { final invoice = await _purchases.getPurchase(id); if (!isClosed) emit(PurchaseDetailsState(PurchaseDetailsStatus.ready, invoice: invoice)); }
    on AppFailure catch (failure) { if (!isClosed) emit(PurchaseDetailsState(PurchaseDetailsStatus.failure, invoice: state.invoice, failure: failure)); }
  }
  Future<bool> deleteDraft() async {
    final invoice = state.invoice;
    if (invoice == null || !invoice.isDraft || state.status == PurchaseDetailsStatus.deleting) return false;
    emit(PurchaseDetailsState(PurchaseDetailsStatus.deleting, invoice: invoice));
    try { await _purchases.deleteDraft(invoice.id); return true; }
    on AppFailure catch (failure) { if (!isClosed) emit(PurchaseDetailsState(failure.code == FailureCode.conflict ? PurchaseDetailsStatus.conflict : PurchaseDetailsStatus.failure, invoice: invoice, failure: failure)); return false; }
  }
  Future<void> post() async {
    final invoice = state.invoice;
    if (invoice == null || !invoice.isDraft || state.status == PurchaseDetailsStatus.posting) return;
    emit(PurchaseDetailsState(PurchaseDetailsStatus.posting, invoice: invoice));
    try {
      final posted = await _purchases.postDraft(invoice.id);
      await _refreshAuthoritativeData(posted);
      if (!isClosed) emit(PurchaseDetailsState(PurchaseDetailsStatus.posted, invoice: posted));
    } on TimeoutFailure {
      await _verifyAfterTimeout(invoice);
    } on AppFailure catch (failure) {
      if (failure.code == FailureCode.conflict) {
        try {
          final current = await _purchases.getPurchase(invoice.id);
          if (current.isPosted) { await _refreshAuthoritativeData(current); if (!isClosed) emit(PurchaseDetailsState(PurchaseDetailsStatus.posted, invoice: current)); return; }
        } catch (_) {}
      }
      if (!isClosed) emit(PurchaseDetailsState(failure.code == FailureCode.conflict ? PurchaseDetailsStatus.conflict : PurchaseDetailsStatus.failure, invoice: invoice, failure: failure));
    }
  }
  Future<void> _verifyAfterTimeout(PurchaseInvoiceEntity previous) async {
    try {
      final current = await _purchases.getPurchase(previous.id);
      if (current.isPosted) { await _refreshAuthoritativeData(current); if (!isClosed) emit(PurchaseDetailsState(PurchaseDetailsStatus.posted, invoice: current)); }
      else if (!isClosed) { emit(PurchaseDetailsState(PurchaseDetailsStatus.timeoutUnverified, invoice: current, failure: const TimeoutFailure(FailureCode.receiveTimeout))); }
    } catch (_) { if (!isClosed) emit(PurchaseDetailsState(PurchaseDetailsStatus.timeoutUnverified, invoice: previous, failure: const TimeoutFailure(FailureCode.receiveTimeout))); }
  }
  Future<void> _refreshAuthoritativeData(PurchaseInvoiceEntity invoice) async {
    try {
      await Future.wait<void>([
        for (final productId in invoice.items.map((item) => item.productId).toSet()) _getProduct(productId).then((_) {}),
        if (invoice.supplierId.isNotEmpty) _suppliers.getStatement(invoice.supplierId).then((_) {}),
      ]);
    } catch (_) {
      // Posting is already authoritative. A later screen refresh will retry
      // any product-cache or statement refresh that failed here.
    }
  }
}
