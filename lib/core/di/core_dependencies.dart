import 'package:get_it/get_it.dart';
import 'package:maktabty/core/config/api_config.dart';
import 'package:maktabty/core/localization/locale_cubit.dart';
import 'package:maktabty/core/localization/locale_storage.dart';
import 'package:maktabty/core/network/auth_session_manager.dart';
import 'package:maktabty/core/network/dio_client.dart';
import 'package:maktabty/core/storage/token_storage.dart';

void registerCoreDependencies(GetIt getIt, {required ApiConfig apiConfig}) {
  if (!getIt.isRegistered<LocaleStorage>()) {
    getIt.registerLazySingleton(LocaleStorage.new);
  }
  if (!getIt.isRegistered<LocaleCubit>()) {
    getIt.registerLazySingleton(() => LocaleCubit(storage: getIt()));
  }
  if (!getIt.isRegistered<TokenStorage>()) {
    getIt.registerLazySingleton(TokenStorage.new);
  }
  if (!getIt.isRegistered<AuthSessionManager>()) {
    getIt.registerLazySingleton(AuthSessionManager.new);
  }
  if (!getIt.isRegistered<DioClient>()) {
    getIt.registerLazySingleton(
      () => DioClient(
        tokenStorage: getIt(),
        sessionManager: getIt(),
        baseUrl: apiConfig.baseUrl,
      ),
    );
  }
}
