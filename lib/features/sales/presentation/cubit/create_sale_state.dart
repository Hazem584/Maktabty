import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_response_entity.dart';

enum CreateSaleStatus { idle, loading, success, failure }

class CreateSaleState {
  final CreateSaleStatus status;
  final SaleResponseEntity? response;
  final ReceiptEntity? lastReceipt;
  final PaymentMethod paymentMethod;
  final double? paidAmount;
  final double? cashAmount;
  final double? cardAmount;
  final String? message;

  const CreateSaleState({
    required this.status,
    required this.response,
    required this.lastReceipt,
    required this.paymentMethod,
    required this.paidAmount,
    required this.cashAmount,
    required this.cardAmount,
    required this.message,
  });

  factory CreateSaleState.initial() {
    return const CreateSaleState(
      status: CreateSaleStatus.idle,
      response: null,
      lastReceipt: null,
      paymentMethod: PaymentMethod.cash,
      paidAmount: null,
      cashAmount: null,
      cardAmount: null,
      message: null,
    );
  }

  CreateSaleState copyWith({
    CreateSaleStatus? status,
    SaleResponseEntity? response,
    ReceiptEntity? lastReceipt,
    PaymentMethod? paymentMethod,
    double? paidAmount,
    double? cashAmount,
    double? cardAmount,
    String? message,
    bool clearAmounts = false,
  }) {
    return CreateSaleState(
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
