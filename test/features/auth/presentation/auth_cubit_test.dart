import 'package:flutter_test/flutter_test.dart';
import 'package:maktabty/core/network/api_exceptions.dart';
import 'package:maktabty/core/network/auth_session_manager.dart';
import 'package:maktabty/core/storage/token_storage.dart';
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
        const ApiException(
          'No internet connection. Please try again.',
          kind: ApiErrorKind.network,
        ),
      );

      await cubit.initialize();

      expect(cubit.state.status, AuthStatus.startupFailure);
      verifyNever(() => storage.clearAll());
    },
  );

  test('invalid refresh credentials clear the stored session', () async {
    when(() => storage.getRefreshToken()).thenAnswer((_) async => 'refresh');
    when(() => refresh()).thenThrow(
      const ApiException(
        'Unauthorized',
        statusCode: 401,
        kind: ApiErrorKind.unauthorized,
      ),
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
        const ApiException(
          'Server unavailable',
          statusCode: 503,
          kind: ApiErrorKind.server,
        ),
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
        throw const ApiException('Offline', kind: ApiErrorKind.network);
      }
      return const UserEntity(
        id: 'u1',
        email: 'owner@example.com',
        fullName: 'Owner',
        role: 'owner',
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
