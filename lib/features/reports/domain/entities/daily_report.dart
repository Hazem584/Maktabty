import 'package:equatable/equatable.dart';

class TopProductEntity extends Equatable {
  final String productId;
  final String name;
  final int quantitySold;
  final double amount;

  const TopProductEntity({
    required this.productId,
    required this.name,
    required this.quantitySold,
    required this.amount,
  });

  @override
  List<Object?> get props => [productId, name, quantitySold, amount];
}

class DailyReportEntity extends Equatable {
  final String date;
  final double totalSalesAmount;
  final int totalOrders;
  final int totalItemsSold;
  final List<TopProductEntity> topProducts;

  const DailyReportEntity({
    required this.date,
    required this.totalSalesAmount,
    required this.totalOrders,
    required this.totalItemsSold,
    required this.topProducts,
  });

  @override
  List<Object?> get props => [
    date,
    totalSalesAmount,
    totalOrders,
    totalItemsSold,
    topProducts,
  ];
}
