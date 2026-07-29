import 'package:flutter/material.dart';
import 'package:maktabty/core/theme/app_theme.dart';
import 'package:maktabty/features/home/presentation/widgets/sale_list_item.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';

class SalesList extends StatelessWidget {
  final List<SaleEntity> sales;
  final ValueChanged<SaleEntity>? onSaleTap;

  const SalesList({super.key, required this.sales, this.onSaleTap});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: sales.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s),
      itemBuilder: (context, index) {
        final item = sales[index];
        final createdAt = item.createdAt;
        final dateLabel = createdAt != null ? _formatDate(createdAt) : '--';
        final timeLabel = createdAt != null
            ? TimeOfDay.fromDateTime(createdAt).format(context)
            : '--';
        final quantity = item.items.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        );
        final name = _saleTitle(item);
        return SaleListItem(
          name: name,
          price: '\$${item.totalAmount.toStringAsFixed(2)}',
          date: dateLabel,
          time: timeLabel,
          quantity: 'Qty: $quantity',
          onTap: onSaleTap == null ? null : () => onSaleTap!(item),
        );
      },
    );
  }

  String _saleTitle(SaleEntity sale) {
    if (sale.items.isEmpty) return 'Sale';
    if (sale.items.length == 1) {
      return sale.items.first.product?.name ?? 'Sale';
    }
    return '${sale.items.length} items';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[date.month - 1];
    return '$month ${date.day}';
  }
}
