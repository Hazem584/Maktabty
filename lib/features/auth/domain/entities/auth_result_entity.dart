import 'package:equatable/equatable.dart';
import 'package:maktabty/features/auth/domain/entities/store_entity.dart';
import 'package:maktabty/features/auth/domain/entities/user_entity.dart';

class AuthResultEntity extends Equatable {
  final UserEntity user;
  final StoreEntity? store;

  const AuthResultEntity({required this.user, this.store});

  @override
  List<Object?> get props => [user, store];
}
