import 'package:dio/dio.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';
import 'package:maktabty/features/products/data/models/paginated_products_model.dart';
import 'package:maktabty/features/products/data/models/product_model.dart';

class ProductsRemoteDataSource {
  final Dio _dio;

  ProductsRemoteDataSource(this._dio);

  Future<PaginatedProductsModel> getProducts({
    String? search,
    bool? lowStock,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      '/products',
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        'lowStock': ?lowStock,
        'page': page,
        'limit': limit,
      },
    );

    return PaginatedProductsModel.fromJson(
      requireStringMap(response.data, operation: 'GET /products'),
    );
  }

  Future<ProductModel> getProductById(String id) async {
    final response = await _dio.get('/products/$id');
    return _parseProduct(response.data);
  }

  Future<ProductModel> getProductByCode(String code) async {
    final encoded = Uri.encodeComponent(code);
    final response = await _dio.get('/products/by-code/$encoded');
    return _parseProduct(response.data);
  }

  Future<ProductModel> createProduct({
    required String name,
    required double price,
    required int stock,
    String? code,
  }) async {
    final response = await _dio.post(
      '/products',
      data: {
        'name': name,
        'price': price,
        'stock': stock,
        if (code != null && code.isNotEmpty) 'code': code,
      },
    );
    return _parseProduct(response.data);
  }

  Future<ProductModel> updateProduct({
    required String id,
    String? name,
    double? price,
    int? stock,
    String? code,
    String? adjustmentReason,
  }) async {
    final response = await _dio.patch(
      '/products/$id',
      data: {
        'name': ?name,
        'price': ?price,
        'stock': ?stock,
        'code': ?code,
        if (stock != null) 'adjustmentReason': adjustmentReason,
      },
    );
    return _parseProduct(response.data);
  }

  Future<ProductModel> deleteProduct(String id) async {
    final response = await _dio.delete('/products/$id');
    return _parseProduct(response.data);
  }

  ProductModel _parseProduct(dynamic data) {
    return ProductModel.fromJson(
      requireStringMap(data, operation: 'parse product response'),
    );
  }
}
