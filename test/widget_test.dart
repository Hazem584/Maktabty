// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maktabty/l10n/gen/app_localizations.dart';

void main() {
  testWidgets('Maktabty title remains localized in English and Arabic', (
    WidgetTester tester,
  ) async {
    Widget localizedApp(Locale locale) {
      return MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context)!.appTitle),
        ),
      );
    }

    await tester.pumpWidget(localizedApp(const Locale('en')));
    await tester.pumpAndSettle();
    expect(find.text('Maktabty'), findsOneWidget);

    await tester.pumpWidget(localizedApp(const Locale('ar')));
    await tester.pumpAndSettle();
    expect(find.text('مكتبتي'), findsOneWidget);
  });
}
