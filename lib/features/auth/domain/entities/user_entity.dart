class UserEntity {
  final String id;
  final String email;
  final String fullName;
  final String? role;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.role,
  });
}
