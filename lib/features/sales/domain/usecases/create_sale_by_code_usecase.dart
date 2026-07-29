import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/sale_response_entity.dart';
import 'package:maktabty/features/sales/domain/repositories/sales_repository.dart';

class CreateSaleByCodeUseCase {
  final SalesRepository _repository;

  const CreateSaleByCodeUseCase(this._repository);

  Future<SaleResponseEntity> call({
    required String code,
    required int quantity,
    required PaymentMethod paymentMethod,
    double? unitPriceOverride,
    double? paidAmount,
    double? cashAmount,
    double? cardAmount,
  }) {
    return _repository.createSaleByCode(
      code: code,
      quantity: quantity,
      paymentMethod: paymentMethod,
      unitPriceOverride: unitPriceOverride,
      paidAmount: paidAmount,
      cashAmount: cashAmount,
      cardAmount: cardAmount,
    );
  }
}
