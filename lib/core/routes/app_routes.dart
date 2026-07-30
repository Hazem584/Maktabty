import 'package:flutter/material.dart';
import 'package:maktabty/core/routes/auth_guard.dart';
import 'package:maktabty/core/routes/route_not_found_screen.dart';
import 'package:maktabty/features/auth/presentation/pages/create_account_screen.dart';
import 'package:maktabty/features/auth/presentation/pages/auth_gate_screen.dart';
import 'package:maktabty/features/auth/presentation/pages/login_screen.dart';
import 'package:maktabty/features/home/presentation/pages/home_screen.dart';
import 'package:maktabty/features/products/presentation/pages/add_product_screen.dart';
import 'package:maktabty/features/products/presentation/pages/sell_product_screen.dart';
import 'package:maktabty/features/sales/presentation/pages/printer_settings_screen.dart';
import 'package:maktabty/features/work_hours/presentation/pages/add_work_hours_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String root = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String createAccount = '/create-account';
  static const String addProduct = '/inventory/add-product';
  static const String sellProduct = '/sales/sell-product';
  static const String addWorkHours = '/work-hours/add';
  static const String printerSettings = '/settings/printer';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute(builder: (_) => const AuthGateScreen());
      case home:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: HomeScreen()),
        );
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case createAccount:
        return MaterialPageRoute(builder: (_) => const CreateAccountScreen());
      case addProduct:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: AddProductScreen()),
        );
      case sellProduct:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: SellProductScreen()),
        );
      case addWorkHours:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: AddWorkHoursScreen()),
        );
      case printerSettings:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: PrinterSettingsScreen()),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => RouteNotFoundScreen(routeName: settings.name),
        );
    }
  }
}
