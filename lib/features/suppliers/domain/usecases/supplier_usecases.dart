import 'package:maktabty/features/suppliers/domain/entities/supplier_entities.dart';
import 'package:maktabty/features/suppliers/domain/repositories/suppliers_repository.dart';

class SupplierUseCases {
  final SuppliersRepository repository;
  const SupplierUseCases(this.repository);

  Future<PaginatedSuppliersEntity> getSuppliers({String? search, bool? isActive, int page = 1, int limit = 20}) => repository.getSuppliers(search: search, isActive: isActive, page: page, limit: limit);
  Future<SupplierEntity> getSupplier(String id) => repository.getSupplier(id);
  Future<SupplierEntity> create({required String name, String? phone, String? email, String? address, String? taxNumber, String? notes}) => repository.createSupplier(name: name, phone: phone, email: email, address: address, taxNumber: taxNumber, notes: notes);
  Future<SupplierEntity> update({required String id, String? name, String? phone, String? email, String? address, String? taxNumber, String? notes, bool? isActive}) => repository.updateSupplier(id: id, name: name, phone: phone, email: email, address: address, taxNumber: taxNumber, notes: notes, isActive: isActive);
  Future<SupplierEntity> deactivate(String id) => repository.deactivateSupplier(id);
  Future<List<SupplierPaymentEntity>> getPayments(String id) => repository.getPayments(id);
  Future<SupplierStatementEntity> getStatement(String id, {DateTime? from, DateTime? to}) => repository.getStatement(id, from: from, to: to);
  Future<SupplierPaymentEntity> createPayment({required String supplierId, required String purchaseInvoiceId, required double amount, required SupplierPaymentMethod method, required DateTime paidAt, String? reference, String? notes}) => repository.createPayment(supplierId: supplierId, purchaseInvoiceId: purchaseInvoiceId, amount: amount, method: method, paidAt: paidAt, reference: reference, notes: notes);
}
