import 'package:flutter/widgets.dart';

class LocaleState {
  final Locale? locale;
  final bool initialized;

  const LocaleState({required this.locale, required this.initialized});

  factory LocaleState.initial() {
    return const LocaleState(locale: null, initialized: false);
  }

  LocaleState copyWith({Locale? locale, bool? initialized}) {
    return LocaleState(
      locale: locale ?? this.locale,
      initialized: initialized ?? this.initialized,
    );
  }
}
