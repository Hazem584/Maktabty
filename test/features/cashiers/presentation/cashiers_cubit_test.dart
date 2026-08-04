import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/cashiers/domain/entities/cashier_entity.dart';
import 'package:maktabty/features/cashiers/domain/usecases/cashier_usecases.dart';
import 'package:maktabty/features/cashiers/presentation/cubit/cashier_form_cubit.dart';
import 'package:maktabty/features/cashiers/presentation/cubit/cashiers_list_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockCashierUseCases extends Mock implements CashierUseCases {}

void main() {
  const cashier = CashierEntity(id: 'cashier-1', fullName: 'Cashier One', email: 'cashier@example.com', role: 'CASHIER', storeId: 'store-1', isActive: true);

  group('CashiersListCubit', () {
    late MockCashierUseCases useCases;
    setUp(() => useCases = MockCashierUseCases());

    blocTest<CashiersListCubit, CashiersListState>(
      'emits loading and success for an owner cashier list',
      build: () {
        when(() => useCases.getCashiers(search: null, isActive: null, page: 1, limit: 20)).thenAnswer((_) async => const PaginatedCashiersEntity(items: [cashier], page: 1, limit: 20, total: 1));
        return CashiersListCubit(useCases);
      },
      act: (cubit) => cubit.load(),
      expect: () => [isA<CashiersListState>().having((state) => state.status, 'status', CashiersListStatus.loading), isA<CashiersListState>().having((state) => state.status, 'status', CashiersListStatus.success).having((state) => state.items, 'items', [cashier])],
    );

    blocTest<CashiersListCubit, CashiersListState>(
      'supports a successful empty list',
      build: () {
        when(() => useCases.getCashiers(search: null, isActive: null, page: 1, limit: 20)).thenAnswer((_) async => const PaginatedCashiersEntity(items: [], page: 1, limit: 20, total: 0));
        return CashiersListCubit(useCases);
      },
      act: (cubit) => cubit.load(),
      expect: () => [isA<CashiersListState>().having((state) => state.status, 'status', CashiersListStatus.loading), isA<CashiersListState>().having((state) => state.items, 'items', isEmpty).having((state) => state.status, 'status', CashiersListStatus.success)],
    );

    blocTest<CashiersListCubit, CashiersListState>(
      'maps a cross-store-style 404 to list failure without exposing data',
      build: () {
        when(() => useCases.getCashiers(search: null, isActive: null, page: 1, limit: 20)).thenThrow(const NotFoundFailure());
        return CashiersListCubit(useCases);
      },
      act: (cubit) => cubit.load(),
      expect: () => [isA<CashiersListState>(), isA<CashiersListState>().having((state) => state.failure, 'failure', isA<NotFoundFailure>())],
    );
  });

  test('cashier creation ignores duplicate submissions while in flight', () async {
    final useCases = MockCashierUseCases();
    final pending = Completer<CashierEntity>();
    when(() => useCases.createCashier(fullName: 'Cashier One', email: 'cashier@example.com', password: 'password123')).thenAnswer((_) => pending.future);
    final cubit = CashierFormCubit(useCases);
    final first = cubit.create(fullName: 'Cashier One', email: 'cashier@example.com', password: 'password123');
    await cubit.create(fullName: 'Cashier One', email: 'cashier@example.com', password: 'password123');
    verify(() => useCases.createCashier(fullName: 'Cashier One', email: 'cashier@example.com', password: 'password123')).called(1);
    pending.complete(cashier);
    await first;
    expect(cubit.state.status, CashierFormStatus.success);
    await cubit.close();
  });
}
