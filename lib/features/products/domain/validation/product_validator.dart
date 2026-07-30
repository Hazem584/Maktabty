import 'package:maktabty/core/validation/validation_result.dart';

class ProductInput {
  final String name;
  final double price;
  final int stock;
  final String? code;

  const ProductInput({
    required this.name,
    required this.price,
    required this.stock,
    this.code,
  });
}

class ProductValidator {
  const ProductValidator._();

  static ValidationResult<ProductInput> validate({
    required String name,
    required String price,
    required String stock,
    String? code,
  }) {
    final normalizedName = name.trim();
    final normalizedCode = _normalizeCode(code);
    if (normalizedName.length < 2) {
      return const ValidationResult.invalid(ValidationKey.nameTooShort);
    }
    final parsedPrice = double.tryParse(price.trim());
    if (parsedPrice == null || !parsedPrice.isFinite || parsedPrice <= 0) {
      return const ValidationResult.invalid(ValidationKey.invalidPrice);
    }
    final parsedStock = int.tryParse(stock.trim());
    if (parsedStock == null || parsedStock < 0) {
      return const ValidationResult.invalid(ValidationKey.invalidStock);
    }
    if (normalizedCode != null &&
        (normalizedCode.length > 128 ||
            RegExp(r'[\x00-\x1F]').hasMatch(normalizedCode))) {
      return const ValidationResult.invalid(ValidationKey.invalidCode);
    }
    return ValidationResult.valid(
      ProductInput(
        name: normalizedName,
        price: parsedPrice,
        stock: parsedStock,
        code: normalizedCode,
      ),
    );
  }

  static String? _normalizeCode(String? code) {
    final normalized = code?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }
}
