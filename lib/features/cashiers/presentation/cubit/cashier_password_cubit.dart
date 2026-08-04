import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/cashiers/domain/usecases/cashier_usecases.dart';

enum CashierPasswordStatus { initial, submitting, success, failure }

class CashierPasswordState extends Equatable {
  final CashierPasswordStatus status;
  final AppFailure? failure;
  const CashierPasswordState({required this.status, this.failure});
  factory CashierPasswordState.initial() => const CashierPasswordState(status: CashierPasswordStatus.initial);
  @override
  List<Object?> get props => [status, failure];
}

class CashierPasswordCubit extends Cubit<CashierPasswordState> {
  final CashierUseCases _useCases;
  CashierPasswordCubit(this._useCases) : super(CashierPasswordState.initial());

  Future<void> reset({required String cashierId, required String password}) async {
    if (state.status == CashierPasswordStatus.submitting) return;
    emit(const CashierPasswordState(status: CashierPasswordStatus.submitting));
    try {
      await _useCases.resetCashierPassword(id: cashierId, password: password);
      if (!isClosed) emit(const CashierPasswordState(status: CashierPasswordStatus.success));
    } on AppFailure catch (failure) {
      if (!isClosed) emit(CashierPasswordState(status: CashierPasswordStatus.failure, failure: failure));
    } catch (_) {
      if (!isClosed) emit(const CashierPasswordState(status: CashierPasswordStatus.failure, failure: UnknownFailure()));
    }
  }
}
