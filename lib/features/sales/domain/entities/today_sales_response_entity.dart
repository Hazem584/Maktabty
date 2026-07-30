import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';
import 'package:maktabty/features/sales/domain/entities/today_sales_summary_entity.dart';
import 'package:equatable/equatable.dart';

class TodaySalesResponseEntity extends Equatable {
  final List<SaleEntity> data;
  final TodaySalesSummaryEntity summary;

  const TodaySalesResponseEntity({required this.data, required this.summary});

  @override
  List<Object?> get props => [data, summary];
}
