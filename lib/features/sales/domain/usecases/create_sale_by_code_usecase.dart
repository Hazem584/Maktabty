import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/sale_response_entity.dart';
import 'package:maktabty/features/sales/domain/repositories/sales_repository.dart';
import 'package:maktabty/features/products/domain/repositories/products_repository.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_input.dart';

class CreateSaleByCodeUseCase {
  final SalesRepository _repository;
  final ProductsRepository _productsRepository;

  const CreateSaleByCodeUseCase(this._repository, this._productsRepository);

  Future<SaleResponseEntity> call({
    required String code,
    required int quantity,
    required PaymentMethod paymentMethod,
    double? unitPriceOverride,
    double? paidAmount,
    double? cashAmount,
    double? cardAmount,
  }) async {
    final product = await _productsRepository.getProductByCode(code);
    return _repository.createSale(
      items: [
        SaleItemInput(
          productId: product.id,
          productName: product.name,
          productCode: product.code,
          sellingPrice: product.price,
          quantity: quantity,
          unitPriceOverride: unitPriceOverride,
        ),
      ],
      paymentMethod: paymentMethod,
      paidAmount: paidAmount,
      cashAmount: cashAmount,
      cardAmount: cardAmount,
    );
  }
}
