class ProductMiniEntity {
  final String id;
  final String name;
  final String? code;

  const ProductMiniEntity({
    required this.id,
    required this.name,
    this.code,
  });
}

