import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/inventory/presentation/pages/edit_product_screen_body.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/presentation/cubit/product_form_cubit.dart';

class EditProductScreen extends StatelessWidget {
  final ProductEntity product;

  const EditProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductFormCubit>(
      create: (_) => sl<ProductFormCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.editProduct)),
        body: SafeArea(child: EditProductScreenBody(product: product)),
      ),
    );
  }
}
