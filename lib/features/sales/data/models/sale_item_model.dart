import 'package:maktabty/features/sales/data/models/product_mini_model.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_entity.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class SaleItemModel {
  final ProductMiniModel? product;
  final int quantity;
  final double unitPrice;
  final double lineTotal;

  const SaleItemModel({
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  });

  factory SaleItemModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse sale item';
    final productData = json['product'];
    ProductMiniModel? product;
    if (productData is Map<String, dynamic>) {
      product = ProductMiniModel.fromJson(productData);
    } else if (productData is Map) {
      product = ProductMiniModel.fromJson(
        Map<String, dynamic>.from(productData),
      );
    } else {
      final fallback = <String, dynamic>{
        'id': json['productId'] ?? '',
        'name': json['productName'] ?? json['name'] ?? '',
        'code': json['productCode'] ?? json['code'],
      };
      if (fallback['id'].toString().isNotEmpty ||
          fallback['name'].toString().isNotEmpty) {
        product = ProductMiniModel.fromJson(fallback);
      }
    }

    final quantity = requireInt(json, const ['quantity'], operation: operation);
    final unitPrice = requireDouble(json, const [
      'unitPrice',
      'price',
    ], operation: operation);
    final lineTotal = requireDouble(json, const [
      'lineTotal',
      'total',
    ], operation: operation);

    return SaleItemModel(
      product: product,
      quantity: quantity,
      unitPrice: unitPrice,
      lineTotal: lineTotal,
    );
  }

  SaleItemEntity toEntity() {
    return SaleItemEntity(
      product: product?.toEntity(),
      quantity: quantity,
      unitPrice: unitPrice,
      lineTotal: lineTotal,
    );
  }
}
