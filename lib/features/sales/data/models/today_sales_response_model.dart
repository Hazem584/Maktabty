import 'package:maktabty/features/sales/data/models/sale_model.dart';
import 'package:maktabty/features/sales/data/models/today_sales_summary_model.dart';
import 'package:maktabty/features/sales/domain/entities/today_sales_response_entity.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class TodaySalesResponseModel {
  final List<SaleModel> data;
  final TodaySalesSummaryModel summary;

  const TodaySalesResponseModel({required this.data, required this.summary});

  factory TodaySalesResponseModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse today sales';
    final sales = requireList(json, 'data', operation: operation)
        .map(
          (item) => SaleModel.fromJson(
            requireStringMap(item, operation: operation, field: 'data[]'),
          ),
        )
        .toList(growable: false);
    final summary = TodaySalesSummaryModel.fromJson(
      requireStringMap(json['summary'], operation: operation, field: 'summary'),
    );

    return TodaySalesResponseModel(data: sales, summary: summary);
  }

  TodaySalesResponseEntity toEntity() {
    return TodaySalesResponseEntity(
      data: data.map((sale) => sale.toEntity()).toList(),
      summary: summary.toEntity(),
    );
  }
}
