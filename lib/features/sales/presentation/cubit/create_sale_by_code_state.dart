import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_response_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/utils/copy_with_sentinel.dart';

enum CreateSaleByCodeStatus { idle, loading, success, failure }

class CreateSaleByCodeState extends Equatable {
  final CreateSaleByCodeStatus status;
  final SaleResponseEntity? response;
  final ReceiptEntity? lastReceipt;
  final PaymentMethod paymentMethod;
  final double? paidAmount;
  final double? cashAmount;
  final double? cardAmount;
  final AppFailure? failure;

  const CreateSaleByCodeState({
    required this.status,
    required this.response,
    required this.lastReceipt,
    required this.paymentMethod,
    required this.paidAmount,
    required this.cashAmount,
    required this.cardAmount,
    required this.failure,
  });

  factory CreateSaleByCodeState.initial() {
    return const CreateSaleByCodeState(
      status: CreateSaleByCodeStatus.idle,
      response: null,
      lastReceipt: null,
      paymentMethod: PaymentMethod.cash,
      paidAmount: null,
      cashAmount: null,
      cardAmount: null,
      failure: null,
    );
  }

  CreateSaleByCodeState copyWith({
    CreateSaleByCodeStatus? status,
    Object? response = stateFieldUnchanged,
    Object? lastReceipt = stateFieldUnchanged,
    PaymentMethod? paymentMethod,
    Object? paidAmount = stateFieldUnchanged,
    Object? cashAmount = stateFieldUnchanged,
    Object? cardAmount = stateFieldUnchanged,
    Object? failure = stateFieldUnchanged,
  }) {
    return CreateSaleByCodeState(
      status: status ?? this.status,
      response: identical(response, stateFieldUnchanged)
          ? this.response
          : response as SaleResponseEntity?,
      lastReceipt: identical(lastReceipt, stateFieldUnchanged)
          ? this.lastReceipt
          : lastReceipt as ReceiptEntity?,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paidAmount: identical(paidAmount, stateFieldUnchanged)
          ? this.paidAmount
          : paidAmount as double?,
      cashAmount: identical(cashAmount, stateFieldUnchanged)
          ? this.cashAmount
          : cashAmount as double?,
      cardAmount: identical(cardAmount, stateFieldUnchanged)
          ? this.cardAmount
          : cardAmount as double?,
      failure: identical(failure, stateFieldUnchanged)
          ? this.failure
          : failure as AppFailure?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    response,
    lastReceipt,
    paymentMethod,
    paidAmount,
    cashAmount,
    cardAmount,
    failure,
  ];
}
