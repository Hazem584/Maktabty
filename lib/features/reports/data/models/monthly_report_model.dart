import 'package:maktabty/features/reports/domain/entities/monthly_report.dart';
import 'package:maktabty/features/sales/data/models/sale_model.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

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
    const operation = 'parse monthly report day';
    final sales = requireList(json, 'sales', operation: operation)
        .map(
          (item) => SaleModel.fromJson(
            requireStringMap(item, operation: operation, field: 'sales[]'),
          ),
        )
        .toList(growable: false);

    return DailyBreakdownModel(
      date: requireString(json, const ['date'], operation: operation),
      amount: requireDouble(json, const ['amount'], operation: operation),
      orders: requireInt(json, const [
        'orders',
        'totalOrders',
      ], operation: operation),
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
    const operation = 'parse monthly report';
    final breakdown = requireList(json, 'dailyBreakdown', operation: operation)
        .map(
          (item) => DailyBreakdownModel.fromJson(
            requireStringMap(
              item,
              operation: operation,
              field: 'dailyBreakdown[]',
            ),
          ),
        )
        .toList(growable: false);

    return MonthlyReportModel(
      month: requireString(json, const ['month'], operation: operation),
      totalSalesAmount: requireDouble(json, const [
        'totalSalesAmount',
      ], operation: operation),
      totalOrders: requireInt(json, const [
        'totalOrders',
      ], operation: operation),
      totalItemsSold: requireInt(json, const [
        'totalItemsSold',
      ], operation: operation),
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
}
