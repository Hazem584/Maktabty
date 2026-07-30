import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';
import 'package:equatable/equatable.dart';

class SaleResponseEntity extends Equatable {
  final SaleEntity sale;
  final ReceiptEntity receipt;

  const SaleResponseEntity({required this.sale, required this.receipt});

  @override
  List<Object?> get props => [sale, receipt];
}
