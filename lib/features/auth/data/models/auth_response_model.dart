import 'package:maktabty/features/auth/data/models/user_model.dart';

class AuthResponseModel {
  final UserModel user;
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  const AuthResponseModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final userJson = _extractUserJson(json);
    return AuthResponseModel(
      user: UserModel.fromJson(userJson),
      accessToken: (json['accessToken'] ?? '').toString(),
      refreshToken: (json['refreshToken'] ?? '').toString(),
      tokenType: (json['tokenType'] ?? 'Bearer').toString(),
    );
  }

  static Map<String, dynamic> _extractUserJson(Map<String, dynamic> json) {
    final user = json['user'];
    if (user is Map<String, dynamic>) {
      return user;
    }
    return json;
  }
}
