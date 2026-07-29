import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/domain/repositories/products_repository.dart';

class GetProductByCodeUseCase {
  final ProductsRepository _repository;

  const GetProductByCodeUseCase(this._repository);

  Future<ProductEntity> call(String code) {
    return _repository.getProductByCode(code);
  }
}
