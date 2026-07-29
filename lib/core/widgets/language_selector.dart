import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/localization/locale_cubit.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LocaleCubit>().state;
    final currentCode =
        state.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;

    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: Text(context.l10n.languageEnglish),
          selected: currentCode == 'en',
          onSelected: (_) {
            context.read<LocaleCubit>().setLocale(const Locale('en'));
          },
        ),
        ChoiceChip(
          label: Text(context.l10n.languageArabic),
          selected: currentCode == 'ar',
          onSelected: (_) {
            context.read<LocaleCubit>().setLocale(const Locale('ar'));
          },
        ),
      ],
    );
  }
}
