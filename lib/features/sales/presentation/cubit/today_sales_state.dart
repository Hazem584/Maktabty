import 'package:maktabty/features/sales/domain/entities/today_sales_response_entity.dart';

enum TodaySalesStatus { idle, loading, success, failure }

class TodaySalesState {
  final TodaySalesStatus status;
  final TodaySalesResponseEntity? response;
  final String? message;

  const TodaySalesState({
    required this.status,
    required this.response,
    required this.message,
  });

  factory TodaySalesState.initial() {
    return const TodaySalesState(
      status: TodaySalesStatus.idle,
      response: null,
      message: null,
    );
  }

  TodaySalesState copyWith({
    TodaySalesStatus? status,
    TodaySalesResponseEntity? response,
    String? message,
  }) {
    return TodaySalesState(
      status: status ?? this.status,
      response: response ?? this.response,
      message: message,
    );
  }
}
