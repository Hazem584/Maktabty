import 'package:equatable/equatable.dart';

class ReceiptTotalsEntity extends Equatable {
  final double subtotal;
  final double discount;
  final double tax;
  final double total;

  const ReceiptTotalsEntity({
    required this.subtotal,
    this.discount = 0,
    this.tax = 0,
    required this.total,
  });

  @override
  List<Object?> get props => [subtotal, discount, tax, total];
}
