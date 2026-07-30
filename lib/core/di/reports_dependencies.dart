import 'package:get_it/get_it.dart';
import 'package:maktabty/core/network/dio_client.dart';
import 'package:maktabty/features/reports/data/datasources/reports_remote_datasource.dart';
import 'package:maktabty/features/reports/data/repositories/reports_repository_impl.dart';
import 'package:maktabty/features/reports/domain/repositories/reports_repository.dart';
import 'package:maktabty/features/reports/domain/usecases/get_daily_report.dart';
import 'package:maktabty/features/reports/domain/usecases/get_monthly_report.dart';
import 'package:maktabty/features/reports/presentation/cubit/reports_cubit.dart';

void registerReportsDependencies(GetIt getIt) {
  if (!getIt.isRegistered<ReportsRemoteDataSource>()) {
    getIt.registerLazySingleton(
      () => ReportsRemoteDataSource(getIt<DioClient>().dio),
    );
  }
  if (!getIt.isRegistered<ReportsRepository>()) {
    getIt.registerLazySingleton<ReportsRepository>(
      () => ReportsRepositoryImpl(remoteDataSource: getIt()),
    );
  }
  if (!getIt.isRegistered<GetDailyReportUseCase>()) {
    getIt.registerLazySingleton(() => GetDailyReportUseCase(getIt()));
  }
  if (!getIt.isRegistered<GetMonthlyReportUseCase>()) {
    getIt.registerLazySingleton(() => GetMonthlyReportUseCase(getIt()));
  }
  if (!getIt.isRegistered<ReportsCubit>()) {
    getIt.registerFactory(
      () => ReportsCubit(
        getDailyReportUseCase: getIt(),
        getMonthlyReportUseCase: getIt(),
      ),
    );
  }
}
