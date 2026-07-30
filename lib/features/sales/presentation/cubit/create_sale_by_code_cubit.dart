import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/validation/validation_result.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/usecases/create_sale_by_code_usecase.dart';
import 'package:maktabty/features/sales/domain/validation/sale_validator.dart';
import 'package:maktabty/features/sales/presentation/cubit/create_sale_by_code_state.dart';

class CreateSaleByCodeCubit extends Cubit<CreateSaleByCodeState> {
  final CreateSaleByCodeUseCase _createSaleByCodeUseCase;

  CreateSaleByCodeCubit({
    required CreateSaleByCodeUseCase createSaleByCodeUseCase,
  }) : _createSaleByCodeUseCase = createSaleByCodeUseCase,
       super(CreateSaleByCodeState.initial());

  void setPaymentMethod(PaymentMethod method) {
    if (isClosed) return;
    emit(
      state.copyWith(
        paymentMethod: method,
        paidAmount: null,
        cashAmount: null,
        cardAmount: null,
        failure: null,
      ),
    );
  }

  void setPaidAmount(double? value) {
    if (!isClosed) emit(state.copyWith(paidAmount: value));
  }

  void setCashAmount(double? value) {
    if (!isClosed) emit(state.copyWith(cashAmount: value));
  }

  void setCardAmount(double? value) {
    if (!isClosed) emit(state.copyWith(cardAmount: value));
  }

  Future<void> submit({
    required String code,
    required int quantity,
    double? unitPriceOverride,
  }) async {
    if (isClosed || state.status == CreateSaleByCodeStatus.loading) return;
    if (code.trim().isEmpty) {
      emit(
        state.copyWith(
          status: CreateSaleByCodeStatus.failure,
          response: null,
          lastReceipt: null,
          failure: const ValidationFailure(
            validationKey: ValidationKey.invalidCode,
          ),
        ),
      );
      return;
    }
    if (quantity <= 0) {
      emit(
        state.copyWith(
          status: CreateSaleByCodeStatus.failure,
          response: null,
          lastReceipt: null,
          failure: const ValidationFailure(
            validationKey: ValidationKey.invalidQuantity,
          ),
        ),
      );
      return;
    }
    if (unitPriceOverride != null &&
        (!unitPriceOverride.isFinite || unitPriceOverride <= 0)) {
      emit(
        state.copyWith(
          status: CreateSaleByCodeStatus.failure,
          response: null,
          lastReceipt: null,
          failure: const ValidationFailure(
            validationKey: ValidationKey.invalidUnitPrice,
          ),
        ),
      );
      return;
    }
    final paymentError = SaleValidator.validatePayment(
      method: state.paymentMethod,
      total: null,
      paidAmount: state.paidAmount,
      cashAmount: state.cashAmount,
      cardAmount: state.cardAmount,
    );
    if (paymentError != null) {
      emit(
        state.copyWith(
          status: CreateSaleByCodeStatus.failure,
          response: null,
          lastReceipt: null,
          failure: ValidationFailure(validationKey: paymentError),
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: CreateSaleByCodeStatus.loading,
        response: null,
        lastReceipt: null,
        failure: null,
      ),
    );

    try {
      final response = await _createSaleByCodeUseCase(
        code: code,
        quantity: quantity,
        unitPriceOverride: unitPriceOverride,
        paymentMethod: state.paymentMethod,
        paidAmount: state.paidAmount,
        cashAmount: state.cashAmount,
        cardAmount: state.cardAmount,
      );
      if (!isClosed) {
        emit(
          state.copyWith(
            status: CreateSaleByCodeStatus.success,
            response: response,
            lastReceipt: response.receipt,
            failure: null,
          ),
        );
      }
    } on AppFailure catch (failure) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: CreateSaleByCodeStatus.failure,
            response: null,
            lastReceipt: null,
            failure: failure,
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: CreateSaleByCodeStatus.failure,
            response: null,
            lastReceipt: null,
            failure: const UnknownFailure(),
          ),
        );
      }
    }
  }

  void reset() {
    if (!isClosed) emit(CreateSaleByCodeState.initial());
  }
}
