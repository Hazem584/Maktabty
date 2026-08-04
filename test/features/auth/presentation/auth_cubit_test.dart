import 'package:flutter_test/flutter_test.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/network/auth_session_manager.dart';
import 'package:maktabty/core/storage/token_storage.dart';
import 'package:maktabty/features/auth/domain/entities/auth_result_entity.dart';
import 'package:maktabty/features/auth/domain/entities/user_entity.dart';
import 'package:maktabty/features/auth/domain/usecases/get_me_usecase.dart';
import 'package:maktabty/features/auth/domain/usecases/login_usecase.dart';
import 'package:maktabty/features/auth/domain/usecases/logout_usecase.dart';
import 'package:maktabty/features/auth/domain/usecases/refresh_usecase.dart';
import 'package:maktabty/features/auth/domain/usecases/register_usecase.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_state.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockGetMeUseCase extends Mock implements GetMeUseCase {}

class MockRefreshUseCase extends Mock implements RefreshUseCase {}

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late MockLoginUseCase login;
  late MockRegisterUseCase register;
  late MockLogoutUseCase logout;
  late MockGetMeUseCase getMe;
  late MockRefreshUseCase refresh;
  late MockTokenStorage storage;
  late AuthSessionManager sessionManager;
  late AuthCubit cubit;

  setUp(() {
    login = MockLoginUseCase();
    register = MockRegisterUseCase();
    logout = MockLogoutUseCase();
    getMe = MockGetMeUseCase();
    refresh = MockRefreshUseCase();
    storage = MockTokenStorage();
    sessionManager = AuthSessionManager();
    when(() => storage.clearAll()).thenAnswer((_) async {});
    cubit = AuthCubit(
      loginUseCase: login,
      registerUseCase: register,
      logoutUseCase: logout,
      getMeUseCase: getMe,
      refreshUseCase: refresh,
      tokenStorage: storage,
      sessionManager: sessionManager,
    );
  });

  tearDown(() async {
    await cubit.close();
    sessionManager.dispose();
  });

  test(
    'offline startup preserves stored tokens and exposes retry state',
    () async {
      when(() => storage.getRefreshToken()).thenAnswer((_) async => 'refresh');
      when(() => refresh()).thenThrow(
        const NetworkFailure(),
      );

      await cubit.initialize();

      expect(cubit.state.status, AuthStatus.startupFailure);
      verifyNever(() => storage.clearAll());
    },
  );

  test('invalid refresh credentials clear the stored session', () async {
    when(() => storage.getRefreshToken()).thenAnswer((_) async => 'refresh');
    when(() => refresh()).thenThrow(
      const UnauthorizedFailure(),
    );

    await cubit.initialize();

    expect(cubit.state.status, AuthStatus.unauthenticated);
    verify(() => storage.clearAll()).called(1);
  });

  test(
    'temporary server refresh failure preserves the stored session',
    () async {
      when(() => storage.getRefreshToken()).thenAnswer((_) async => 'refresh');
      when(() => refresh()).thenThrow(
        const ServerFailure(statusCode: 503),
      );

      await cubit.initialize();

      expect(cubit.state.status, AuthStatus.startupFailure);
      verifyNever(() => storage.clearAll());
    },
  );

  test('retry succeeds without restarting the application', () async {
    when(() => storage.getRefreshToken()).thenAnswer((_) async => 'refresh');
    var calls = 0;
    when(() => refresh()).thenAnswer((_) async {
      calls++;
      if (calls == 1) {
        throw const NetworkFailure();
      }
      return const AuthResultEntity(
        user: UserEntity(
          id: 'u1',
          email: 'owner@example.com',
          fullName: 'Owner',
          role: 'owner',
          storeId: 'store-1',
          isActive: true,
        ),
      );
    });

    await cubit.initialize();
    await cubit.retryInitialization();

    expect(cubit.state.status, AuthStatus.authenticated);
    verifyNever(() => storage.clearAll());
  });

  test('logout success always reaches unauthenticated state', () async {
    when(() => logout()).thenAnswer((_) async {});

    await cubit.logout();

    expect(cubit.state.status, AuthStatus.unauthenticated);
  });

  test('old cached identity without store membership is never authenticated', () async {
    when(() => storage.getRefreshToken()).thenAnswer((_) async => 'refresh');
    when(() => refresh()).thenThrow(const NetworkFailure());
    when(() => storage.getUserIdentity()).thenAnswer(
      (_) async => const StoredUserIdentity(
        id: 'u1',
        email: 'owner@example.com',
        fullName: 'Owner',
        role: 'OWNER',
        storeId: null,
        isActive: null,
      ),
    );

    await cubit.initialize();

    expect(cubit.state.status, AuthStatus.startupFailure);
    expect(cubit.state.user, isNull);
  });

  test('global expired-session event clears authenticated state', () async {
    sessionManager.notifySessionExpired();
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.status, AuthStatus.unauthenticated);
    expect(cubit.state.failure, isA<UnauthorizedFailure>());
  });

  test('successful interceptor refresh reloads the trusted current user', () async {
    when(() => login(email: 'owner@example.com', password: 'password123')).thenAnswer(
      (_) async => const AuthResultEntity(
        user: UserEntity(id: 'u1', email: 'owner@example.com', fullName: 'Owner', role: 'OWNER', storeId: 'store-1', isActive: true),
      ),
    );
    when(() => getMe()).thenAnswer(
      (_) async => const UserEntity(id: 'u1', email: 'owner@example.com', fullName: 'Updated Owner', role: 'OWNER', storeId: 'store-1', isActive: true),
    );
    await cubit.login(email: 'owner@example.com', password: 'password123');
    sessionManager.notifySessionRefreshed();
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.user?.fullName, 'Updated Owner');
  });

  test(
    'logout failure clears locally and never leaves loading state',
    () async {
      when(() => logout()).thenThrow(Exception('backend unavailable'));

      await cubit.logout();

      expect(cubit.state.status, AuthStatus.unauthenticated);
      verify(() => storage.clearAll()).called(1);
    },
  );
}
