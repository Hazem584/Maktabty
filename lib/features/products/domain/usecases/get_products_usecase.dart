import 'package:maktabty/features/products/domain/entities/paginated_products_entity.dart';
import 'package:maktabty/features/products/domain/repositories/products_repository.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';

class GetProductsUseCase {
  final ProductsRepository _repository;

  const GetProductsUseCase(this._repository);

  Future<PaginatedProductsEntity> call({
    String? search,
    bool? lowStock,
    ProductStatus status = ProductStatus.active,
    int page = 1,
    int limit = 20,
  }) {
    return _repository.getProducts(
      search: search,
      lowStock: lowStock,
      status: status,
      page: page,
      limit: limit,
    );
  }
}
