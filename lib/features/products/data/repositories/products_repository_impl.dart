import 'package:dio/dio.dart';
import 'package:maktabty/core/network/api_exceptions.dart';
import 'package:maktabty/features/products/data/datasources/products_remote_datasource.dart';
import 'package:maktabty/features/products/domain/entities/paginated_products_entity.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remoteDataSource;

  ProductsRepositoryImpl({required ProductsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<PaginatedProductsEntity> getProducts({
    String? search,
    bool? lowStock,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _remoteDataSource.getProducts(
        search: search,
        lowStock: lowStock,
        page: page,
        limit: limit,
      );
      return response.toEntity();
    } on DioException catch (error) {
      throw ApiExceptions.fromDio(error);
    }
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    try {
      final product = await _remoteDataSource.getProductById(id);
      return product.toEntity();
    } on DioException catch (error) {
      throw ApiExceptions.fromDio(error);
    }
  }

  @override
  Future<ProductEntity> getProductByCode(String code) async {
    try {
      final product = await _remoteDataSource.getProductByCode(code);
      return product.toEntity();
    } on DioException catch (error) {
      throw ApiExceptions.fromDio(error);
    }
  }

  @override
  Future<ProductEntity> createProduct({
    required String name,
    required double price,
    required int stock,
    String? code,
  }) async {
    try {
      final product = await _remoteDataSource.createProduct(
        name: name,
        price: price,
        stock: stock,
        code: code,
      );
      return product.toEntity();
    } on DioException catch (error) {
      throw ApiExceptions.fromDio(error);
    }
  }

  @override
  Future<ProductEntity> updateProduct({
    required String id,
    String? name,
    double? price,
    int? stock,
    String? code,
  }) async {
    try {
      final product = await _remoteDataSource.updateProduct(
        id: id,
        name: name,
        price: price,
        stock: stock,
        code: code,
      );
      return product.toEntity();
    } on DioException catch (error) {
      throw ApiExceptions.fromDio(error);
    }
  }

  @override
  Future<ProductEntity> deleteProduct({required String id}) async {
    try {
      final product = await _remoteDataSource.deleteProduct(id);
      return product.toEntity();
    } on DioException catch (error) {
      throw ApiExceptions.fromDio(error);
    }
  }
}
