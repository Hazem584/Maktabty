import 'package:maktabty/features/sales/domain/entities/today_sales_response_entity.dart';
import 'package:maktabty/features/sales/domain/repositories/sales_repository.dart';

class GetTodaySalesUseCase {
  final SalesRepository _repository;

  const GetTodaySalesUseCase(this._repository);

  Future<TodaySalesResponseEntity> call({String? date}) {
    return _repository.getTodaySales(date: date);
  }
}
