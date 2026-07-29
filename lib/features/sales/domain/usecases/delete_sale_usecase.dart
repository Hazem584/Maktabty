import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';
import 'package:maktabty/features/sales/domain/repositories/sales_repository.dart';

class DeleteSaleUseCase {
  final SalesRepository _repository;

  const DeleteSaleUseCase(this._repository);

  Future<SaleEntity> call({required String id}) {
    return _repository.deleteSale(id: id);
  }
}
