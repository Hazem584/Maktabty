enum ValidationKey {
  requiredFields,
  storeNameRequired,
  invalidEmail,
  passwordTooShort,
  passwordsDoNotMatch,
  nameTooShort,
  invalidPrice,
  invalidStock,
  invalidCode,
  atLeastOneSaleItem,
  invalidQuantity,
  duplicateSaleItem,
  invalidUnitPrice,
  enterPaidAmount,
  enterCashAmount,
  enterCardAmount,
  paymentTotalMismatch,
  paidAmountTooLow,
  invalidShiftTimes,
  overlappingShifts,
}

class ValidationResult<T> {
  final T? value;
  final ValidationKey? error;

  const ValidationResult.valid(this.value) : error = null;

  const ValidationResult.invalid(this.error) : value = null;

  bool get isValid => error == null;
}
