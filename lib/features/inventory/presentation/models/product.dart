class Product {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String? code;
  final String? category;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.code,
    this.category,
  });

  Product copyWith({
    String? id,
    String? name,
    double? price,
    int? stock,
    String? code,
    String? category,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      code: code ?? this.code,
      category: category ?? this.category,
    );
  }
}
