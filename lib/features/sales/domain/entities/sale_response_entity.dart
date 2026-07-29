import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';

class SaleResponseEntity {
  final SaleEntity sale;
  final ReceiptEntity receipt;

  const SaleResponseEntity({
    required this.sale,
    required this.receipt,
  });
}
