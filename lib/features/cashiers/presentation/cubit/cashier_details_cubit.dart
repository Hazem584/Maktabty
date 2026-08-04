import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/cashiers/domain/entities/cashier_entity.dart';
import 'package:maktabty/features/cashiers/domain/usecases/cashier_usecases.dart';

enum CashierDetailsStatus { initial, loading, success, submitting, failure }
enum CashierDetailsAction { none, enabled, disabled }

class CashierDetailsState extends Equatable {
  final CashierDetailsStatus status;
  final CashierEntity? cashier;
  final CashierDetailsAction action;
  final AppFailure? failure;
  const CashierDetailsState({required this.status, this.cashier, this.action = CashierDetailsAction.none, this.failure});
  factory CashierDetailsState.initial() => const CashierDetailsState(status: CashierDetailsStatus.initial);
  @override
  List<Object?> get props => [status, cashier, action, failure];
}

class CashierDetailsCubit extends Cubit<CashierDetailsState> {
  final CashierUseCases _useCases;
  CashierDetailsCubit(this._useCases) : super(CashierDetailsState.initial());

  Future<void> load(String id) async {
    if (id.isEmpty) return;
    emit(CashierDetailsState(status: CashierDetailsStatus.loading, cashier: state.cashier));
    try {
      final cashier = await _useCases.getCashier(id);
      if (!isClosed) emit(CashierDetailsState(status: CashierDetailsStatus.success, cashier: cashier));
    } on AppFailure catch (failure) {
      if (!isClosed) emit(CashierDetailsState(status: CashierDetailsStatus.failure, cashier: state.cashier, failure: failure));
    } catch (_) {
      if (!isClosed) emit(CashierDetailsState(status: CashierDetailsStatus.failure, cashier: state.cashier, failure: const UnknownFailure()));
    }
  }

  Future<void> setStatus(bool isActive) async {
    final cashier = state.cashier;
    if (cashier == null || state.status == CashierDetailsStatus.submitting) return;
    emit(CashierDetailsState(status: CashierDetailsStatus.submitting, cashier: cashier));
    try {
      final updated = await _useCases.setCashierStatus(id: cashier.id, isActive: isActive);
      if (!isClosed) emit(CashierDetailsState(status: CashierDetailsStatus.success, cashier: updated, action: isActive ? CashierDetailsAction.enabled : CashierDetailsAction.disabled));
    } on AppFailure catch (failure) {
      if (!isClosed) emit(CashierDetailsState(status: CashierDetailsStatus.failure, cashier: cashier, failure: failure));
    } catch (_) {
      if (!isClosed) emit(CashierDetailsState(status: CashierDetailsStatus.failure, cashier: cashier, failure: const UnknownFailure()));
    }
  }
}
