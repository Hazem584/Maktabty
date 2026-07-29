import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/domain/repositories/products_repository.dart';

class GetProductByIdUseCase {
  final ProductsRepository _repository;

  const GetProductByIdUseCase(this._repository);

  Future<ProductEntity> call(String id) {
    return _repository.getProductById(id);
  }
}
