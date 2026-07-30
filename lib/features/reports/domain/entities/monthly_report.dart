import 'package:equatable/equatable.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';

class DailyBreakdownEntity extends Equatable {
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

  @override
  List<Object?> get props => [date, amount, orders, sales];
}

class MonthlyReportEntity extends Equatable {
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

  @override
  List<Object?> get props => [
    month,
    totalSalesAmount,
    totalOrders,
    totalItemsSold,
    dailyBreakdown,
  ];
}
