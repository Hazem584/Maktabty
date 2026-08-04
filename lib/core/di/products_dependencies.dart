import 'package:get_it/get_it.dart';
import 'package:maktabty/core/network/dio_client.dart';
import 'package:maktabty/features/products/data/datasources/products_remote_datasource.dart';
import 'package:maktabty/features/products/data/datasources/products_local_datasource.dart';
import 'package:maktabty/core/database/app_database.dart';
import 'package:maktabty/features/products/data/repositories/products_repository_impl.dart';
import 'package:maktabty/features/products/domain/repositories/products_repository.dart';
import 'package:maktabty/features/products/domain/usecases/create_product_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/archive_product_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/restore_product_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/get_product_by_code_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/get_products_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/update_product_usecase.dart';
import 'package:maktabty/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:maktabty/features/products/presentation/cubit/product_archive_cubit.dart';

void registerProductsDependencies(GetIt getIt) {
  if (!getIt.isRegistered<ProductsRemoteDataSource>()) {
    getIt.registerLazySingleton(
      () => ProductsRemoteDataSource(getIt<DioClient>().dio),
    );
  }
  if (!getIt.isRegistered<ProductsLocalDataSource>()) {
    getIt.registerLazySingleton(
      () => ProductsLocalDataSource(getIt<AppDatabase>()),
    );
  }
  if (!getIt.isRegistered<ProductsRepository>()) {
    getIt.registerLazySingleton<ProductsRepository>(
      () => ProductsRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
        currentUserStore: getIt(),
      ),
    );
  }
  if (!getIt.isRegistered<GetProductsUseCase>()) {
    getIt.registerLazySingleton(() => GetProductsUseCase(getIt()));
  }
  if (!getIt.isRegistered<GetProductByIdUseCase>()) {
    getIt.registerLazySingleton(() => GetProductByIdUseCase(getIt()));
  }
  if (!getIt.isRegistered<GetProductByCodeUseCase>()) {
    getIt.registerLazySingleton(() => GetProductByCodeUseCase(getIt()));
  }
  if (!getIt.isRegistered<CreateProductUseCase>()) {
    getIt.registerLazySingleton(() => CreateProductUseCase(getIt()));
  }
  if (!getIt.isRegistered<UpdateProductUseCase>()) {
    getIt.registerLazySingleton(() => UpdateProductUseCase(getIt()));
  }
  if (!getIt.isRegistered<ArchiveProductUseCase>()) {
    getIt.registerLazySingleton(() => ArchiveProductUseCase(getIt()));
  }
  if (!getIt.isRegistered<RestoreProductUseCase>()) {
    getIt.registerLazySingleton(() => RestoreProductUseCase(getIt()));
  }
  if (!getIt.isRegistered<ProductsListCubit>()) {
    getIt.registerFactory(
      () => ProductsListCubit(
        getProductsUseCase: getIt(),
      ),
    );
  }
  if (!getIt.isRegistered<ProductFormCubit>()) {
    getIt.registerFactory(
      () => ProductFormCubit(
        createProductUseCase: getIt(),
        updateProductUseCase: getIt(),
      ),
    );
  }
  if (!getIt.isRegistered<ProductDetailsCubit>()) {
    getIt.registerFactory(
      () => ProductDetailsCubit(
        getProductByIdUseCase: getIt(),
        getProductByCodeUseCase: getIt(),
      ),
    );
  }
  if (!getIt.isRegistered<ProductArchiveCubit>()) {
    getIt.registerFactory(
      () => ProductArchiveCubit(
        archiveProduct: getIt(),
        restoreProduct: getIt(),
        getProduct: getIt(),
      ),
    );
  }
}
