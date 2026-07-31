import 'package:get_it/get_it.dart';
import 'package:maktabty/core/database/app_database.dart';
import 'package:maktabty/core/session/current_user_store.dart';

void registerDatabaseDependencies(GetIt getIt) {
  if (!getIt.isRegistered<AppDatabase>()) {
    getIt.registerLazySingleton(AppDatabase.new);
  }
  if (!getIt.isRegistered<CurrentUserStore>()) {
    getIt.registerLazySingleton(CurrentUserStore.new);
  }
}
