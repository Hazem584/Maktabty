import 'package:maktabty/features/sales/domain/entities/today_sales_summary_entity.dart';

import 'package:maktabty/core/network/data_parsing_exception.dart';

class TodaySalesSummaryModel {
  final double totalAmount;
  final int itemsCount;

  const TodaySalesSummaryModel({
    required this.totalAmount,
    required this.itemsCount,
  });

  factory TodaySalesSummaryModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse today sales summary';
    return TodaySalesSummaryModel(
      totalAmount: requireDouble(json, const [
        'totalAmount',
        'total',
      ], operation: operation),
      itemsCount: requireInt(json, const [
        'itemsCount',
        'count',
      ], operation: operation),
    );
  }

  TodaySalesSummaryEntity toEntity() {
    return TodaySalesSummaryEntity(
      totalAmount: totalAmount,
      itemsCount: itemsCount,
    );
  }
}
