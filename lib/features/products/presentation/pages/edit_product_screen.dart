import 'package:flutter/material.dart';
import 'package:maktabty/features/inventory/presentation/pages/edit_product_screen.dart'
    as legacy;
import 'package:maktabty/features/products/domain/entities/product_entity.dart';

class EditProductScreen extends StatelessWidget {
  final ProductEntity product;

  const EditProductScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return legacy.EditProductScreen(product: product);
  }
}
