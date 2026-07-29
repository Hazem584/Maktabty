import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:maktabty/features/sales/presentation/cubit/create_sale_by_code_cubit.dart';
import 'package:maktabty/features/sales/presentation/cubit/create_sale_cubit.dart';
import 'package:maktabty/features/sales/presentation/cubit/today_sales_cubit.dart';
import 'package:maktabty/features/sales/presentation/pages/sales_screen_body.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProductsListCubit? existingProductsCubit;
    try {
      existingProductsCubit = context.read<ProductsListCubit>();
    } catch (_) {
      existingProductsCubit = null;
    }

    final providers = <BlocProvider>[
      if (existingProductsCubit != null)
        BlocProvider<ProductsListCubit>.value(value: existingProductsCubit)
      else
        BlocProvider<ProductsListCubit>(
          create: (_) => sl<ProductsListCubit>()..loadInitial(),
        ),
      BlocProvider<CreateSaleCubit>(create: (_) => sl<CreateSaleCubit>()),
      BlocProvider<CreateSaleByCodeCubit>(
        create: (_) => sl<CreateSaleByCodeCubit>(),
      ),
      BlocProvider<TodaySalesCubit>(
        create: (_) => sl<TodaySalesCubit>()..load(),
      ),
    ];

    return MultiBlocProvider(
      providers: providers,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.sales),
            bottom: TabBar(
              tabs: [
                Tab(text: context.l10n.newSaleTab),
                Tab(text: context.l10n.byCodeTab),
              ],
            ),
          ),
          body: const SafeArea(child: SalesScreenBody()),
        ),
      ),
    );
  }
}
