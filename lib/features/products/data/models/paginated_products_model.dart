import 'package:maktabty/features/products/data/models/product_model.dart';
import 'package:maktabty/features/products/domain/entities/paginated_products_entity.dart';

class PaginatedProductsModel {
  final List<ProductModel> data;
  final int page;
  final int limit;
  final int total;

  const PaginatedProductsModel({
    required this.data,
    required this.page,
    required this.limit,
    required this.total,
  });

  factory PaginatedProductsModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final items = <ProductModel>[];
    if (rawData is List) {
      for (final item in rawData) {
        if (item is Map<String, dynamic>) {
          items.add(ProductModel.fromJson(item));
        } else if (item is Map) {
          items.add(ProductModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    final meta = json['meta'];
    int page = 1;
    int limit = 20;
    int total = items.length;

    if (meta is Map<String, dynamic>) {
      page = _toInt(meta['page'], fallback: page);
      limit = _toInt(meta['limit'], fallback: limit);
      total = _toInt(meta['total'], fallback: total);
    } else if (meta is Map) {
      final metaMap = Map<String, dynamic>.from(meta);
      page = _toInt(metaMap['page'], fallback: page);
      limit = _toInt(metaMap['limit'], fallback: limit);
      total = _toInt(metaMap['total'], fallback: total);
    }

    return PaginatedProductsModel(
      data: items,
      page: page,
      limit: limit,
      total: total,
    );
  }

  PaginatedProductsEntity toEntity() {
    return PaginatedProductsEntity(
      items: data.map((item) => item.toEntity()).toList(),
      page: page,
      limit: limit,
      total: total,
    );
  }

  static int _toInt(dynamic value, {required int fallback}) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
