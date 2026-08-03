import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/domain/repositories/products_repository.dart';

class ArchiveProductUseCase {
  final ProductsRepository _repository;
  const ArchiveProductUseCase(this._repository);

  Future<ProductEntity> call(ArchiveProductInput input) {
    return _repository.archiveProduct(input);
  }
}
