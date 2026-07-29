import 'package:maktabty/core/utils/text_sanitizer.dart';
import 'package:maktabty/features/reports/domain/entities/daily_report.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class TopProductModel {
  final String productId;
  final String name;
  final int quantitySold;
  final double amount;

  const TopProductModel({
    required this.productId,
    required this.name,
    required this.quantitySold,
    required this.amount,
  });

  factory TopProductModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse top product report row';
    return TopProductModel(
      productId: requireString(json, const ['productId'], operation: operation),
      name: TextSanitizer.fixMojibake(
        requireString(json, const ['name'], operation: operation),
      ),
      quantitySold: requireInt(json, const [
        'quantitySold',
        'quantity',
      ], operation: operation),
      amount: requireDouble(json, const ['amount'], operation: operation),
    );
  }

  TopProductEntity toEntity() {
    return TopProductEntity(
      productId: productId,
      name: name,
      quantitySold: quantitySold,
      amount: amount,
    );
  }
}

class DailyReportModel {
  final String date;
  final double totalSalesAmount;
  final int totalOrders;
  final int totalItemsSold;
  final List<TopProductModel> topProducts;

  const DailyReportModel({
    required this.date,
    required this.totalSalesAmount,
    required this.totalOrders,
    required this.totalItemsSold,
    required this.topProducts,
  });

  factory DailyReportModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse daily report';
    final topProducts = requireList(json, 'topProducts', operation: operation)
        .map(
          (item) => TopProductModel.fromJson(
            requireStringMap(
              item,
              operation: operation,
              field: 'topProducts[]',
            ),
          ),
        )
        .toList(growable: false);

    return DailyReportModel(
      date: requireString(json, const ['date'], operation: operation),
      totalSalesAmount: requireDouble(json, const [
        'totalSalesAmount',
      ], operation: operation),
      totalOrders: requireInt(json, const [
        'totalOrders',
      ], operation: operation),
      totalItemsSold: requireInt(json, const [
        'totalItemsSold',
      ], operation: operation),
      topProducts: topProducts,
    );
  }

  DailyReportEntity toEntity() {
    return DailyReportEntity(
      date: date,
      totalSalesAmount: totalSalesAmount,
      totalOrders: totalOrders,
      totalItemsSold: totalItemsSold,
      topProducts: topProducts.map((item) => item.toEntity()).toList(),
    );
  }
}
