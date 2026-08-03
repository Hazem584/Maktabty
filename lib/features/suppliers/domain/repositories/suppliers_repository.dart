import 'package:maktabty/features/suppliers/domain/entities/supplier_entities.dart';

abstract class SuppliersRepository {
  Future<PaginatedSuppliersEntity> getSuppliers({String? search, bool? isActive, int page = 1, int limit = 20});
  Future<SupplierEntity> getSupplier(String id);
  Future<SupplierEntity> createSupplier({required String name, String? phone, String? email, String? address, String? taxNumber, String? notes});
  Future<SupplierEntity> updateSupplier({required String id, String? name, String? phone, String? email, String? address, String? taxNumber, String? notes, bool? isActive});
  Future<SupplierEntity> deactivateSupplier(String id);
  Future<List<SupplierPaymentEntity>> getPayments(String supplierId);
  Future<SupplierPaymentEntity> createPayment({required String supplierId, required String purchaseInvoiceId, required double amount, required SupplierPaymentMethod method, required DateTime paidAt, String? reference, String? notes});
  Future<SupplierStatementEntity> getStatement(String supplierId, {DateTime? from, DateTime? to});
}
