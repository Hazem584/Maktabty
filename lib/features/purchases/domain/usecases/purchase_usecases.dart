import 'package:maktabty/features/purchases/domain/entities/purchase_entities.dart';
import 'package:maktabty/features/purchases/domain/repositories/purchases_repository.dart';

class PurchaseUseCases {
  final PurchasesRepository repository;
  const PurchaseUseCases(this.repository);
  Future<PaginatedPurchasesEntity> getPurchases({String? supplierId, PurchaseStatus? status, String? search, DateTime? from, DateTime? to, int page = 1, int limit = 20}) => repository.getPurchases(supplierId: supplierId, status: status, search: search, from: from, to: to, page: page, limit: limit);
  Future<PurchaseInvoiceEntity> getPurchase(String id) => repository.getPurchase(id);
  Future<PurchaseInvoiceEntity> createDraft(PurchaseDraftInput input) => repository.createDraft(input);
  Future<PurchaseInvoiceEntity> updateDraft(String id, PurchaseDraftInput input) => repository.updateDraft(id, input);
  Future<void> deleteDraft(String id) => repository.deleteDraft(id);
  Future<PurchaseInvoiceEntity> postDraft(String id) => repository.postDraft(id);
}
