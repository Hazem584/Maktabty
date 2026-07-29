import 'package:flutter/material.dart';
import 'package:maktabty/features/inventory/presentation/pages/edit_product_screen_body.dart'
    as legacy;
import 'package:maktabty/features/products/domain/entities/product_entity.dart';

class EditProductScreenBody extends StatelessWidget {
  final ProductEntity product;

  const EditProductScreenBody({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return legacy.EditProductScreenBody(product: product);
  }
}
