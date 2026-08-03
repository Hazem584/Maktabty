import 'package:maktabty/features/purchases/domain/entities/purchase_entities.dart';

abstract class PurchasesRepository {
  Future<PaginatedPurchasesEntity> getPurchases({String? supplierId, PurchaseStatus? status, String? search, DateTime? from, DateTime? to, int page = 1, int limit = 20});
  Future<PurchaseInvoiceEntity> getPurchase(String id);
  Future<PurchaseInvoiceEntity> createDraft(PurchaseDraftInput input);
  Future<PurchaseInvoiceEntity> updateDraft(String id, PurchaseDraftInput input);
  Future<void> deleteDraft(String id);
  Future<PurchaseInvoiceEntity> postDraft(String id);
}
