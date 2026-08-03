import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/domain/repositories/products_repository.dart';

class RestoreProductUseCase {
  final ProductsRepository _repository;
  const RestoreProductUseCase(this._repository);

  Future<ProductEntity> call({required String id}) {
    return _repository.restoreProduct(id: id);
  }
}
