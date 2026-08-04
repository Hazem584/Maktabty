import 'package:get_it/get_it.dart';
import 'package:maktabty/core/network/dio_client.dart';
import 'package:maktabty/features/cashiers/data/datasources/cashiers_remote_datasource.dart';
import 'package:maktabty/features/cashiers/data/repositories/cashiers_repository_impl.dart';
import 'package:maktabty/features/cashiers/domain/repositories/cashiers_repository.dart';
import 'package:maktabty/features/cashiers/domain/usecases/cashier_usecases.dart';
import 'package:maktabty/features/cashiers/presentation/cubit/cashier_details_cubit.dart';
import 'package:maktabty/features/cashiers/presentation/cubit/cashier_form_cubit.dart';
import 'package:maktabty/features/cashiers/presentation/cubit/cashier_password_cubit.dart';
import 'package:maktabty/features/cashiers/presentation/cubit/cashiers_list_cubit.dart';

void registerCashiersDependencies(GetIt getIt) {
  getIt.registerLazySingleton(() => CashiersRemoteDataSource(getIt<DioClient>().dio));
  getIt.registerLazySingleton<CashiersRepository>(() => CashiersRepositoryImpl(getIt()));
  getIt.registerLazySingleton(() => CashierUseCases(getIt()));
  getIt.registerFactory(() => CashiersListCubit(getIt()));
  getIt.registerFactory(() => CashierFormCubit(getIt()));
  getIt.registerFactory(() => CashierDetailsCubit(getIt()));
  getIt.registerFactory(() => CashierPasswordCubit(getIt()));
}
