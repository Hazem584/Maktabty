import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/routes/app_navigator.dart';
import 'package:maktabty/core/routes/auth_navigation_coordinator.dart';
import 'package:maktabty/features/auth/domain/entities/user_entity.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_state.dart';
import 'package:maktabty/features/auth/presentation/pages/auth_gate_screen.dart';
import 'package:maktabty/features/auth/presentation/pages/login_screen.dart';
import 'package:maktabty/l10n/gen/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

class RecordingNavigatorObserver extends NavigatorObserver {
  int pushCount = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushCount++;
    super.didPush(route, previousRoute);
  }
}

void main() {
  late MockAuthCubit cubit;
  late StreamController<AuthState> states;
  late AuthState currentState;

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    cubit = MockAuthCubit();
    states = StreamController<AuthState>.broadcast();
    currentState = AuthState.unauthenticated();
    when(() => cubit.state).thenAnswer((_) => currentState);
    when(() => cubit.stream).thenAnswer((_) => states.stream);
  });

  tearDown(() async {
    await states.close();
    debugDefaultTargetPlatformOverride = null;
  });

  Widget app(
    Widget home, {
    NavigatorObserver? observer,
    Locale locale = const Locale('en'),
  }) {
    return BlocProvider<AuthCubit>.value(
      value: cubit,
      child: MaterialApp(
        navigatorKey: AppNavigator.key,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        navigatorObservers: [if (observer != null) observer],
        home: home,
      ),
    );
  }

  Future<void> emitState(
    WidgetTester tester,
    AuthState state, {
    bool coordinate = false,
  }) async {
    if (coordinate) AuthNavigationCoordinator.handle(state);
    currentState = state;
    states.add(state);
    await tester.pump();
  }

  testWidgets('one successful login submission displays authenticated home', (
    tester,
  ) async {
    when(
      () => cubit.login(
        email: 'cashier@example.com',
        password: 'password123',
      ),
    ).thenAnswer((_) async {});
    await tester.pumpWidget(
      app(
        const AuthGateScreen(
          authenticatedChild: Scaffold(body: Text('authenticated-home')),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1400));

    await tester.enterText(
      find.byType(TextField).at(0),
      'cashier@example.com',
    );
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.tap(find.text('Sign in'));
    await tester.pump();

    verify(
      () => cubit.login(
        email: 'cashier@example.com',
        password: 'password123',
      ),
    ).called(1);

    await emitState(
      tester,
      AuthState.authenticated(
        const UserEntity(
          id: 'cashier-1',
          email: 'cashier@example.com',
          fullName: 'Cashier',
          role: 'CASHIER',
          storeId: 'store-1',
          isActive: true,
        ),
      ),
    );

    expect(find.text('authenticated-home'), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('LoginScreen authentication success does not push a route', (
    tester,
  ) async {
    final observer = RecordingNavigatorObserver();
    await tester.pumpWidget(app(const LoginScreen(), observer: observer));
    final initialPushCount = observer.pushCount;

    await emitState(
      tester,
      AuthState.authenticated(
        const UserEntity(
          id: 'cashier-1',
          email: 'cashier@example.com',
          fullName: 'Cashier',
          role: 'CASHIER',
          storeId: 'store-1',
          isActive: true,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(observer.pushCount, initialPushCount);
  });

  testWidgets('authentication coordinator resets a nested stack only once', (
    tester,
  ) async {
    final observer = RecordingNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: AppNavigator.key,
        navigatorObservers: [observer],
        home: const Scaffold(body: Text('root-auth-gate')),
        routes: {
          '/nested': (_) => const Scaffold(body: Text('nested-page')),
        },
      ),
    );
    unawaited(AppNavigator.key.currentState!.pushNamed<void>('/nested'));
    await tester.pumpAndSettle();

    AuthNavigationCoordinator.handle(
      AuthState.authenticated(
        const UserEntity(
          id: 'cashier-1',
          email: 'cashier@example.com',
          fullName: 'Cashier',
          role: 'CASHIER',
          storeId: 'store-1',
          isActive: true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final pushesAfterReset = observer.pushCount;

    AuthNavigationCoordinator.handle(currentState);
    await tester.pump();

    expect(find.text('root-auth-gate'), findsOneWidget);
    expect(find.text('nested-page'), findsNothing);
    expect(observer.pushCount, pushesAfterReset);
  });

  testWidgets('disabled login displays the localized message once', (
    tester,
  ) async {
    await tester.pumpWidget(app(const LoginScreen()));

    await emitState(
      tester,
      AuthState.failure(const AccountDisabledFailure()),
    );

    expect(
      find.text(
        'This account is disabled. Contact your store owner to reactivate it.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('disabled login displays the Arabic localized message once', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(const LoginScreen(), locale: const Locale('ar')),
    );

    await emitState(
      tester,
      AuthState.failure(const AccountDisabledFailure()),
    );

    expect(
      find.text(
        'تم إيقاف حسابك. تواصل مع مالك المتجر لإعادة تفعيله.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('disabled active session returns to login and reports once', (
    tester,
  ) async {
    currentState = AuthState.authenticated(
      const UserEntity(
        id: 'cashier-1',
        email: 'cashier@example.com',
        fullName: 'Cashier',
        role: 'CASHIER',
        storeId: 'store-1',
        isActive: true,
      ),
    );
    await tester.pumpWidget(
      app(
        const AuthGateScreen(
          authenticatedChild: Scaffold(body: Text('authenticated-home')),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1400));

    await emitState(
      tester,
      AuthState.unauthenticated(
        failure: const AccountDisabledFailure(),
      ),
      coordinate: true,
    );

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(
      find.text(
        'This account is disabled. Contact your store owner to reactivate it.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('ordinary expiration keeps the existing localized message', (
    tester,
  ) async {
    await tester.pumpWidget(app(const AuthGateScreen()));
    await tester.pump(const Duration(milliseconds: 1400));

    await emitState(
      tester,
      AuthState.unauthenticated(failure: const UnauthorizedFailure()),
      coordinate: true,
    );

    expect(
      find.text('Session expired. Please sign in again.'),
      findsOneWidget,
    );
  });
}
