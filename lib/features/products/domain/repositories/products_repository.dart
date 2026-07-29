import 'package:maktabty/features/products/domain/entities/paginated_products_entity.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';

abstract class ProductsRepository {
  Future<PaginatedProductsEntity> getProducts({
    String? search,
    bool? lowStock,
    int page = 1,
    int limit = 20,
  });

  Future<ProductEntity> getProductById(String id);

  Future<ProductEntity> getProductByCode(String code);

  Future<ProductEntity> createProduct({
    required String name,
    required double price,
    required int stock,
    String? code,
  });

  Future<ProductEntity> updateProduct({
    required String id,
    String? name,
    double? price,
    int? stock,
    String? code,
  });

  Future<ProductEntity> deleteProduct({required String id});
}
