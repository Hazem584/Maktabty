import 'package:get_it/get_it.dart';
import 'package:maktabty/core/network/dio_client.dart';
import 'package:maktabty/features/work_hours/data/datasources/work_hours_remote_datasource.dart';
import 'package:maktabty/features/work_hours/data/repositories/work_hours_repository_impl.dart';
import 'package:maktabty/features/work_hours/domain/repositories/work_hours_repository.dart';
import 'package:maktabty/features/work_hours/domain/usecases/get_monthly_work_hours.dart';
import 'package:maktabty/features/work_hours/domain/usecases/get_work_hours_by_date.dart';
import 'package:maktabty/features/work_hours/domain/usecases/upsert_work_day.dart';
import 'package:maktabty/features/work_hours/presentation/cubit/monthly_work_hours_cubit.dart';
import 'package:maktabty/features/work_hours/presentation/cubit/work_hours_cubit.dart';

void registerWorkHoursDependencies(GetIt getIt) {
  if (!getIt.isRegistered<WorkHoursRemoteDataSource>()) {
    getIt.registerLazySingleton(
      () => WorkHoursRemoteDataSource(getIt<DioClient>().dio),
    );
  }
  if (!getIt.isRegistered<WorkHoursRepository>()) {
    getIt.registerLazySingleton<WorkHoursRepository>(
      () => WorkHoursRepositoryImpl(remoteDataSource: getIt()),
    );
  }
  if (!getIt.isRegistered<UpsertWorkDayUseCase>()) {
    getIt.registerLazySingleton(() => UpsertWorkDayUseCase(getIt()));
  }
  if (!getIt.isRegistered<GetWorkHoursByDateUseCase>()) {
    getIt.registerLazySingleton(() => GetWorkHoursByDateUseCase(getIt()));
  }
  if (!getIt.isRegistered<GetMonthlyWorkHoursUseCase>()) {
    getIt.registerLazySingleton(() => GetMonthlyWorkHoursUseCase(getIt()));
  }
  if (!getIt.isRegistered<WorkHoursCubit>()) {
    getIt.registerFactory(
      () => WorkHoursCubit(
        upsertWorkDayUseCase: getIt(),
        getWorkHoursByDateUseCase: getIt(),
      ),
    );
  }
  if (!getIt.isRegistered<MonthlyWorkHoursCubit>()) {
    getIt.registerFactory(
      () => MonthlyWorkHoursCubit(getMonthlyWorkHoursUseCase: getIt()),
    );
  }
}
