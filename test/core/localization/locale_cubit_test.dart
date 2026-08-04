import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maktabty/core/localization/locale_cubit.dart';
import 'package:maktabty/core/localization/locale_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockLocaleStorage extends Mock implements LocaleStorage {}

void main() {
  test('stored Arabic locale is restored', () async {
    final storage = MockLocaleStorage();
    when(() => storage.getLocaleCode()).thenAnswer((_) async => 'ar');
    final cubit = LocaleCubit(storage: storage);
    await cubit.load();
    expect(cubit.state.locale, const Locale('ar'));
    await cubit.close();
  });

  test('Arabic and English selections use existing locale storage', () async {
    final storage = MockLocaleStorage();
    when(() => storage.saveLocaleCode(any())).thenAnswer((_) async {});
    final cubit = LocaleCubit(storage: storage);
    await cubit.setLocale(const Locale('ar'));
    await cubit.setLocale(const Locale('en'));
    verifyInOrder([() => storage.saveLocaleCode('ar'), () => storage.saveLocaleCode('en')]);
    expect(cubit.state.locale, const Locale('en'));
    await cubit.close();
  });
}
