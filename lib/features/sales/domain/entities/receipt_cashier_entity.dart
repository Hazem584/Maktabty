import 'package:equatable/equatable.dart';

class ReceiptCashierEntity extends Equatable {
  final String id;
  final String fullName;

  const ReceiptCashierEntity({required this.id, required this.fullName});

  @override
  List<Object?> get props => [id, fullName];
}
