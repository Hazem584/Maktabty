import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:maktabty/core/config/api_config.dart';
import 'package:maktabty/core/localization/locale_cubit.dart';
import 'package:maktabty/core/localization/locale_storage.dart';
import 'package:maktabty/core/network/dio_client.dart';
import 'package:maktabty/core/network/auth_session_manager.dart';
import 'package:maktabty/core/services/barcode_scanner_service.dart';
import 'package:maktabty/core/services/barcode_scanner_service_mobile.dart';
import 'package:maktabty/core/services/barcode_scanner_service_windows.dart';
import 'package:maktabty/core/services/receipt_printer_service.dart';
import 'package:maktabty/core/storage/printer_settings_storage.dart';
import 'package:maktabty/core/storage/token_storage.dart';
import 'package:maktabty/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:maktabty/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:maktabty/features/auth/domain/repositories/auth_repository.dart';
import 'package:maktabty/features/auth/domain/usecases/get_me_usecase.dart';
import 'package:maktabty/features/auth/domain/usecases/login_usecase.dart';
import 'package:maktabty/features/auth/domain/usecases/logout_usecase.dart';
import 'package:maktabty/features/auth/domain/usecases/refresh_usecase.dart';
import 'package:maktabty/features/auth/domain/usecases/register_usecase.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:maktabty/features/products/data/datasources/products_remote_datasource.dart';
import 'package:maktabty/features/products/data/repositories/products_repository_impl.dart';
import 'package:maktabty/features/products/domain/repositories/products_repository.dart';
import 'package:maktabty/features/products/domain/usecases/create_product_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/get_product_by_code_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/get_products_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/update_product_usecase.dart';
import 'package:maktabty/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:maktabty/features/sales/data/datasources/sales_remote_datasource.dart';
import 'package:maktabty/features/sales/data/repositories/sales_repository_impl.dart';
import 'package:maktabty/features/sales/domain/repositories/sales_repository.dart';
import 'package:maktabty/features/sales/domain/usecases/create_sale_by_code_usecase.dart';
import 'package:maktabty/features/sales/domain/usecases/create_sale_usecase.dart';
import 'package:maktabty/features/sales/domain/usecases/create_sale_with_payment_usecase.dart';
import 'package:maktabty/features/sales/domain/usecases/delete_sale_usecase.dart';
import 'package:maktabty/features/sales/domain/usecases/get_receipt_for_sale_usecase.dart';
import 'package:maktabty/features/sales/domain/usecases/get_today_sales_usecase.dart';
import 'package:maktabty/features/sales/presentation/cubit/create_sale_by_code_cubit.dart';
import 'package:maktabty/features/sales/presentation/cubit/create_sale_cubit.dart';
import 'package:maktabty/features/sales/presentation/cubit/today_sales_cubit.dart';
import 'package:maktabty/features/reports/data/datasources/reports_remote_datasource.dart';
import 'package:maktabty/features/reports/data/repositories/reports_repo_impl.dart';
import 'package:maktabty/features/reports/domain/repositories/reports_repo.dart';
import 'package:maktabty/features/reports/domain/usecases/get_daily_report.dart';
import 'package:maktabty/features/reports/domain/usecases/get_monthly_report.dart';
import 'package:maktabty/features/reports/presentation/cubit/reports_cubit.dart';
import 'package:maktabty/features/work_hours/data/datasources/work_hours_remote_datasource.dart';
import 'package:maktabty/features/work_hours/data/repositories/work_hours_repository_impl.dart';
import 'package:maktabty/features/work_hours/domain/repositories/work_hours_repository.dart';
import 'package:maktabty/features/work_hours/domain/usecases/get_monthly_work_hours.dart';
import 'package:maktabty/features/work_hours/domain/usecases/get_work_hours_by_date.dart';
import 'package:maktabty/features/work_hours/domain/usecases/upsert_work_day.dart';
import 'package:maktabty/features/work_hours/presentation/cubit/monthly_work_hours_cubit.dart';
import 'package:maktabty/features/work_hours/presentation/cubit/work_hours_cubit.dart';

final sl = GetIt.instance;

void setupAppDependencies({required ApiConfig apiConfig}) {
  setupAuthDependencies(apiConfig: apiConfig);

  if (!sl.isRegistered<BarcodeScannerService>()) {
    sl.registerLazySingleton<BarcodeScannerService>(() {
      final isWindows =
          !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;
      return isWindows
          ? WindowsBarcodeScannerService()
          : MobileBarcodeScannerService();
    });
  }

  if (!sl.isRegistered<PrinterSettingsStorage>()) {
    sl.registerLazySingleton<PrinterSettingsStorage>(
      () => PrinterSettingsStorage(),
    );
  }

  if (!sl.isRegistered<ReceiptPrinterService>()) {
    sl.registerLazySingleton<ReceiptPrinterService>(
      () => ReceiptPrinterService(settingsStorage: sl()),
    );
  }

  final dioClient = sl<DioClient>();
  setupProductsDependencies(dioClient: dioClient);
  setupSalesDependencies(dioClient: dioClient);
  setupReportsDependencies(dioClient: dioClient);
  setupWorkHoursDependencies(dioClient: dioClient);
}

