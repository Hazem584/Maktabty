import 'package:maktabty/features/reports/domain/entities/monthly_report.dart';
import 'package:maktabty/features/sales/data/models/sale_model.dart';

class DailyBreakdownModel {
  final String date;
  final double amount;
  final int orders;
  final List<SaleModel> sales;

  const DailyBreakdownModel({
    required this.date,
    required this.amount,
    required this.orders,
    required this.sales,
  });

  factory DailyBreakdownModel.fromJson(Map<String, dynamic> json) {
    final rawSales = json['sales'];
    List<SaleModel> sales = const [];
    if (rawSales is List) {
      sales = rawSales
          .whereType<Map>()
          .map((item) => SaleModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } else if (rawSales is List<Map<String, dynamic>>) {
      sales = rawSales.map(SaleModel.fromJson).toList();
    }

    return DailyBreakdownModel(
      date: (json['date'] ?? '').toString(),
      amount: _toDouble(json['amount']),
      orders: _toInt(json['orders'] ?? json['totalOrders']),
      sales: sales,
    );
  }

  DailyBreakdownEntity toEntity() {
    return DailyBreakdownEntity(
      date: date,
      amount: amount,
      orders: orders,
      sales: sales.map((item) => item.toEntity()).toList(),
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

class MonthlyReportModel {
  final String month;
  final double totalSalesAmount;
  final int totalOrders;
  final int totalItemsSold;
  final List<DailyBreakdownModel> dailyBreakdown;

  const MonthlyReportModel({
    required this.month,
    required this.totalSalesAmount,
    required this.totalOrders,
    required this.totalItemsSold,
    required this.dailyBreakdown,
  });

  factory MonthlyReportModel.fromJson(Map<String, dynamic> json) {
    final rawDaily = json['dailyBreakdown'];
    List<DailyBreakdownModel> breakdown = const [];
    if (rawDaily is List) {
      breakdown = rawDaily
          .whereType<Map>()
          .map(
            (item) =>
                DailyBreakdownModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } else if (rawDaily is List<Map<String, dynamic>>) {
      breakdown = rawDaily.map(DailyBreakdownModel.fromJson).toList();
    }

    return MonthlyReportModel(
      month: (json['month'] ?? '').toString(),
      totalSalesAmount: _toDouble(json['totalSalesAmount']),
      totalOrders: _toInt(json['totalOrders']),
      totalItemsSold: _toInt(json['totalItemsSold']),
      dailyBreakdown: breakdown,
    );
  }

  MonthlyReportEntity toEntity() {
    return MonthlyReportEntity(
      month: month,
      totalSalesAmount: totalSalesAmount,
      totalOrders: totalOrders,
      totalItemsSold: totalItemsSold,
      dailyBreakdown: dailyBreakdown.map((item) => item.toEntity()).toList(),
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
