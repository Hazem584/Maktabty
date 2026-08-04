import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? role;
  final String? storeId;
  final bool? isActive;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.role,
    this.storeId,
    this.isActive,
  });

  bool get hasTrustedStoreMembership =>
      storeId?.trim().isNotEmpty == true && isActive == true;

  @override
  List<Object?> get props => [id, email, fullName, role, storeId, isActive];
}
