import 'package:equatable/equatable.dart';

class UserMiniEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String role;

  const UserMiniEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  @override
  List<Object?> get props => [id, fullName, email, role];
}
