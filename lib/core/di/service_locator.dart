import 'package:get_it/get_it.dart';
import 'package:maktabty/core/config/api_config.dart';
import 'package:maktabty/core/di/auth_dependencies.dart';
import 'package:maktabty/core/di/core_dependencies.dart';
import 'package:maktabty/core/di/database_dependencies.dart';
import 'package:maktabty/core/di/products_dependencies.dart';
import 'package:maktabty/core/di/procurement_dependencies.dart';
import 'package:maktabty/core/di/reports_dependencies.dart';
import 'package:maktabty/core/di/sales_dependencies.dart';
import 'package:maktabty/core/di/services_dependencies.dart';
import 'package:maktabty/core/di/work_hours_dependencies.dart';

final sl = GetIt.instance;

void setupAppDependencies({required ApiConfig apiConfig}) {
  registerCoreDependencies(sl, apiConfig: apiConfig);
  registerDatabaseDependencies(sl);
  registerServicesDependencies(sl);
  registerAuthDependencies(sl);
  registerProductsDependencies(sl);
  registerProcurementDependencies(sl);
  registerSalesDependencies(sl);
  registerReportsDependencies(sl);
  registerWorkHoursDependencies(sl);
}
