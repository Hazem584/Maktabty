class ProductEntity {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String? code;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? category;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.code,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  ProductEntity copyWith({
    String? id,
    String? name,
    double? price,
    int? stock,
    String? code,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? category,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
    );
  }
}
