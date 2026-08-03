import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/network/app_failure_mapper.dart';
import 'package:maktabty/features/products/data/datasources/products_remote_datasource.dart';
import 'package:maktabty/features/products/data/datasources/products_local_datasource.dart';
import 'package:maktabty/features/products/domain/entities/paginated_products_entity.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remoteDataSource;
  final ProductsLocalDataSource _localDataSource;

  ProductsRepositoryImpl({
    required this._remoteDataSource,
    required this._localDataSource,
  });

  @override
  Future<PaginatedProductsEntity> getProducts({
    String? search,
    bool? lowStock,
    ProductStatus status = ProductStatus.active,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _remoteDataSource.getProducts(
        search: search,
        lowStock: lowStock,
        status: status,
        page: page,
        limit: limit,
      );
      final entity = response.toEntity();
      await _localDataSource.cacheProducts(
        entity.items,
        reconcileActiveCatalog:
            status == ProductStatus.active &&
            page == 1 &&
            search == null &&
            lowStock != true &&
            entity.items.length == entity.total,
      );
      return entity;
    } catch (error) {
      try {
        final cached = await _localDataSource.getProducts(
          search: search,
          lowStock: lowStock,
          status: status,
          page: page,
          limit: limit,
        );
        if (cached.items.isNotEmpty) return cached;
      } catch (localError) {
        throw AppFailureMapper.fromException(localError);
      }
      throw AppFailureMapper.fromException(error);
    }
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    try {
      final product = await _remoteDataSource.getProductById(id);
      final entity = product.toEntity();
      await _localDataSource.cacheProducts(
        [entity],
        reconcileActiveCatalog: false,
      );
      return entity;
    } catch (error) {
      try {
        final cached = await _localDataSource.getProductById(id);
        if (cached != null) return cached;
      } catch (localError) {
        throw AppFailureMapper.fromException(localError);
      }
      throw AppFailureMapper.fromException(error);
    }
  }

  @override
  Future<ProductEntity> getProductByCode(String code) async {
    try {
      final product = await _remoteDataSource.getProductByCode(code);
      final entity = product.toEntity();
      await _localDataSource.cacheProducts(
        [entity],
        reconcileActiveCatalog: false,
      );
      if (!entity.isActive) throw const ArchivedProductFailure();
      return entity;
    } catch (error) {
      try {
        final cached = await _localDataSource.getProductByCode(code);
        if (cached != null) return cached;
      } catch (localError) {
        throw AppFailureMapper.fromException(localError);
      }
      throw AppFailureMapper.fromException(error);
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
      final entity = product.toEntity();
      await _localDataSource.cacheProducts(
        [entity],
        reconcileActiveCatalog: false,
      );
      return entity;
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }

  @override
  Future<ProductEntity> updateProduct({
    required String id,
    String? name,
    double? price,
    int? stock,
    String? code,
    String? adjustmentReason,
  }) async {
    try {
      final product = await _remoteDataSource.updateProduct(
        id: id,
        name: name,
        price: price,
        stock: stock,
        code: code,
        adjustmentReason: adjustmentReason,
      );
      final entity = product.toEntity();
      await _localDataSource.cacheProducts(
        [entity],
        reconcileActiveCatalog: false,
      );
      return entity;
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }

  @override
  Future<ProductEntity> deleteProduct({required String id}) async {
    try {
      final product = await _remoteDataSource.deleteProduct(id);
      final entity = product.toEntity();
      await _localDataSource.removeProduct(id);
      return entity;
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }

  @override
  Future<ProductEntity> archiveProduct(ArchiveProductInput input) async {
    try {
      final model = await _remoteDataSource.archiveProduct(input);
      final entity = model.toEntity();
      await _localDataSource.cacheProducts(
        [entity],
        reconcileActiveCatalog: false,
      );
      return entity;
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }

  @override
  Future<ProductEntity> restoreProduct({required String id}) async {
    try {
      final model = await _remoteDataSource.restoreProduct(id);
      final entity = model.toEntity();
      await _localDataSource.cacheProducts(
        [entity],
        reconcileActiveCatalog: false,
      );
      return entity;
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }
}
