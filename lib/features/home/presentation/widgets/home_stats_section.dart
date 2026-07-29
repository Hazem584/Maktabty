import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/features/home/presentation/widgets/home_stat_card.dart';

class HomeStatsSection extends StatelessWidget {
  final List<HomeStatItem> items;

  const HomeStatsSection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final columns = maxWidth >= 720 ? 3 : 2;
        final spacing = AppSpacing.s;
        final cardWidth = (maxWidth - (columns - 1) * spacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items.map((item) {
            return SizedBox(
              width: cardWidth,
              child: HomeStatCard(
                title: item.title,
                value: item.value,
                subtitle: item.subtitle,
                accent: item.accent,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class HomeStatItem {
  final String title;
  final String value;
  final String subtitle;
  final Color? accent;

  const HomeStatItem({
    required this.title,
    required this.value,
    required this.subtitle,
    this.accent,
  });
}
