import 'package:flutter/material.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/inventory/presentation/pages/inventory_screen_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/routes/app_routes.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/product_archive_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_cubit.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isOwner = context.select<AuthCubit, bool>(
      (cubit) => cubit.state.user?.role?.trim().toUpperCase() == 'OWNER',
    );
    return BlocProvider(
      create: (_) => sl<ProductArchiveCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.inventory),
          actions: [
            if (isOwner)
              IconButton(
                onPressed: () async {
                  await Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.archivedProducts);
                  if (context.mounted) {
                    context.read<ProductsListCubit>().refresh();
                  }
                },
                icon: const Icon(Icons.archive_outlined),
                tooltip: context.l10n.archivedProducts,
              ),
          ],
        ),
        body: const SafeArea(child: InventoryScreenBody()),
      ),
    );
  }
}
