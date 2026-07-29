import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/network/api_exceptions.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/usecases/create_sale_by_code_usecase.dart';
import 'package:maktabty/features/sales/presentation/cubit/create_sale_by_code_state.dart';
import 'package:maktabty/features/sales/presentation/cubit/sales_error_mapper.dart';

class CreateSaleByCodeCubit extends Cubit<CreateSaleByCodeState> {
  final CreateSaleByCodeUseCase _createSaleByCodeUseCase;

  CreateSaleByCodeCubit({
    required CreateSaleByCodeUseCase createSaleByCodeUseCase,
  }) : _createSaleByCodeUseCase = createSaleByCodeUseCase,
       super(CreateSaleByCodeState.initial());

  void setPaymentMethod(PaymentMethod method) {
    emit(state.copyWith(paymentMethod: method, clearAmounts: true));
  }

  void setPaidAmount(double? value) {
    emit(state.copyWith(paidAmount: value));
  }

  void setCashAmount(double? value) {
    emit(state.copyWith(cashAmount: value));
  }

  void setCardAmount(double? value) {
    emit(state.copyWith(cardAmount: value));
  }

  Future<void> submit({
    required String code,
    required int quantity,
    double? unitPriceOverride,
  }) async {
    if (state.status == CreateSaleByCodeStatus.loading) return;
    emit(state.copyWith(status: CreateSaleByCodeStatus.loading, message: null));

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
      emit(
        state.copyWith(
          status: CreateSaleByCodeStatus.success,
          response: response,
          lastReceipt: response.receipt,
        ),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: CreateSaleByCodeStatus.failure,
          message: mapSalesError(error),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CreateSaleByCodeStatus.failure,
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  void reset() {
    emit(CreateSaleByCodeState.initial());
  }
}
