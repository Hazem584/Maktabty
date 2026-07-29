import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';

class DailyBreakdownEntity {
  final String date;
  final double amount;
  final int orders;
  final List<SaleEntity> sales;

  const DailyBreakdownEntity({
    required this.date,
    required this.amount,
    required this.orders,
    required this.sales,
  });
}

class MonthlyReportEntity {
  final String month;
  final double totalSalesAmount;
  final int totalOrders;
  final int totalItemsSold;
  final List<DailyBreakdownEntity> dailyBreakdown;

  const MonthlyReportEntity({
    required this.month,
    required this.totalSalesAmount,
    required this.totalOrders,
    required this.totalItemsSold,
    required this.dailyBreakdown,
  });
}
