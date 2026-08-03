import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/purchases/domain/entities/purchase_entities.dart';
import 'package:maktabty/features/purchases/domain/usecases/purchase_usecases.dart';

enum PurchaseFormStatus { idle, submitting, success, failure, conflict }
class PurchaseFormState extends Equatable {
  final PurchaseFormStatus status;
  final PurchaseInvoiceEntity? invoice;
  final AppFailure? failure;
  const PurchaseFormState(this.status, {this.invoice, this.failure});
  @override List<Object?> get props => [status, invoice, failure];
}

class PurchaseFormCubit extends Cubit<PurchaseFormState> {
  final PurchaseUseCases _useCases;
  PurchaseFormCubit(this._useCases) : super(const PurchaseFormState(PurchaseFormStatus.idle));
  Future<void> submit(PurchaseDraftInput input, {PurchaseInvoiceEntity? existing}) async {
    if (state.status == PurchaseFormStatus.submitting) return;
    if (existing != null && !existing.isDraft) { emit(const PurchaseFormState(PurchaseFormStatus.conflict, failure: ConflictFailure())); return; }
    emit(const PurchaseFormState(PurchaseFormStatus.submitting));
    try {
      final invoice = existing == null ? await _useCases.createDraft(input) : await _useCases.updateDraft(existing.id, input);
      if (!isClosed) emit(PurchaseFormState(PurchaseFormStatus.success, invoice: invoice));
    } on AppFailure catch (failure) { if (!isClosed) emit(PurchaseFormState(failure.code == FailureCode.conflict ? PurchaseFormStatus.conflict : PurchaseFormStatus.failure, failure: failure)); }
  }
}
