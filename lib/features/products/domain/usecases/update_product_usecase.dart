import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/domain/repositories/products_repository.dart';

class UpdateProductUseCase {
  final ProductsRepository _repository;

  const UpdateProductUseCase(this._repository);

  Future<ProductEntity> call({
    required String id,
    String? name,
    double? price,
    int? stock,
    String? code,
    String? adjustmentReason,
  }) {
    return _repository.updateProduct(
      id: id,
      name: name,
      price: price,
      stock: stock,
      code: code,
      adjustmentReason: adjustmentReason,
    );
  }
}
