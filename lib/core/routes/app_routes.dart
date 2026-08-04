import 'package:flutter/material.dart';
import 'package:maktabty/core/routes/auth_guard.dart';
import 'package:maktabty/core/routes/route_not_found_screen.dart';
import 'package:maktabty/features/auth/presentation/pages/create_account_screen.dart';
import 'package:maktabty/features/auth/presentation/pages/auth_gate_screen.dart';
import 'package:maktabty/features/auth/presentation/pages/login_screen.dart';
import 'package:maktabty/features/cashiers/domain/entities/cashier_entity.dart';
import 'package:maktabty/features/cashiers/presentation/pages/cashier_details_screen.dart';
import 'package:maktabty/features/cashiers/presentation/pages/cashier_form_screen.dart';
import 'package:maktabty/features/cashiers/presentation/pages/cashier_password_screen.dart';
import 'package:maktabty/features/cashiers/presentation/pages/cashiers_screen.dart';
import 'package:maktabty/features/home/presentation/pages/home_screen.dart';
import 'package:maktabty/features/products/presentation/pages/add_product_screen.dart';
import 'package:maktabty/features/products/presentation/pages/sell_product_screen.dart';
import 'package:maktabty/features/sales/presentation/pages/printer_settings_screen.dart';
import 'package:maktabty/features/sales/presentation/pages/offline_sales_screen.dart';
import 'package:maktabty/features/work_hours/presentation/pages/add_work_hours_screen.dart';
import 'package:maktabty/features/purchases/domain/entities/purchase_entities.dart';
import 'package:maktabty/features/purchases/presentation/pages/purchases_pages.dart';
import 'package:maktabty/features/stock_movements/presentation/pages/stock_movements_screen.dart';
import 'package:maktabty/features/suppliers/domain/entities/supplier_entities.dart';
import 'package:maktabty/features/suppliers/presentation/pages/suppliers_pages.dart';
import 'package:maktabty/features/products/presentation/pages/archived_products_screen.dart';
import 'package:maktabty/features/settings/presentation/pages/settings_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String root = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String createAccount = '/create-account';
  static const String settings = '/settings';
  static const String cashiers = '/cashiers';
  static const String cashierCreate = '/cashiers/create';
  static const String cashierDetails = '/cashiers/details';
  static const String cashierEdit = '/cashiers/edit';
  static const String cashierPassword = '/cashiers/password';
  static const String addProduct = '/inventory/add-product';
  static const String sellProduct = '/sales/sell-product';
  static const String addWorkHours = '/work-hours/add';
  static const String printerSettings = '/settings/printer';
  static const String offlineSales = '/sales/offline';
  static const String suppliers = '/suppliers';
  static const String supplierCreate = '/suppliers/create';
  static const String supplierEdit = '/suppliers/edit';
  static const String supplierDetails = '/suppliers/details';
  static const String supplierPayment = '/suppliers/payment';
  static const String purchases = '/purchases';
  static const String purchaseCreate = '/purchases/create';
  static const String purchaseEdit = '/purchases/edit';
  static const String purchaseDetails = '/purchases/details';
  static const String stockMovements = '/stock-movements';
  static const String archivedProducts = '/inventory/archived-products';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
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
      case settings:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: SettingsScreen()),
        );
      case cashiers:
        return MaterialPageRoute(
          builder: (_) => const OwnerGuard(child: CashiersScreen()),
        );
      case cashierCreate:
        return MaterialPageRoute(
          builder: (_) => const OwnerGuard(child: CashierFormScreen()),
        );
      case cashierDetails:
        final cashierIdArgument = routeSettings.arguments;
        if (cashierIdArgument is String && cashierIdArgument.isNotEmpty) {
          return MaterialPageRoute(
            builder: (_) => OwnerGuard(
              child: CashierDetailsScreen(cashierId: cashierIdArgument),
            ),
          );
        }
        break;
      case cashierEdit:
        final editCashierArgument = routeSettings.arguments;
        if (editCashierArgument is CashierEntity) {
          return MaterialPageRoute(
            builder: (_) => OwnerGuard(
              child: CashierFormScreen(cashier: editCashierArgument),
            ),
          );
        }
        break;
      case cashierPassword:
        final passwordCashierArgument = routeSettings.arguments;
        if (passwordCashierArgument is CashierEntity) {
          return MaterialPageRoute(
            builder: (_) => OwnerGuard(
              child: CashierPasswordScreen(cashier: passwordCashierArgument),
            ),
          );
        }
        break;
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
      case offlineSales:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: OfflineSalesScreen()),
        );
      case suppliers:
        return MaterialPageRoute(builder: (_) => const OwnerGuard(child: SuppliersScreen()));
      case supplierCreate:
        return MaterialPageRoute(builder: (_) => const OwnerGuard(child: SupplierFormScreen()));
      case supplierEdit:
        final editSupplierArgument = routeSettings.arguments;
        if (editSupplierArgument is SupplierEntity) return MaterialPageRoute(builder: (_) => OwnerGuard(child: SupplierFormScreen(supplier: editSupplierArgument)));
        break;
      case supplierDetails:
        final supplierIdArgument = routeSettings.arguments;
        if (supplierIdArgument is String) return MaterialPageRoute(builder: (_) => OwnerGuard(child: SupplierDetailsScreen(supplierId: supplierIdArgument)));
        break;
      case supplierPayment:
        final paymentSupplierArgument = routeSettings.arguments;
        if (paymentSupplierArgument is SupplierEntity) return MaterialPageRoute(builder: (_) => OwnerGuard(child: SupplierPaymentScreen(supplier: paymentSupplierArgument)));
        break;
      case purchases:
        return MaterialPageRoute(builder: (_) => const OwnerGuard(child: PurchasesScreen()));
      case purchaseCreate:
        return MaterialPageRoute(builder: (_) => const OwnerGuard(child: PurchaseFormScreen()));
      case purchaseEdit:
        final editInvoiceArgument = routeSettings.arguments;
        if (editInvoiceArgument is PurchaseInvoiceEntity && editInvoiceArgument.isDraft) return MaterialPageRoute(builder: (_) => OwnerGuard(child: PurchaseFormScreen(invoice: editInvoiceArgument)));
        break;
      case purchaseDetails:
        final purchaseIdArgument = routeSettings.arguments;
        if (purchaseIdArgument is String) return MaterialPageRoute(builder: (_) => OwnerGuard(child: PurchaseDetailsScreen(purchaseId: purchaseIdArgument)));
        break;
      case stockMovements:
        final filters = routeSettings.arguments;
        final values = filters is Map ? Map<String, Object?>.from(filters) : const <String, Object?>{};
        return MaterialPageRoute(builder: (_) => OwnerGuard(child: StockMovementsScreen(productId: values['productId'] as String?, purchaseInvoiceId: values['purchaseInvoiceId'] as String?, saleId: values['saleId'] as String?)));
      case archivedProducts:
        return MaterialPageRoute(
          builder: (_) => const OwnerGuard(child: ArchivedProductsScreen()),
        );
      default:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => RouteNotFoundScreen(routeName: routeSettings.name),
        );
    }
    return MaterialPageRoute(settings: routeSettings, builder: (_) => RouteNotFoundScreen(routeName: routeSettings.name));
  }
}
