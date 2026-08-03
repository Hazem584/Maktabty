import 'package:maktabty/core/network/app_failure_mapper.dart';
import 'package:maktabty/features/purchases/data/datasources/purchases_remote_datasource.dart';
import 'package:maktabty/features/purchases/domain/entities/purchase_entities.dart';
import 'package:maktabty/features/purchases/domain/repositories/purchases_repository.dart';

class PurchasesRepositoryImpl implements PurchasesRepository {
  final PurchasesRemoteDataSource _remote;
  const PurchasesRepositoryImpl(this._remote);

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }

  @override
  Future<PaginatedPurchasesEntity> getPurchases({String? supplierId, PurchaseStatus? status, String? search, DateTime? from, DateTime? to, int page = 1, int limit = 20}) => _guard(() async {
    final result = await _remote.getPurchases(supplierId: supplierId, status: status, search: search, from: from, to: to, page: page, limit: limit);
    return PaginatedPurchasesEntity(items: result.items.map((model) => model.entity).toList(growable: false), page: result.page, limit: result.limit, total: result.total);
  });

  @override
  Future<PurchaseInvoiceEntity> getPurchase(String id) => _guard(() async => (await _remote.getPurchase(id)).entity);
  @override
  Future<PurchaseInvoiceEntity> createDraft(PurchaseDraftInput input) => _guard(() async => (await _remote.createDraft(input.toJson())).entity);
  @override
  Future<PurchaseInvoiceEntity> updateDraft(String id, PurchaseDraftInput input) => _guard(() async => (await _remote.updateDraft(id, input.toJson())).entity);
  @override
  Future<void> deleteDraft(String id) => _guard(() => _remote.deleteDraft(id));
  @override
  Future<PurchaseInvoiceEntity> postDraft(String id) => _guard(() async => (await _remote.postDraft(id)).entity);
}
