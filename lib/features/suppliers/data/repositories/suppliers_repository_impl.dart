import 'package:maktabty/core/network/app_failure_mapper.dart';
import 'package:maktabty/features/suppliers/data/datasources/suppliers_remote_datasource.dart';
import 'package:maktabty/features/suppliers/domain/entities/supplier_entities.dart';
import 'package:maktabty/features/suppliers/domain/repositories/suppliers_repository.dart';

class SuppliersRepositoryImpl implements SuppliersRepository {
  final SuppliersRemoteDataSource _remote;
  const SuppliersRepositoryImpl(this._remote);

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }

  @override
  Future<PaginatedSuppliersEntity> getSuppliers({String? search, bool? isActive, int page = 1, int limit = 20}) => _guard(() async {
    final result = await _remote.getSuppliers(search: search, isActive: isActive, page: page, limit: limit);
    return PaginatedSuppliersEntity(items: result.items.map((model) => model.entity).toList(growable: false), page: result.page, limit: result.limit, total: result.total);
  });

  @override
  Future<SupplierEntity> getSupplier(String id) => _guard(() async => (await _remote.getSupplier(id)).entity);

  @override
  Future<SupplierEntity> createSupplier({required String name, String? phone, String? email, String? address, String? taxNumber, String? notes}) => _guard(() async => (await _remote.createSupplier({
    'name': name.trim(),
    if (_present(phone)) 'phone': phone!.trim(),
    if (_present(email)) 'email': email!.trim(),
    if (_present(address)) 'address': address!.trim(),
    if (_present(taxNumber)) 'taxNumber': taxNumber!.trim(),
    if (_present(notes)) 'notes': notes!.trim(),
  })).entity);

  @override
  Future<SupplierEntity> updateSupplier({required String id, String? name, String? phone, String? email, String? address, String? taxNumber, String? notes, bool? isActive}) => _guard(() async => (await _remote.updateSupplier(id, {
    if (name != null) 'name': name.trim(),
    if (phone != null) 'phone': phone.trim(),
    if (email != null) 'email': email.trim(),
    if (address != null) 'address': address.trim(),
    if (taxNumber != null) 'taxNumber': taxNumber.trim(),
    if (notes != null) 'notes': notes.trim(),
    'isActive': ?isActive,
  })).entity);

  @override
  Future<SupplierEntity> deactivateSupplier(String id) => _guard(() async => (await _remote.deactivateSupplier(id)).entity);

  @override
  Future<List<SupplierPaymentEntity>> getPayments(String supplierId) => _guard(() async => (await _remote.getPayments(supplierId)).map((model) => model.entity).toList(growable: false));

  @override
  Future<SupplierPaymentEntity> createPayment({required String supplierId, required String purchaseInvoiceId, required double amount, required SupplierPaymentMethod method, required DateTime paidAt, String? reference, String? notes}) => _guard(() async => (await _remote.createPayment(supplierId, {
    'purchaseInvoiceId': purchaseInvoiceId,
    'amount': amount,
    'paymentMethod': SuppliersRemoteDataSource.methodValue(method),
    'paidAt': paidAt.toIso8601String(),
    if (_present(reference)) 'reference': reference!.trim(),
    if (_present(notes)) 'notes': notes!.trim(),
  })).entity);

  @override
  Future<SupplierStatementEntity> getStatement(String supplierId, {DateTime? from, DateTime? to}) => _guard(() async => (await _remote.getStatement(supplierId, from: from, to: to)).entity);

  static bool _present(String? value) => value?.trim().isNotEmpty == true;
}
