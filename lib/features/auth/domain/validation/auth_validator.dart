import 'package:maktabty/core/validation/validation_result.dart';

class LoginInput {
  final String email;
  final String password;

  const LoginInput({required this.email, required this.password});
}

class RegistrationInput {
  final String fullName;
  final String storeName;
  final String email;
  final String password;

  const RegistrationInput({
    required this.fullName,
    required this.storeName,
    required this.email,
    required this.password,
  });
}

class AuthValidator {
  const AuthValidator._();

  static ValidationResult<LoginInput> login({
    required String email,
    required String password,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty || password.isEmpty) {
      return const ValidationResult.invalid(ValidationKey.requiredFields);
    }
    if (!_isValidEmail(normalizedEmail)) {
      return const ValidationResult.invalid(ValidationKey.invalidEmail);
    }
    return ValidationResult.valid(
      LoginInput(email: normalizedEmail, password: password),
    );
  }

  static ValidationResult<RegistrationInput> registration({
    required String fullName,
    required String storeName,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    final normalizedName = fullName.trim();
    final normalizedStoreName = storeName.trim();
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedName.isEmpty || normalizedEmail.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return const ValidationResult.invalid(ValidationKey.requiredFields);
    }
    if (normalizedStoreName.isEmpty) {
      return const ValidationResult.invalid(ValidationKey.storeNameRequired);
    }
    if (!_isValidEmail(normalizedEmail)) {
      return const ValidationResult.invalid(ValidationKey.invalidEmail);
    }
    if (password.length < 8) {
      return const ValidationResult.invalid(ValidationKey.passwordTooShort);
    }
    if (password != confirmPassword) {
      return const ValidationResult.invalid(ValidationKey.passwordsDoNotMatch);
    }
    return ValidationResult.valid(
      RegistrationInput(
        fullName: normalizedName,
        storeName: normalizedStoreName,
        email: normalizedEmail,
        password: password,
      ),
    );
  }

  static bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }
}
