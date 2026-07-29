import 'package:maktabty/features/sales/data/models/sale_model.dart';
import 'package:maktabty/features/sales/data/models/today_sales_summary_model.dart';
import 'package:maktabty/features/sales/domain/entities/today_sales_response_entity.dart';

class TodaySalesResponseModel {
  final List<SaleModel> data;
  final TodaySalesSummaryModel summary;

  const TodaySalesResponseModel({
    required this.data,
    required this.summary,
  });

  factory TodaySalesResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<SaleModel> sales = const [];
    if (rawData is List) {
      sales = rawData
          .whereType<Map>()
          .map((item) => SaleModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } else if (rawData is List<Map<String, dynamic>>) {
      sales = rawData.map(SaleModel.fromJson).toList();
    }

    TodaySalesSummaryModel summary;
    final summaryData = json['summary'];
    if (summaryData is Map<String, dynamic>) {
      summary = TodaySalesSummaryModel.fromJson(summaryData);
    } else if (summaryData is Map) {
      summary = TodaySalesSummaryModel.fromJson(
        Map<String, dynamic>.from(summaryData),
      );
    } else {
      summary = const TodaySalesSummaryModel(totalAmount: 0, itemsCount: 0);
    }

    return TodaySalesResponseModel(
      data: sales,
      summary: summary,
    );
  }

  TodaySalesResponseEntity toEntity() {
    return TodaySalesResponseEntity(
      data: data.map((sale) => sale.toEntity()).toList(),
      summary: summary.toEntity(),
    );
  }
}