void setupAuthDependencies({required ApiConfig apiConfig}) {
  if (!sl.isRegistered<LocaleStorage>()) {
    sl.registerLazySingleton<LocaleStorage>(() => LocaleStorage());
  }

  if (!sl.isRegistered<LocaleCubit>()) {
    sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit(storage: sl()));
  }

  if (!sl.isRegistered<TokenStorage>()) {
    sl.registerLazySingleton<TokenStorage>(() => TokenStorage());
  }

  if (!sl.isRegistered<AuthSessionManager>()) {
    sl.registerLazySingleton<AuthSessionManager>(() => AuthSessionManager());
  }

  if (!sl.isRegistered<DioClient>()) {
    sl.registerLazySingleton<DioClient>(
      () => DioClient(
        tokenStorage: sl(),
        sessionManager: sl(),
        baseUrl: apiConfig.baseUrl,
      ),
    );
  }

  if (!sl.isRegistered<AuthRemoteDataSource>()) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () =>
          AuthRemoteDataSource(sl<DioClient>().dio, sl<DioClient>().refreshDio),
    );
  }

  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl(), tokenStorage: sl()),
    );
  }

  if (!sl.isRegistered<LoginUseCase>()) {
    sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  }
  if (!sl.isRegistered<RegisterUseCase>()) {
    sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));
  }
  if (!sl.isRegistered<LogoutUseCase>()) {
    sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));
  }
  if (!sl.isRegistered<GetMeUseCase>()) {
    sl.registerLazySingleton<GetMeUseCase>(() => GetMeUseCase(sl()));
  }
  if (!sl.isRegistered<RefreshUseCase>()) {
    sl.registerLazySingleton<RefreshUseCase>(() => RefreshUseCase(sl()));
  }

  if (!sl.isRegistered<AuthCubit>()) {
    sl.registerLazySingleton<AuthCubit>(
      () => AuthCubit(
        loginUseCase: sl(),
        registerUseCase: sl(),
        logoutUseCase: sl(),
        getMeUseCase: sl(),
        refreshUseCase: sl(),
        tokenStorage: sl(),
        sessionManager: sl(),
      ),
    );
  }
}

void setupProductsDependencies({required DioClient dioClient}) {
  if (!sl.isRegistered<ProductsRemoteDataSource>()) {
    sl.registerLazySingleton<ProductsRemoteDataSource>(
      () => ProductsRemoteDataSource(dioClient.dio),
    );
  }

  if (!sl.isRegistered<ProductsRepository>()) {
    sl.registerLazySingleton<ProductsRepository>(
      () => ProductsRepositoryImpl(remoteDataSource: sl()),
    );
  }

  if (!sl.isRegistered<GetProductsUseCase>()) {
    sl.registerLazySingleton<GetProductsUseCase>(
      () => GetProductsUseCase(sl()),
    );
  }
  if (!sl.isRegistered<GetProductByIdUseCase>()) {
    sl.registerLazySingleton<GetProductByIdUseCase>(
      () => GetProductByIdUseCase(sl()),
    );
  }
  if (!sl.isRegistered<GetProductByCodeUseCase>()) {
    sl.registerLazySingleton<GetProductByCodeUseCase>(
      () => GetProductByCodeUseCase(sl()),
    );
  }
  if (!sl.isRegistered<CreateProductUseCase>()) {
    sl.registerLazySingleton<CreateProductUseCase>(
      () => CreateProductUseCase(sl()),
    );
  }
  if (!sl.isRegistered<UpdateProductUseCase>()) {
    sl.registerLazySingleton<UpdateProductUseCase>(
      () => UpdateProductUseCase(sl()),
    );
  }
  if (!sl.isRegistered<DeleteProductUseCase>()) {
    sl.registerLazySingleton<DeleteProductUseCase>(
      () => DeleteProductUseCase(sl()),
    );
  }
  if (!sl.isRegistered<ProductsListCubit>()) {
    sl.registerFactory<ProductsListCubit>(
      () => ProductsListCubit(
        getProductsUseCase: sl(),
        deleteProductUseCase: sl(),
      ),
    );
  }
  if (!sl.isRegistered<ProductFormCubit>()) {
    sl.registerFactory<ProductFormCubit>(
      () => ProductFormCubit(
        createProductUseCase: sl(),
        updateProductUseCase: sl(),
      ),
    );
  }
  if (!sl.isRegistered<ProductDetailsCubit>()) {
    sl.registerFactory<ProductDetailsCubit>(
      () => ProductDetailsCubit(
        getProductByIdUseCase: sl(),
        getProductByCodeUseCase: sl(),
      ),
    );
  }
}

