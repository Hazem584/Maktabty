import 'package:maktabty/core/validation/validation_result.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_input.dart';

class SaleValidator {
  const SaleValidator._();

  static ValidationKey? validateItems(List<SaleItemInput> items) {
    if (items.isEmpty) return ValidationKey.atLeastOneSaleItem;
    final productIds = <String>{};
    for (final item in items) {
      if (item.productId.trim().isEmpty || item.quantity <= 0) {
        return ValidationKey.invalidQuantity;
      }
      if (!productIds.add(item.productId)) {
        return ValidationKey.duplicateSaleItem;
      }
      final price = item.unitPriceOverride;
      if (price != null && (!price.isFinite || price <= 0)) {
        return ValidationKey.invalidUnitPrice;
      }
    }
    return null;
  }

  static ValidationKey? validatePayment({
    required PaymentMethod method,
    required double? total,
    double? paidAmount,
    double? cashAmount,
    double? cardAmount,
  }) {
    final totalMinor = total == null ? null : _minorUnits(total);
    switch (method) {
      case PaymentMethod.cash:
        if (paidAmount == null || paidAmount <= 0) {
          return ValidationKey.enterPaidAmount;
        }
        if (totalMinor != null && _minorUnits(paidAmount) < totalMinor) {
          return ValidationKey.paidAmountTooLow;
        }
        return null;
      case PaymentMethod.card:
        return null;
      case PaymentMethod.mixed:
        if (cashAmount == null || cashAmount <= 0) {
          return ValidationKey.enterCashAmount;
        }
        if (cardAmount == null || cardAmount <= 0) {
          return ValidationKey.enterCardAmount;
        }
        if (totalMinor != null &&
            _minorUnits(cashAmount) + _minorUnits(cardAmount) != totalMinor) {
          return ValidationKey.paymentTotalMismatch;
        }
        return null;
    }
  }

  static int _minorUnits(double value) => (value * 100).round();
}
