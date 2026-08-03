class LocalDatabaseException implements Exception {
  final String operation;
  final Object? cause;

  const LocalDatabaseException({required this.operation, this.cause});

  @override
  String toString() => 'Local database operation failed: $operation';
}

class LocalStockException implements Exception {
  final String productId;
  final int requested;
  final int available;

  const LocalStockException({
    required this.productId,
    required this.requested,
    required this.available,
  });
}

class LocalArchivedProductException implements Exception {
  final String productId;
  const LocalArchivedProductException(this.productId);
}
