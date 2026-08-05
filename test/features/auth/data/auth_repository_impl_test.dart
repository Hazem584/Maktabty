import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/network/auth_session_manager.dart';
import 'package:maktabty/core/storage/token_storage.dart';
import 'package:maktabty/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:maktabty/features/auth/data/models/auth_response_model.dart';
import 'package:maktabty/features/auth/data/models/user_model.dart';
import 'package:maktabty/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock
    implements AuthRemoteDataSource {}

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late MockAuthRemoteDataSource remote;
  late MockTokenStorage storage;
  late AuthSessionManager sessionManager;
  late AuthRepositoryImpl repository;

  const response = AuthResponseModel(
    user: UserModel(
      id: 'cashier-1',
      email: 'cashier@example.com',
      fullName: 'Cashier',
      role: 'CASHIER',
      storeId: 'store-1',
      isActive: true,
    ),
    accessToken: 'new-access',
    refreshToken: 'new-refresh',
    tokenType: 'Bearer',
  );

  setUp(() {
    remote = MockAuthRemoteDataSource();
    storage = MockTokenStorage();
    sessionManager = AuthSessionManager();
    repository = AuthRepositoryImpl(
      remoteDataSource: remote,
      tokenStorage: storage,
      sessionManager: sessionManager,
    );
  });

  tearDown(() async {
    await sessionManager.dispose();
  });

  test('disabled login preserves AccountDisabledFailure', () async {
    when(
      () => remote.login(
        email: 'cashier@example.com',
        password: 'password123',
      ),
    ).thenThrow(_responseError(403, {'code': 'ACCOUNT_DISABLED'}));

    await expectLater(
      repository.login(
        email: 'cashier@example.com',
        password: 'password123',
      ),
      throwsA(isA<AccountDisabledFailure>()),
    );
  });

  test('invalid credentials keep the existing validation failure', () async {
    when(
      () => remote.login(
        email: 'cashier@example.com',
        password: 'wrong-password',
      ),
    ).thenThrow(_responseError(401, {'message': 'Invalid credentials'}));

    await expectLater(
      repository.login(
        email: 'cashier@example.com',
        password: 'wrong-password',
      ),
      throwsA(
        isA<ValidationFailure>().having(
          (failure) => failure.code,
          'code',
          FailureCode.invalidCredentials,
        ),
      ),
    );
  });

  test('successful login establishes generation before token writes', () async {
    final writes = <String>[];
    when(
      () => remote.login(
        email: 'cashier@example.com',
        password: 'password123',
      ),
    ).thenAnswer((_) async => response);
    when(() => storage.saveAccessToken(any())).thenAnswer((_) async {
      writes.add('access:${sessionManager.currentGeneration}');
    });
    when(() => storage.saveRefreshToken(any())).thenAnswer((_) async {
      writes.add('refresh:${sessionManager.currentGeneration}');
    });

    final result = await repository.login(
      email: 'cashier@example.com',
      password: 'password123',
    );

    expect(result.user.id, 'cashier-1');
    expect(sessionManager.currentGeneration, 1);
    expect(writes, ['access:1', 'refresh:1']);
  });

  test('explicit logout invalidates generation before server work', () async {
    final operations = <String>[];
    await sessionManager.establishSession(() async {});
    when(() => storage.getRefreshToken()).thenAnswer((_) async {
      operations.add('refresh-read:${sessionManager.currentGeneration}');
      return 'refresh';
    });
    when(() => storage.getAccessToken()).thenAnswer((_) async {
      operations.add('access-read:${sessionManager.currentGeneration}');
      return 'access';
    });
    when(() => storage.clearAll()).thenAnswer((_) async {
      operations.add('clear:${sessionManager.currentGeneration}');
    });
    when(
      () => remote.logout(
        refreshToken: 'refresh',
        accessToken: 'access',
      ),
    ).thenAnswer((_) async {
      operations.add('remote:${sessionManager.currentGeneration}');
    });

    await repository.logout();

    expect(sessionManager.currentGeneration, 2);
    expect(operations, [
      'refresh-read:2',
      'access-read:2',
      'clear:2',
      'remote:2',
    ]);
  });

  test('late startup refresh cannot overwrite a newer login session', () async {
    var accessToken = 'old-access';
    var refreshToken = 'old-refresh';
    final refreshStarted = Completer<void>();
    final releaseRefresh = Completer<void>();
    when(() => storage.getRefreshToken()).thenAnswer((_) async => refreshToken);
    when(() => storage.saveAccessToken(any())).thenAnswer((invocation) async {
      accessToken = invocation.positionalArguments.single as String;
    });
    when(() => storage.saveRefreshToken(any())).thenAnswer((invocation) async {
      refreshToken = invocation.positionalArguments.single as String;
    });
    when(
      () => remote.refresh(refreshToken: 'old-refresh'),
    ).thenAnswer((_) async {
      refreshStarted.complete();
      await releaseRefresh.future;
      return response;
    });

    final oldRefresh = repository.refresh();
    await refreshStarted.future;
    await sessionManager.establishSession(() async {
      await storage.saveAccessToken('new-login-access');
      await storage.saveRefreshToken('new-login-refresh');
    });
    releaseRefresh.complete();

    await expectLater(oldRefresh, throwsA(isA<UnknownFailure>()));
    expect(accessToken, 'new-login-access');
    expect(refreshToken, 'new-login-refresh');
  });
}

DioException _responseError(int statusCode, Object data) {
  final options = RequestOptions(path: '/auth/login');
  return DioException(
    requestOptions: options,
    response: Response<dynamic>(
      requestOptions: options,
      statusCode: statusCode,
      data: data,
    ),
    type: DioExceptionType.badResponse,
  );
}
