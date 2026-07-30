import 'package:equatable/equatable.dart';

class WorkDayUserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String role;

  const WorkDayUserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  @override
  List<Object?> get props => [id, fullName, email, role];
}
