import 'package:maktabty/features/sales/domain/entities/today_sales_summary_entity.dart';

class TodaySalesSummaryModel {
  final double totalAmount;
  final int itemsCount;

  const TodaySalesSummaryModel({
    required this.totalAmount,
    required this.itemsCount,
  });

  factory TodaySalesSummaryModel.fromJson(Map<String, dynamic> json) {
    return TodaySalesSummaryModel(
      totalAmount: _toDouble(json['totalAmount'] ?? json['total']),
      itemsCount: _toInt(json['itemsCount'] ?? json['count']),
    );
  }

  TodaySalesSummaryEntity toEntity() {
    return TodaySalesSummaryEntity(
      totalAmount: totalAmount,
      itemsCount: itemsCount,
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

