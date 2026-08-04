import 'package:flutter/material.dart';
import 'package:maktabty/core/localization/l10n_ext.dart';
import 'package:maktabty/features/cashiers/domain/entities/cashier_entity.dart';

class CashierListTile extends StatelessWidget {
  final CashierEntity cashier;
  final VoidCallback onTap;

  const CashierListTile({super.key, required this.cashier, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final statusColor = cashier.isActive ? Colors.green.shade700 : colors.error;
    return Card(
      color: cashier.isActive ? null : colors.errorContainer.withValues(alpha: 0.3),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: cashier.isActive ? colors.primaryContainer : colors.errorContainer,
          child: Icon(Icons.badge_outlined, color: cashier.isActive ? colors.onPrimaryContainer : colors.onErrorContainer),
        ),
        title: Text(cashier.fullName, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(cashier.email, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(cashier.isActive ? Icons.check_circle_outline : Icons.block, color: statusColor, size: 18),
            const SizedBox(width: 6),
            Text(cashier.isActive ? context.l10n.active : context.l10n.disabled, style: TextStyle(color: statusColor)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
