class TopProductEntity {
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
}

class DailyReportEntity {
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
}
