import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:maktabty/core/di/service_locator.dart';
import 'package:maktabty/core/localization/locale_cubit.dart';
import 'package:maktabty/core/localization/locale_state.dart';
import 'package:maktabty/core/routes/app_navigator.dart';
import 'package:maktabty/core/routes/app_routes.dart';
import 'package:maktabty/core/theme/app_scroll_behavior.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:maktabty/l10n/gen/app_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: sl<AuthCubit>()),
        BlocProvider<LocaleCubit>.value(value: sl<LocaleCubit>()..load()),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)?.appTitle ?? 'Mazen Store',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            scrollBehavior: const AppScrollBehavior(),
            navigatorKey: AppNavigator.key,
            initialRoute: AppRoutes.root,
            onGenerateRoute: AppRoutes.onGenerateRoute,
            locale: state.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
