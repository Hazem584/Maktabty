import 'package:equatable/equatable.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';

class ReceiptPaymentEntity extends Equatable {
  final PaymentMethod method;
  final double? paidAmount;
  final double? cashAmount;
  final double? cardAmount;
  final double? changeAmount;

  const ReceiptPaymentEntity({
    required this.method,
    this.paidAmount,
    this.cashAmount,
    this.cardAmount,
    this.changeAmount,
  });

  @override
  List<Object?> get props => [
    method,
    paidAmount,
    cashAmount,
    cardAmount,
    changeAmount,
  ];
}
