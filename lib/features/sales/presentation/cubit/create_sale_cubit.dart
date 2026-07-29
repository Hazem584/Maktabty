import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/network/api_exceptions.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_input.dart';
import 'package:maktabty/features/sales/domain/usecases/create_sale_usecase.dart';
import 'package:maktabty/features/sales/presentation/cubit/create_sale_state.dart';
import 'package:maktabty/features/sales/presentation/cubit/sales_error_mapper.dart';

class CreateSaleCubit extends Cubit<CreateSaleState> {
  final CreateSaleUseCase _createSaleUseCase;

  CreateSaleCubit({required CreateSaleUseCase createSaleUseCase})
      : _createSaleUseCase = createSaleUseCase,
        super(CreateSaleState.initial());

  void setPaymentMethod(PaymentMethod method) {
    emit(state.copyWith(
      paymentMethod: method,
      clearAmounts: true,
    ));
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

  Future<void> submit({required List<SaleItemInput> items}) async {
    if (state.status == CreateSaleStatus.loading) return;
    emit(state.copyWith(status: CreateSaleStatus.loading, message: null));

    try {
      final response = await _createSaleUseCase(
        items: items,
        paymentMethod: state.paymentMethod,
        paidAmount: state.paidAmount,
        cashAmount: state.cashAmount,
        cardAmount: state.cardAmount,
      );
      emit(state.copyWith(
        status: CreateSaleStatus.success,
        response: response,
        lastReceipt: response.receipt,
      ));
    } on ApiException catch (error) {
      emit(state.copyWith(
        status: CreateSaleStatus.failure,
        message: mapSalesError(error),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: CreateSaleStatus.failure,
        message: 'Something went wrong. Please try again.',
      ));
    }
  }

  void reset() {
    emit(CreateSaleState.initial());
  }
}
