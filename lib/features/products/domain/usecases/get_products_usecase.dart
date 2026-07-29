import 'package:maktabty/features/products/domain/entities/paginated_products_entity.dart';
import 'package:maktabty/features/products/domain/repositories/products_repository.dart';

class GetProductsUseCase {
  final ProductsRepository _repository;

  const GetProductsUseCase(this._repository);

  Future<PaginatedProductsEntity> call({
    String? search,
    bool? lowStock,
    int page = 1,
    int limit = 20,
  }) {
    return _repository.getProducts(
      search: search,
      lowStock: lowStock,
      page: page,
      limit: limit,
    );
  }
}
