import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/domain/repositories/products_repository.dart';

class CreateProductUseCase {
  final ProductsRepository _repository;

  const CreateProductUseCase(this._repository);

  Future<ProductEntity> call({
    required String name,
    required double price,
    required int stock,
    String? code,
  }) {
    return _repository.createProduct(
      name: name,
      price: price,
      stock: stock,
      code: code,
    );
  }
}
