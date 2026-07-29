import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_input.dart';
import 'package:maktabty/features/sales/domain/entities/sale_response_entity.dart';
import 'package:maktabty/features/sales/domain/repositories/sales_repository.dart';

class CreateSaleWithPaymentUseCase {
  final SalesRepository _repository;

  const CreateSaleWithPaymentUseCase(this._repository);

  Future<SaleResponseEntity> call({
    required List<SaleItemInput> items,
    required PaymentMethod paymentMethod,
    double? paidAmount,
    double? cashAmount,
    double? cardAmount,
  }) {
    return _repository.createSale(
      items: items,
      paymentMethod: paymentMethod,
      paidAmount: paidAmount,
      cashAmount: cashAmount,
      cardAmount: cardAmount,
    );
  }
}
