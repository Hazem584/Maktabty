import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/features/inventory/presentation/pages/add_product_screen_body.dart';
import 'package:maktabty/features/products/presentation/cubit/product_form_cubit.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductFormCubit>(
      create: (_) => sl<ProductFormCubit>(),
      child: Scaffold(
        appBar: AppBar(
        title: Text(context.l10n.addProduct),
        ),
        body: const SafeArea(
          child: AddProductScreenBody(),
        ),
      ),
    );
  }
}
