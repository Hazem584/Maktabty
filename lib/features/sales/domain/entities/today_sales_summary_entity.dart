import 'package:equatable/equatable.dart';

class TodaySalesSummaryEntity extends Equatable {
  final double totalAmount;
  final int itemsCount;

  const TodaySalesSummaryEntity({
    required this.totalAmount,
    required this.itemsCount,
  });

  @override
  List<Object?> get props => [totalAmount, itemsCount];
}
