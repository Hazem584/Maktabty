import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/cashiers/domain/entities/cashier_entity.dart';
import 'package:maktabty/features/cashiers/domain/usecases/cashier_usecases.dart';

enum CashierFormStatus { initial, submitting, success, failure }

class CashierFormState extends Equatable {
  final CashierFormStatus status;
  final CashierEntity? cashier;
  final AppFailure? failure;
  const CashierFormState({required this.status, this.cashier, this.failure});
  factory CashierFormState.initial() => const CashierFormState(status: CashierFormStatus.initial);
  @override
  List<Object?> get props => [status, cashier, failure];
}

class CashierFormCubit extends Cubit<CashierFormState> {
  final CashierUseCases _useCases;
  CashierFormCubit(this._useCases) : super(CashierFormState.initial());

  Future<void> create({required String fullName, required String email, required String password}) async {
    if (state.status == CashierFormStatus.submitting) return;
    emit(const CashierFormState(status: CashierFormStatus.submitting));
    try {
      final cashier = await _useCases.createCashier(fullName: fullName, email: email, password: password);
      if (!isClosed) emit(CashierFormState(status: CashierFormStatus.success, cashier: cashier));
    } on AppFailure catch (failure) {
      if (!isClosed) emit(CashierFormState(status: CashierFormStatus.failure, failure: failure));
    } catch (_) {
      if (!isClosed) emit(const CashierFormState(status: CashierFormStatus.failure, failure: UnknownFailure()));
    }
  }

  Future<void> update({required CashierEntity existing, required String fullName, required String email}) async {
    if (state.status == CashierFormStatus.submitting) return;
    final normalizedName = fullName.trim();
    final normalizedEmail = email.trim().toLowerCase();
    final changedName = normalizedName == existing.fullName.trim() ? null : normalizedName;
    final changedEmail = normalizedEmail == existing.email.trim().toLowerCase() ? null : normalizedEmail;
    if (changedName == null && changedEmail == null) {
      emit(CashierFormState(status: CashierFormStatus.success, cashier: existing));
      return;
    }
    emit(const CashierFormState(status: CashierFormStatus.submitting));
    try {
      final cashier = await _useCases.updateCashier(id: existing.id, fullName: changedName, email: changedEmail);
      if (!isClosed) emit(CashierFormState(status: CashierFormStatus.success, cashier: cashier));
    } on AppFailure catch (failure) {
      if (!isClosed) emit(CashierFormState(status: CashierFormStatus.failure, failure: failure));
    } catch (_) {
      if (!isClosed) emit(const CashierFormState(status: CashierFormStatus.failure, failure: UnknownFailure()));
    }
  }
}
