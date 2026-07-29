import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_response_entity.dart';

enum CreateSaleByCodeStatus { idle, loading, success, failure }

class CreateSaleByCodeState {
  final CreateSaleByCodeStatus status;
  final SaleResponseEntity? response;
  final ReceiptEntity? lastReceipt;
  final PaymentMethod paymentMethod;
  final double? paidAmount;
  final double? cashAmount;
  final double? cardAmount;
  final String? message;

  const CreateSaleByCodeState({
    required this.status,
    required this.response,
    required this.lastReceipt,
    required this.paymentMethod,
    required this.paidAmount,
    required this.cashAmount,
    required this.cardAmount,
    required this.message,
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
      message: null,
    );
  }

  CreateSaleByCodeState copyWith({
    CreateSaleByCodeStatus? status,
    SaleResponseEntity? response,
    ReceiptEntity? lastReceipt,
    PaymentMethod? paymentMethod,
    double? paidAmount,
    double? cashAmount,
    double? cardAmount,
    String? message,
    bool clearAmounts = false,
  }) {
    return CreateSaleByCodeState(
      status: status ?? this.status,
      response: response ?? this.response,
      lastReceipt: lastReceipt ?? this.lastReceipt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paidAmount: clearAmounts ? null : (paidAmount ?? this.paidAmount),
      cashAmount: clearAmounts ? null : (cashAmount ?? this.cashAmount),
      cardAmount: clearAmounts ? null : (cardAmount ?? this.cardAmount),
      message: message,
    );
  }
}
