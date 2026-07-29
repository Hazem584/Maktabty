import 'package:maktabty/core/network/data_parsing_exception.dart';
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
    const operation = 'parse products list';
    final rawData = requireList(json, 'data', operation: operation);
    final items = rawData
        .map(
          (item) => ProductModel.fromJson(
            requireStringMap(item, operation: operation, field: 'data[]'),
          ),
        )
        .toList(growable: false);

    final meta = json['meta'];
    int page = 1;
    int limit = 20;
    int total = items.length;

    if (meta is Map<String, dynamic>) {
      page = _toInt(meta['page'], fallback: page, operation: operation);
      limit = _toInt(meta['limit'], fallback: limit, operation: operation);
      total = _toInt(meta['total'], fallback: total, operation: operation);
    } else if (meta is Map) {
      final metaMap = Map<String, dynamic>.from(meta);
      page = _toInt(metaMap['page'], fallback: page, operation: operation);
      limit = _toInt(metaMap['limit'], fallback: limit, operation: operation);
      total = _toInt(metaMap['total'], fallback: total, operation: operation);
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

  static int _toInt(
    dynamic value, {
    required int fallback,
    required String operation,
  }) {
    if (value == null) return fallback;
    if (value is num) return value.toInt();
    final parsed = int.tryParse(value.toString());
    if (parsed != null) return parsed;
    throw DataParsingException(
      operation: operation,
      expected: 'integer or integer string',
      field: 'pagination metadata',
    );
  }
}
