import 'package:equatable/equatable.dart';

class ReceiptStoreEntity extends Equatable {
  final String name;
  final String? address;
  final String? phone;
  final String? taxNumber;

  const ReceiptStoreEntity({
    required this.name,
    this.address,
    this.phone,
    this.taxNumber,
  });

  @override
  List<Object?> get props => [name, address, phone, taxNumber];
}
