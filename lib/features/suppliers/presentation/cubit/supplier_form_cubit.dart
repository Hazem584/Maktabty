import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/suppliers/domain/entities/supplier_entities.dart';
import 'package:maktabty/features/suppliers/domain/usecases/supplier_usecases.dart';

enum SupplierFormStatus { idle, submitting, success, failure, conflict }
class SupplierFormState extends Equatable {
  final SupplierFormStatus status;
  final SupplierEntity? supplier;
  final AppFailure? failure;
  const SupplierFormState(this.status, {this.supplier, this.failure});
  @override List<Object?> get props => [status, supplier, failure];
}

class SupplierFormCubit extends Cubit<SupplierFormState> {
  final SupplierUseCases _useCases;
  SupplierFormCubit(this._useCases) : super(const SupplierFormState(SupplierFormStatus.idle));
  Future<void> submit({SupplierEntity? existing, required String name, String? phone, String? email, String? address, String? taxNumber, String? notes, bool? isActive}) async {
    if (state.status == SupplierFormStatus.submitting) return;
    emit(const SupplierFormState(SupplierFormStatus.submitting));
    try {
      SupplierEntity supplier;
      if (existing == null) {
        supplier = await _useCases.create(name: name.trim(), phone: phone, email: email, address: address, taxNumber: taxNumber, notes: notes);
      } else {
        supplier = await _useCases.update(id: existing.id, name: name.trim(), phone: phone, email: email, address: address, taxNumber: taxNumber, notes: notes, isActive: existing.isActive || isActive == true ? (isActive == true ? true : null) : isActive);
        if (existing.isActive && isActive == false) {
          supplier = await _useCases.deactivate(existing.id);
        }
      }
      if (!isClosed) emit(SupplierFormState(SupplierFormStatus.success, supplier: supplier));
    } on AppFailure catch (failure) {
      if (!isClosed) emit(SupplierFormState(failure.code == FailureCode.conflict ? SupplierFormStatus.conflict : SupplierFormStatus.failure, failure: failure));
    }
  }
  Future<bool> deactivate(String id) async {
    if (state.status == SupplierFormStatus.submitting) return false;
    emit(const SupplierFormState(SupplierFormStatus.submitting));
    try { final value = await _useCases.deactivate(id); if (!isClosed) emit(SupplierFormState(SupplierFormStatus.success, supplier: value)); return true; }
    on AppFailure catch (failure) { if (!isClosed) emit(SupplierFormState(SupplierFormStatus.failure, failure: failure)); return false; }
  }
}
