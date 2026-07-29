enum PaymentMethod { cash, card, mixed }

extension PaymentMethodX on PaymentMethod {
  String get apiValue {
    switch (this) {
      case PaymentMethod.cash:
        return 'CASH';
      case PaymentMethod.card:
        return 'CARD';
      case PaymentMethod.mixed:
        return 'MIXED';
    }
  }

  String get labelKey {
    switch (this) {
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.card:
        return 'card';
      case PaymentMethod.mixed:
        return 'mixed';
    }
  }

  static PaymentMethod fromApi(dynamic value) {
    final raw = value?.toString().toUpperCase();
    switch (raw) {
      case 'CARD':
        return PaymentMethod.card;
      case 'MIXED':
        return PaymentMethod.mixed;
      case 'CASH':
      default:
        return PaymentMethod.cash;
    }
  }
}
