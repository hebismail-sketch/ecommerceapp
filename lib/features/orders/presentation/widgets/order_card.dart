import 'package:ecommerceapp/features/orders/domain/entities/order_entity.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isConfirmed = order.paymentStatus == 'confirmed';
    final formattedPrice = NumberFormat('#,###').format(order.totalPrice);
    final formattedDate = DateFormat(
      'dd MMM yyyy، hh:mm a',
      'ar',
    ).format(order.orderDate);
    final shortId = order.id.length > 8 ? order.id.substring(0, 8) : order.id;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: isConfirmed
                        ? const Color(0xFFE8F7EE)
                        : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isConfirmed
                        ? Icons.check_circle_outline
                        : Icons.hourglass_empty_rounded,
                    color: isConfirmed
                        ? const Color(0xFF269B55)
                        : const Color(0xFFE28A19),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.orderNumber(shortId),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _OrderStatusChip(isConfirmed: isConfirmed),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.grandTotal,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$formattedPrice ${l10n.egp}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 19,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.carsCount(order.carIds.length),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.payments_outlined,
                  size: 19,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.cashOnDelivery,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderStatusChip extends StatelessWidget {
  const _OrderStatusChip({required this.isConfirmed});

  final bool isConfirmed;

  @override
  Widget build(BuildContext context) {
    final color = isConfirmed
        ? const Color(0xFF269B55)
        : const Color(0xFFE28A19);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: isConfirmed ? const Color(0xFFE8F7EE) : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isConfirmed
          ? AppLocalizations.of(context)!.orderConfirmedStatus
          : AppLocalizations.of(context)!.orderPendingStatus,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