void setupSalesDependencies({required DioClient dioClient}) {
  if (!sl.isRegistered<SalesRemoteDataSource>()) {
    sl.registerLazySingleton<SalesRemoteDataSource>(
      () => SalesRemoteDataSource(dioClient.dio),
    );
  }

  if (!sl.isRegistered<SalesRepository>()) {
    sl.registerLazySingleton<SalesRepository>(
      () => SalesRepositoryImpl(remoteDataSource: sl()),
    );
  }

  if (!sl.isRegistered<CreateSaleUseCase>()) {
    sl.registerLazySingleton<CreateSaleUseCase>(() => CreateSaleUseCase(sl()));
  }
  if (!sl.isRegistered<CreateSaleWithPaymentUseCase>()) {
    sl.registerLazySingleton<CreateSaleWithPaymentUseCase>(
      () => CreateSaleWithPaymentUseCase(sl()),
    );
  }
  if (!sl.isRegistered<CreateSaleByCodeUseCase>()) {
    sl.registerLazySingleton<CreateSaleByCodeUseCase>(
      () => CreateSaleByCodeUseCase(sl()),
    );
  }
  if (!sl.isRegistered<GetTodaySalesUseCase>()) {
    sl.registerLazySingleton<GetTodaySalesUseCase>(
      () => GetTodaySalesUseCase(sl()),
    );
  }
  if (!sl.isRegistered<DeleteSaleUseCase>()) {
    sl.registerLazySingleton<DeleteSaleUseCase>(() => DeleteSaleUseCase(sl()));
  }
  if (!sl.isRegistered<GetReceiptForSaleUseCase>()) {
    sl.registerLazySingleton<GetReceiptForSaleUseCase>(
      () => GetReceiptForSaleUseCase(sl()),
    );
  }

  if (!sl.isRegistered<CreateSaleCubit>()) {
    sl.registerFactory<CreateSaleCubit>(
      () => CreateSaleCubit(createSaleUseCase: sl()),
    );
  }
  if (!sl.isRegistered<CreateSaleByCodeCubit>()) {
    sl.registerFactory<CreateSaleByCodeCubit>(
      () => CreateSaleByCodeCubit(createSaleByCodeUseCase: sl()),
    );
  }
  if (!sl.isRegistered<TodaySalesCubit>()) {
    sl.registerFactory<TodaySalesCubit>(
      () => TodaySalesCubit(
        getTodaySalesUseCase: sl(),
        getReceiptForSaleUseCase: sl(),
        deleteSaleUseCase: sl(),
      ),
    );
  }
}

void setupReportsDependencies({required DioClient dioClient}) {
  if (!sl.isRegistered<ReportsRemoteDataSource>()) {
    sl.registerLazySingleton<ReportsRemoteDataSource>(
      () => ReportsRemoteDataSource(dioClient.dio),
    );
  }

  if (!sl.isRegistered<ReportsRepository>()) {
    sl.registerLazySingleton<ReportsRepository>(
      () => ReportsRepositoryImpl(remoteDataSource: sl()),
    );
  }

  if (!sl.isRegistered<GetDailyReportUseCase>()) {
    sl.registerLazySingleton<GetDailyReportUseCase>(
      () => GetDailyReportUseCase(sl()),
    );
  }
  if (!sl.isRegistered<GetMonthlyReportUseCase>()) {
    sl.registerLazySingleton<GetMonthlyReportUseCase>(
      () => GetMonthlyReportUseCase(sl()),
    );
  }

  if (!sl.isRegistered<ReportsCubit>()) {
    sl.registerFactory<ReportsCubit>(
      () => ReportsCubit(
        getDailyReportUseCase: sl(),
        getMonthlyReportUseCase: sl(),
      ),
    );
  }
}

void setupWorkHoursDependencies({required DioClient dioClient}) {
  if (!sl.isRegistered<WorkHoursRemoteDataSource>()) {
    sl.registerLazySingleton<WorkHoursRemoteDataSource>(
      () => WorkHoursRemoteDataSource(dioClient.dio),
    );
  }

  if (!sl.isRegistered<WorkHoursRepository>()) {
    sl.registerLazySingleton<WorkHoursRepository>(
      () => WorkHoursRepositoryImpl(remoteDataSource: sl()),
    );
  }

  if (!sl.isRegistered<UpsertWorkDayUseCase>()) {
    sl.registerLazySingleton<UpsertWorkDayUseCase>(
      () => UpsertWorkDayUseCase(sl()),
    );
  }
  if (!sl.isRegistered<GetWorkHoursByDateUseCase>()) {
    sl.registerLazySingleton<GetWorkHoursByDateUseCase>(
      () => GetWorkHoursByDateUseCase(sl()),
    );
  }
  if (!sl.isRegistered<GetMonthlyWorkHoursUseCase>()) {
    sl.registerLazySingleton<GetMonthlyWorkHoursUseCase>(
      () => GetMonthlyWorkHoursUseCase(sl()),
    );
  }

  if (!sl.isRegistered<WorkHoursCubit>()) {
    sl.registerFactory<WorkHoursCubit>(
      () => WorkHoursCubit(
        upsertWorkDayUseCase: sl(),
        getWorkHoursByDateUseCase: sl(),
      ),
    );
  }
  if (!sl.isRegistered<MonthlyWorkHoursCubit>()) {
    sl.registerFactory<MonthlyWorkHoursCubit>(
      () => MonthlyWorkHoursCubit(getMonthlyWorkHoursUseCase: sl()),
    );
  }
}
