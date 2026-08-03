import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';

class ProductActionsSheet extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  final VoidCallback onCancel;

  const ProductActionsSheet({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(context.l10n.edit),
              onTap: onEdit,
            ),
            if (onDelete != null)
              ListTile(
                leading: const Icon(Icons.archive_outlined),
                title: Text(context.l10n.archiveProduct),
                onTap: onDelete,
              ),
            ListTile(
              leading: const Icon(Icons.close),
              title: Text(context.l10n.cancel),
              onTap: onCancel,
            ),
          ],
        ),
      ),
    );
  }
}
