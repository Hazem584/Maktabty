import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/domain/repositories/products_repository.dart';

class DeleteProductUseCase {
  final ProductsRepository _repository;

  const DeleteProductUseCase(this._repository);

  Future<ProductEntity> call({required String id}) {
    return _repository.deleteProduct(id: id);
  }
}
