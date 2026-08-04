import 'package:flutter/material.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/widgets/language_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.l),
        children: [
          Text(context.l10n.language, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.s),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [const Icon(Icons.language), const SizedBox(width: AppSpacing.s), Expanded(child: Text(context.l10n.chooseLanguage))]),
                  const SizedBox(height: AppSpacing.m),
                  const LanguageSelector(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
