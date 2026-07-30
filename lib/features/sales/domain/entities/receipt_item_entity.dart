import 'package:equatable/equatable.dart';

class ReceiptItemEntity extends Equatable {
  final String productId;
  final String name;
  final String? code;
  final int qty;
  final double unitPrice;
  final double lineTotal;

  const ReceiptItemEntity({
    required this.productId,
    required this.name,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
    this.code,
  });

  @override
  List<Object?> get props => [productId, name, code, qty, unitPrice, lineTotal];
}
