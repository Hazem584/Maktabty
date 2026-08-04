import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maktabty/core/routes/auth_guard.dart';
import 'package:maktabty/features/auth/domain/entities/user_entity.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_state.dart';
import 'package:maktabty/l10n/gen/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

Widget _app(AuthCubit cubit, Widget child) {
  return BlocProvider<AuthCubit>.value(
    value: cubit,
    child: MaterialApp(
      localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

void main() {
  late MockAuthCubit cubit;

  setUp(() {
    cubit = MockAuthCubit();
    when(() => cubit.stream).thenAnswer((_) => const Stream<AuthState>.empty());
  });

  testWidgets('authenticated cashier can access general settings guard', (tester) async {
    when(() => cubit.state).thenReturn(AuthState.authenticated(const UserEntity(id: 'cashier-1', email: 'cashier@example.com', fullName: 'Cashier', role: 'CASHIER', storeId: 'store-1', isActive: true)));
    await tester.pumpWidget(_app(cubit, const AuthGuard(child: Text('settings-content'))));
    expect(find.text('settings-content'), findsOneWidget);
  });

  testWidgets('cashier cannot pass owner guard', (tester) async {
    when(() => cubit.state).thenReturn(AuthState.authenticated(const UserEntity(id: 'cashier-1', email: 'cashier@example.com', fullName: 'Cashier', role: 'CASHIER', storeId: 'store-1', isActive: true)));
    await tester.pumpWidget(_app(cubit, const OwnerGuard(child: Text('owner-content'))));
    expect(find.text('owner-content'), findsNothing);
  });

  testWidgets('owner can pass cashier-management guard', (tester) async {
    when(() => cubit.state).thenReturn(AuthState.authenticated(const UserEntity(id: 'owner-1', email: 'owner@example.com', fullName: 'Owner', role: 'OWNER', storeId: 'store-1', isActive: true)));
    await tester.pumpWidget(_app(cubit, const OwnerGuard(child: Text('owner-content'))));
    expect(find.text('owner-content'), findsOneWidget);
  });
}
