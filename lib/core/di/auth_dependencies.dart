import 'package:get_it/get_it.dart';
import 'package:maktabty/core/network/auth_session_manager.dart';
import 'package:maktabty/core/network/dio_client.dart';
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

void registerAuthDependencies(GetIt getIt) {
  if (!getIt.isRegistered<AuthRemoteDataSource>()) {
    getIt.registerLazySingleton(
      () => AuthRemoteDataSource(
        getIt<DioClient>().dio,
        getIt<DioClient>().refreshDio,
      ),
    );
  }
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () =>
          AuthRepositoryImpl(remoteDataSource: getIt(), tokenStorage: getIt()),
    );
  }
  if (!getIt.isRegistered<LoginUseCase>()) {
    getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  }
  if (!getIt.isRegistered<RegisterUseCase>()) {
    getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  }
  if (!getIt.isRegistered<LogoutUseCase>()) {
    getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  }
  if (!getIt.isRegistered<GetMeUseCase>()) {
    getIt.registerLazySingleton(() => GetMeUseCase(getIt()));
  }
  if (!getIt.isRegistered<RefreshUseCase>()) {
    getIt.registerLazySingleton(() => RefreshUseCase(getIt()));
  }
  if (!getIt.isRegistered<AuthCubit>()) {
    // Authentication owns the app-wide session subscription.
    getIt.registerLazySingleton(
      () => AuthCubit(
        loginUseCase: getIt(),
        registerUseCase: getIt(),
        logoutUseCase: getIt(),
        getMeUseCase: getIt(),
        refreshUseCase: getIt(),
        tokenStorage: getIt<TokenStorage>(),
        sessionManager: getIt<AuthSessionManager>(),
      ),
    );
  }
}
