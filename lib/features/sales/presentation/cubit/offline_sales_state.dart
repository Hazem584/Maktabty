import 'package:equatable/equatable.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/sales/domain/entities/local_sale_entity.dart';

class OfflineSalesState extends Equatable {
  final String? ownerUserId;
  final List<LocalSaleEntity> sales;
  final bool isSyncing;
  final int processed;
  final int pendingCount;
  final int otherOwnerUnsyncedCount;
  final FailureCode? lastSyncFailureCode;

  const OfflineSalesState({
    required this.ownerUserId,
    required this.sales,
    required this.isSyncing,
    required this.processed,
    required this.pendingCount,
    required this.otherOwnerUnsyncedCount,
    required this.lastSyncFailureCode,
  });

  factory OfflineSalesState.initial() {
    return const OfflineSalesState(
      ownerUserId: null,
      sales: [],
      isSyncing: false,
      processed: 0,
      pendingCount: 0,
      otherOwnerUnsyncedCount: 0,
      lastSyncFailureCode: null,
    );
  }

  OfflineSalesState copyWith({
    String? ownerUserId,
    List<LocalSaleEntity>? sales,
    bool? isSyncing,
    int? processed,
    int? pendingCount,
    int? otherOwnerUnsyncedCount,
    FailureCode? lastSyncFailureCode,
    bool clearFailure = false,
  }) {
    return OfflineSalesState(
      ownerUserId: ownerUserId ?? this.ownerUserId,
      sales: sales ?? this.sales,
      isSyncing: isSyncing ?? this.isSyncing,
      processed: processed ?? this.processed,
      pendingCount: pendingCount ?? this.pendingCount,
      otherOwnerUnsyncedCount:
          otherOwnerUnsyncedCount ?? this.otherOwnerUnsyncedCount,
      lastSyncFailureCode: clearFailure
          ? null
          : lastSyncFailureCode ?? this.lastSyncFailureCode,
    );
  }

  @override
  List<Object?> get props => [
    ownerUserId,
    sales,
    isSyncing,
    processed,
    pendingCount,
    otherOwnerUnsyncedCount,
    lastSyncFailureCode,
  ];
}
