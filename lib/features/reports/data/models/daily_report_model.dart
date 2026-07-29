import 'package:maktabty/core/utils/text_sanitizer.dart';
import 'package:maktabty/features/reports/domain/entities/daily_report.dart';

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
    return TopProductModel(
      productId: (json['productId'] ?? '').toString(),
      name: TextSanitizer.fixMojibake((json['name'] ?? '').toString()),
      quantitySold: _toInt(json['quantitySold'] ?? json['quantity']),
      amount: _toDouble(json['amount']),
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

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
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
    final rawTop = json['topProducts'];
    List<TopProductModel> topProducts = const [];
    if (rawTop is List) {
      topProducts = rawTop
          .whereType<Map>()
          .map((item) => TopProductModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } else if (rawTop is List<Map<String, dynamic>>) {
      topProducts = rawTop.map(TopProductModel.fromJson).toList();
    }

    return DailyReportModel(
      date: (json['date'] ?? '').toString(),
      totalSalesAmount: _toDouble(json['totalSalesAmount']),
      totalOrders: _toInt(json['totalOrders']),
      totalItemsSold: _toInt(json['totalItemsSold']),
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

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
