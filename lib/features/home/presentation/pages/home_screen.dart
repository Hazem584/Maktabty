import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:maktabty/features/home/presentation/pages/home_screen_body.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:maktabty/features/products/presentation/pages/inventory_screen.dart';
import 'package:maktabty/features/reports/presentation/pages/reports_page.dart';
import 'package:maktabty/features/sales/presentation/pages/sales_screen.dart';
import 'package:maktabty/features/work_hours/presentation/pages/add_work_hours_screen.dart';
import 'package:maktabty/features/sales/presentation/cubit/today_sales_cubit.dart';
import 'package:maktabty/features/work_hours/presentation/cubit/work_hours_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _reportsRefreshVersion = 0;
  late final ProductsListCubit _productsListCubit;
  late final TodaySalesCubit _todaySalesCubit;
  late final WorkHoursCubit _workHoursCubit;

  @override
  void initState() {
    super.initState();
    _productsListCubit = sl<ProductsListCubit>()..loadInitial();
    _todaySalesCubit = sl<TodaySalesCubit>()..load();
    _workHoursCubit = sl<WorkHoursCubit>()..loadByDate(date: DateTime.now());
  }

  @override
  void dispose() {
    _productsListCubit.close();
    _todaySalesCubit.close();
    _workHoursCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = context.select<AuthCubit, bool>((cubit) {
      return cubit.state.user?.role?.toUpperCase() == 'OWNER';
    });

    final items = <_NavItem>[
      _NavItem(
        label: context.l10n.home,
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        page: const SafeArea(child: HomeScreenBody()),
      ),
      _NavItem(
        label: context.l10n.inventory,
        icon: Icons.inventory_2_outlined,
        selectedIcon: Icons.inventory_2,
        page: const InventoryScreen(),
      ),
      _NavItem(
        label: context.l10n.sales,
        icon: Icons.receipt_long,
        selectedIcon: Icons.receipt_long,
        page: const SalesScreen(),
      ),
      _NavItem(
        label: context.l10n.workHours,
        icon: Icons.schedule_outlined,
        selectedIcon: Icons.schedule,
        page: const AddWorkHoursScreen(),
      ),
      if (isOwner)
        _NavItem(
          label: context.l10n.reports,
          icon: Icons.bar_chart_outlined,
          selectedIcon: Icons.bar_chart,
          page: ReportsPage(key: ValueKey(_reportsRefreshVersion)),
        ),
    ];
    final reportsIndex = isOwner ? items.length - 1 : -1;

    final maxIndex = items.length - 1;
    final currentIndex = _selectedIndex.clamp(0, maxIndex);
    if (_selectedIndex != currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedIndex = currentIndex;
          });
        }
      });
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductsListCubit>.value(value: _productsListCubit),
        BlocProvider<TodaySalesCubit>.value(value: _todaySalesCubit),
        BlocProvider<WorkHoursCubit>.value(value: _workHoursCubit),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: items.map((item) => item.page).toList(),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              if (isOwner && index == reportsIndex) {
                _reportsRefreshVersion++;
              }
              _selectedIndex = index;
            });
            if (index == 0) {
              _todaySalesCubit.load();
              _workHoursCubit.loadByDate(date: DateTime.now());
              _productsListCubit.refresh();
            }
          },
          destinations: items
              .map(
                (item) => NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: item.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });
}
