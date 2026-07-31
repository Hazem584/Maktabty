import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_input.dart';
import 'package:maktabty/features/sales/domain/usecases/create_sale_usecase.dart';
import 'package:maktabty/features/sales/domain/validation/sale_validator.dart';
import 'package:maktabty/features/sales/presentation/cubit/create_sale_state.dart';

class CreateSaleCubit extends Cubit<CreateSaleState> {
  final CreateSaleUseCase _createSaleUseCase;

  CreateSaleCubit({required CreateSaleUseCase createSaleUseCase})
    : _createSaleUseCase = createSaleUseCase,
      super(CreateSaleState.initial());

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

  Future<void> submit({required List<SaleItemInput> items}) async {
    if (isClosed || state.status == CreateSaleStatus.loading) return;
    final validationError = SaleValidator.validateItems(items);
    if (validationError != null) {
      emit(
        state.copyWith(
          status: CreateSaleStatus.failure,
          response: null,
          lastReceipt: null,
          failure: ValidationFailure(validationKey: validationError),
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
          status: CreateSaleStatus.failure,
          response: null,
          lastReceipt: null,
          failure: ValidationFailure(validationKey: paymentError),
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: CreateSaleStatus.loading,
        response: null,
        lastReceipt: null,
        failure: null,
      ),
    );

    try {
      final response = await _createSaleUseCase(
        items: items,
        paymentMethod: state.paymentMethod,
        paidAmount: state.paidAmount,
        cashAmount: state.cashAmount,
        cardAmount: state.cardAmount,
      );
      if (!isClosed) {
        emit(
          state.copyWith(
            status: CreateSaleStatus.success,
            response: response,
            lastReceipt: response.isServerConfirmed ? response.receipt : null,
            failure: null,
          ),
        );
      }
    } on AppFailure catch (failure) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: CreateSaleStatus.failure,
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
            status: CreateSaleStatus.failure,
            response: null,
            lastReceipt: null,
            failure: const UnknownFailure(),
          ),
        );
      }
    }
  }

  void reset() {
    if (!isClosed) emit(CreateSaleState.initial());
  }
}
