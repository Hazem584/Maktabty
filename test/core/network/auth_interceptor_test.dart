import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/network/auth_interceptor.dart';
import 'package:maktabty/core/network/auth_session_manager.dart';
import 'package:maktabty/core/storage/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenStorage extends Mock implements TokenStorage {}

class CallbackHttpClientAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) callback;

  CallbackHttpClientAdapter(this.callback);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return callback(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonResponse(int status, Object body) {
  return ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

void main() {
  late MockTokenStorage storage;
  late AuthSessionManager sessionManager;
  late String? accessToken;
  late String? refreshToken;
  late int clearCount;

  setUp(() {
    storage = MockTokenStorage();
    sessionManager = AuthSessionManager();
    accessToken = 'old-access';
    refreshToken = 'refresh-token';
    clearCount = 0;

    when(() => storage.getAccessToken()).thenAnswer((_) async => accessToken);
    when(() => storage.getRefreshToken()).thenAnswer((_) async => refreshToken);
    when(() => storage.saveAccessToken(any())).thenAnswer((invocation) async {
      accessToken = invocation.positionalArguments.single as String;
    });
    when(() => storage.saveRefreshToken(any())).thenAnswer((invocation) async {
      refreshToken = invocation.positionalArguments.single as String;
    });
    when(() => storage.clearAll()).thenAnswer((_) async {
      clearCount++;
      accessToken = null;
      refreshToken = null;
    });
  });

  tearDown(() async {
    await sessionManager.dispose();
  });

  ({Dio client, Dio refreshClient}) createClients(
    Future<ResponseBody> Function(RequestOptions options) handler,
  ) {
    final options = BaseOptions(baseUrl: 'https://api.maktabty.test');
    final adapter = CallbackHttpClientAdapter(handler);
    final client = Dio(options)..httpClientAdapter = adapter;
    final refreshClient = Dio(options)..httpClientAdapter = adapter;
    client.interceptors.add(
      AuthInterceptor(
        tokenStorage: storage,
        refreshDio: refreshClient,
        sessionManager: sessionManager,
      ),
    );
    return (client: client, refreshClient: refreshClient);
  }

  Future<void> establishNewSession() async {
    await sessionManager.establishSession(() async {
      await storage.saveAccessToken('new-session-access');
      await storage.saveRefreshToken('new-session-refresh');
    });
  }

  test('concurrent 401 responses share one refresh and both retry', () async {
    var refreshCalls = 0;
    var protectedCalls = 0;
    final clients = createClients((options) async {
      if (options.uri.path == '/auth/refresh') {
        refreshCalls++;
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return jsonResponse(200, {
          'data': {'accessToken': 'new-access', 'refreshToken': 'new-refresh'},
        });
      }
      protectedCalls++;
      if (options.headers['Authorization'] == 'Bearer new-access') {
        return jsonResponse(200, {'ok': true});
      }
      return jsonResponse(401, {'message': 'Unauthorized'});
    });

    final responses = await Future.wait([
      clients.client.get<dynamic>('/protected/one'),
      clients.client.get<dynamic>('/protected/two'),
    ]);

    expect(responses.every((response) => response.statusCode == 200), isTrue);
    expect(refreshCalls, 1);
    expect(protectedCalls, 4);
    expect(accessToken, 'new-access');
    expect(refreshToken, 'new-refresh');
    expect(clearCount, 0);
  });

  test('temporary refresh failure preserves the stored session', () async {
    var refreshCalls = 0;
    final clients = createClients((options) async {
      if (options.uri.path == '/auth/refresh') {
        refreshCalls++;
        return jsonResponse(503, {'message': 'Unavailable'});
      }
      return jsonResponse(401, {'message': 'Unauthorized'});
    });

    await expectLater(
      clients.client.get<dynamic>('/protected'),
      throwsA(isA<DioException>()),
    );

    expect(refreshCalls, 1);
    expect(clearCount, 0);
    expect(refreshToken, 'refresh-token');
  });

  test('invalid refresh credentials clear and expire the session', () async {
    final expiredEvent = sessionManager.stream.first;
    final clients = createClients((options) async {
      if (options.uri.path == '/auth/refresh') {
        return jsonResponse(401, {'message': 'Invalid refresh token'});
      }
      return jsonResponse(401, {'message': 'Unauthorized'});
    });

    await expectLater(
      clients.client.get<dynamic>('/protected'),
      throwsA(isA<DioException>()),
    );

    expect((await expiredEvent).type, AuthSessionEventType.expired);
    expect(clearCount, 1);
    expect(accessToken, isNull);
    expect(refreshToken, isNull);
  });

  test(
    'a retried 401 expires the session and is never retried twice',
    () async {
      var refreshCalls = 0;
      var protectedCalls = 0;
      final expiredEvent = sessionManager.stream.first;
      final clients = createClients((options) async {
        if (options.uri.path == '/auth/refresh') {
          refreshCalls++;
          return jsonResponse(200, {'accessToken': 'new-access'});
        }
        protectedCalls++;
        return jsonResponse(401, {'message': 'Unauthorized'});
      });

      await expectLater(
        clients.client.get<dynamic>('/protected'),
        throwsA(isA<DioException>()),
      );

      expect((await expiredEvent).type, AuthSessionEventType.expired);
      expect(refreshCalls, 1);
      expect(protectedCalls, 2);
      expect(clearCount, 1);
    },
  );

  test('retry preserves method, query, headers, and body', () async {
    RequestOptions? retried;
    var protectedCalls = 0;
    final clients = createClients((options) async {
      if (options.uri.path == '/auth/refresh') {
        return jsonResponse(200, {
          'tokens': {'access_token': 'new-access'},
        });
      }
      protectedCalls++;
      if (protectedCalls == 2) {
        retried = options;
        return jsonResponse(200, {'ok': true});
      }
      return jsonResponse(401, {'message': 'Unauthorized'});
    });

    await clients.client.post<dynamic>(
      '/protected',
      queryParameters: {'page': 2},
      data: {'name': 'safe-value'},
      options: Options(headers: {'X-Request-ID': 'request-1'}),
    );

    expect(retried?.method, 'POST');
    expect(retried?.queryParameters, {'page': 2});
    expect(retried?.headers['X-Request-ID'], 'request-1');
    expect(retried?.data, {'name': 'safe-value'});
    expect(retried?.extra['authRetryCount'], 1);
  });

  test('ACCOUNT_DISABLED bypasses refresh and expires current session', () async {
    var refreshCalls = 0;
    final sessionEvent = sessionManager.stream.first;
    final clients = createClients((options) async {
      if (options.uri.path == '/auth/refresh') {
        refreshCalls++;
      }
      return jsonResponse(403, {
        'statusCode': 403,
        'code': 'ACCOUNT_DISABLED',
      });
    });

    await expectLater(
      clients.client.get<dynamic>('/protected'),
      throwsA(isA<DioException>()),
    );

    final event = await sessionEvent;
    expect(event.type, AuthSessionEventType.accountDisabled);
    expect(event.failure, isA<AccountDisabledFailure>());
    expect(refreshCalls, 0);
    expect(clearCount, 1);
  });

  test('generic 403 neither refreshes nor invalidates the session', () async {
    var refreshCalls = 0;
    final clients = createClients((options) async {
      if (options.uri.path == '/auth/refresh') refreshCalls++;
      return jsonResponse(403, {'message': 'Forbidden'});
    });

    await expectLater(
      clients.client.get<dynamic>('/protected'),
      throwsA(isA<DioException>()),
    );

    expect(refreshCalls, 0);
    expect(clearCount, 0);
    expect(accessToken, 'old-access');
  });

  test('late 401 from old generation cannot clear newer tokens', () async {
    final requestStarted = Completer<void>();
    final releaseRequest = Completer<void>();
    var refreshCalls = 0;
    final clients = createClients((options) async {
      if (options.uri.path == '/auth/refresh') {
        refreshCalls++;
      }
      requestStarted.complete();
      await releaseRequest.future;
      return jsonResponse(401, {'message': 'Unauthorized'});
    });

    final oldRequest = clients.client.get<dynamic>('/protected');
    await requestStarted.future;
    await establishNewSession();
    releaseRequest.complete();

    await expectLater(oldRequest, throwsA(isA<DioException>()));
    expect(refreshCalls, 0);
    expect(clearCount, 0);
    expect(accessToken, 'new-session-access');
    expect(refreshToken, 'new-session-refresh');
  });

  test('late disabled response cannot log out a newer session', () async {
    final requestStarted = Completer<void>();
    final releaseRequest = Completer<void>();
    final clients = createClients((options) async {
      requestStarted.complete();
      await releaseRequest.future;
      return jsonResponse(403, {'code': 'ACCOUNT_DISABLED'});
    });

    final oldRequest = clients.client.get<dynamic>('/protected');
    await requestStarted.future;
    await establishNewSession();
    releaseRequest.complete();

    await expectLater(oldRequest, throwsA(isA<DioException>()));
    expect(clearCount, 0);
    expect(accessToken, 'new-session-access');
    expect(refreshToken, 'new-session-refresh');
  });

  test('old refresh failure cannot expire a newer session', () async {
    final refreshStarted = Completer<void>();
    final releaseRefresh = Completer<void>();
    final clients = createClients((options) async {
      if (options.uri.path == '/auth/refresh') {
        refreshStarted.complete();
        await releaseRefresh.future;
        return jsonResponse(401, {'message': 'Invalid refresh token'});
      }
      return jsonResponse(401, {'message': 'Unauthorized'});
    });

    final oldRequest = clients.client.get<dynamic>('/protected');
    await refreshStarted.future;
    await establishNewSession();
    releaseRefresh.complete();

    await expectLater(oldRequest, throwsA(isA<DioException>()));
    expect(clearCount, 0);
    expect(accessToken, 'new-session-access');
    expect(refreshToken, 'new-session-refresh');
  });

  test('old refresh success cannot overwrite newer tokens', () async {
    final refreshStarted = Completer<void>();
    final releaseRefresh = Completer<void>();
    final clients = createClients((options) async {
      if (options.uri.path == '/auth/refresh') {
        refreshStarted.complete();
        await releaseRefresh.future;
        return jsonResponse(200, {
          'accessToken': 'stale-refreshed-access',
          'refreshToken': 'stale-refreshed-refresh',
        });
      }
      return jsonResponse(401, {'message': 'Unauthorized'});
    });

    final oldRequest = clients.client.get<dynamic>('/protected');
    await refreshStarted.future;
    await establishNewSession();
    releaseRefresh.complete();

    await expectLater(oldRequest, throwsA(isA<DioException>()));
    expect(clearCount, 0);
    expect(accessToken, 'new-session-access');
    expect(refreshToken, 'new-session-refresh');
  });

  test('disabled refresh emits disabled reason and clears once', () async {
    final sessionEvent = sessionManager.stream.first;
    final clients = createClients((options) async {
      if (options.uri.path == '/auth/refresh') {
        return jsonResponse(403, {'code': 'ACCOUNT_DISABLED'});
      }
      return jsonResponse(401, {'message': 'Unauthorized'});
    });

    await expectLater(
      clients.client.get<dynamic>('/protected'),
      throwsA(isA<DioException>()),
    );

    final event = await sessionEvent;
    expect(event.type, AuthSessionEventType.accountDisabled);
    expect(clearCount, 1);
  });

  test('public auth endpoints never receive an Authorization header', () async {
    RequestOptions? captured;
    final clients = createClients((options) async {
      captured = options;
      return jsonResponse(200, {'ok': true});
    });

    await clients.client.post<dynamic>(
      '/auth/login',
      data: {'email': 'owner@example.com', 'password': 'secret'},
    );

    expect(captured?.headers.containsKey('Authorization'), isFalse);
  });
}
