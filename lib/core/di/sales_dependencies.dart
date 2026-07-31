import 'package:get_it/get_it.dart';
import 'package:maktabty/core/network/dio_client.dart';
import 'package:maktabty/features/sales/data/datasources/sales_remote_datasource.dart';
import 'package:maktabty/features/sales/data/datasources/sales_local_datasource.dart';
import 'package:maktabty/features/sales/data/services/connectivity_sync_trigger.dart';
import 'package:maktabty/features/sales/data/services/sales_sync_coordinator.dart';
import 'package:maktabty/core/database/app_database.dart';
import 'package:maktabty/features/sales/data/repositories/sales_repository_impl.dart';
import 'package:maktabty/features/sales/domain/repositories/sales_repository.dart';
import 'package:maktabty/features/sales/domain/usecases/create_sale_by_code_usecase.dart';
import 'package:maktabty/features/sales/domain/usecases/create_sale_usecase.dart';
import 'package:maktabty/features/sales/domain/usecases/delete_sale_usecase.dart';
import 'package:maktabty/features/sales/domain/usecases/get_receipt_for_sale_usecase.dart';
import 'package:maktabty/features/sales/domain/usecases/get_today_sales_usecase.dart';
import 'package:maktabty/features/sales/presentation/cubit/create_sale_by_code_cubit.dart';
import 'package:maktabty/features/sales/presentation/cubit/create_sale_cubit.dart';
import 'package:maktabty/features/sales/presentation/cubit/today_sales_cubit.dart';
import 'package:maktabty/features/sales/presentation/cubit/offline_sales_cubit.dart';

void registerSalesDependencies(GetIt getIt) {
  if (!getIt.isRegistered<SalesRemoteDataSource>()) {
    getIt.registerLazySingleton(
      () => SalesRemoteDataSource(getIt<DioClient>().dio),
    );
  }
  if (!getIt.isRegistered<SalesLocalDataSource>()) {
    getIt.registerLazySingleton(
      () => SalesLocalDataSource(getIt<AppDatabase>()),
    );
  }
  if (!getIt.isRegistered<SalesSyncCoordinator>()) {
    getIt.registerLazySingleton(
      () => SalesSyncCoordinator(
        localDataSource: getIt(),
        remoteDataSource: getIt(),
      ),
    );
  }
  if (!getIt.isRegistered<ConnectivitySyncTrigger>()) {
    getIt.registerLazySingleton(
      () => ConnectivitySyncTrigger(coordinator: getIt()),
    );
  }
  if (!getIt.isRegistered<SalesRepository>()) {
    getIt.registerLazySingleton<SalesRepository>(
      () => SalesRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
        syncCoordinator: getIt(),
        currentUserStore: getIt(),
      ),
    );
  }
  if (!getIt.isRegistered<CreateSaleUseCase>()) {
    getIt.registerLazySingleton(() => CreateSaleUseCase(getIt()));
  }
  if (!getIt.isRegistered<CreateSaleByCodeUseCase>()) {
    getIt.registerLazySingleton(
      () => CreateSaleByCodeUseCase(getIt(), getIt()),
    );
  }
  if (!getIt.isRegistered<GetTodaySalesUseCase>()) {
    getIt.registerLazySingleton(() => GetTodaySalesUseCase(getIt()));
  }
  if (!getIt.isRegistered<DeleteSaleUseCase>()) {
    getIt.registerLazySingleton(() => DeleteSaleUseCase(getIt()));
  }
  if (!getIt.isRegistered<GetReceiptForSaleUseCase>()) {
    getIt.registerLazySingleton(() => GetReceiptForSaleUseCase(getIt()));
  }
  if (!getIt.isRegistered<CreateSaleCubit>()) {
    getIt.registerFactory(() => CreateSaleCubit(createSaleUseCase: getIt()));
  }
  if (!getIt.isRegistered<CreateSaleByCodeCubit>()) {
    getIt.registerFactory(
      () => CreateSaleByCodeCubit(createSaleByCodeUseCase: getIt()),
    );
  }
  if (!getIt.isRegistered<TodaySalesCubit>()) {
    getIt.registerFactory(
      () => TodaySalesCubit(
        getTodaySalesUseCase: getIt(),
        getReceiptForSaleUseCase: getIt(),
        deleteSaleUseCase: getIt(),
      ),
    );
  }
  if (!getIt.isRegistered<OfflineSalesCubit>()) {
    getIt.registerLazySingleton(
      () => OfflineSalesCubit(
        localDataSource: getIt(),
        coordinator: getIt(),
        connectivityTrigger: getIt(),
        currentUserStore: getIt(),
        getReceiptForSaleUseCase: getIt(),
      ),
    );
  }
}
