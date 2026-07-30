import 'package:maktabty/features/sales/domain/entities/today_sales_response_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/utils/copy_with_sentinel.dart';

enum TodaySalesStatus { idle, loading, success, failure }

class TodaySalesState extends Equatable {
  final TodaySalesStatus status;
  final TodaySalesResponseEntity? response;
  final AppFailure? failure;

  const TodaySalesState({
    required this.status,
    required this.response,
    required this.failure,
  });

  factory TodaySalesState.initial() {
    return const TodaySalesState(
      status: TodaySalesStatus.idle,
      response: null,
      failure: null,
    );
  }

  TodaySalesState copyWith({
    TodaySalesStatus? status,
    Object? response = stateFieldUnchanged,
    Object? failure = stateFieldUnchanged,
  }) {
    return TodaySalesState(
      status: status ?? this.status,
      response: identical(response, stateFieldUnchanged)
          ? this.response
          : response as TodaySalesResponseEntity?,
      failure: identical(failure, stateFieldUnchanged)
          ? this.failure
          : failure as AppFailure?,
    );
  }

  @override
  List<Object?> get props => [status, response, failure];
}
