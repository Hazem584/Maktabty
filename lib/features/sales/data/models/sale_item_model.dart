import 'package:maktabty/features/sales/data/models/product_mini_model.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_entity.dart';

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
    final productData = json['product'];
    ProductMiniModel? product;
    if (productData is Map<String, dynamic>) {
      product = ProductMiniModel.fromJson(productData);
    } else if (productData is Map) {
      product = ProductMiniModel.fromJson(Map<String, dynamic>.from(productData));
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

    final quantity = _toInt(json['quantity']);
    final unitPrice = _toDouble(json['unitPrice'] ?? json['price']);
    final lineTotalRaw = _toDouble(json['lineTotal'] ?? json['total']);

    return SaleItemModel(
      product: product,
      quantity: quantity,
      unitPrice: unitPrice,
      lineTotal:
          lineTotalRaw == 0 && quantity > 0 ? unitPrice * quantity : lineTotalRaw,
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

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

