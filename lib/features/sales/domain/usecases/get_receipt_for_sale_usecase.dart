import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';
import 'package:maktabty/features/sales/domain/repositories/sales_repository.dart';

class GetReceiptForSaleUseCase {
  final SalesRepository _repository;

  const GetReceiptForSaleUseCase(this._repository);

  Future<ReceiptEntity> call(String saleId) {
    return _repository.getReceiptForSale(saleId);
  }
}
