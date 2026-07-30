import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/localization/locale_state.dart';
import 'package:maktabty/core/localization/locale_storage.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final LocaleStorage _storage;

  LocaleCubit({required this._storage})
    : super(LocaleState.initial());

  Future<void> load() async {
    if (state.initialized) return;
    final code = await _storage.getLocaleCode();
    final locale = code == null || code.isEmpty ? null : Locale(code);
    emit(LocaleState(locale: locale, initialized: true));
  }

  Future<void> setLocale(Locale locale) async {
    emit(state.copyWith(locale: locale, initialized: true));
    await _storage.saveLocaleCode(locale.languageCode);
  }

  Future<void> clearLocale() async {
    emit(state.copyWith(locale: null, initialized: true));
    await _storage.clearLocale();
  }
}
