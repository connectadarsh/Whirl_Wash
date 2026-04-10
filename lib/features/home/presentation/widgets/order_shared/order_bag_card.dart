import 'package:flutter/material.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'package:whirl_wash/features/home/presentation/widgets/order_shared/order_item_row.dart';
import 'package:whirl_wash/features/home/presentation/widgets/order_shared/order_selection_label.dart';

const Map<String, String> orderServiceNames = {
  'wash_fold': 'Wash & Fold',
  'wash_iron': 'Wash & Iron',
  'dry_clean': 'Dry Clean',
  'iron_only': 'Iron Only',
  'shoe_clean': 'Shoe Clean',
  'express': 'Express',
};

const Map<String, IconData> orderServiceIcons = {
  'wash_fold': Icons.local_laundry_service_rounded,
  'wash_iron': Icons.iron_rounded,
  'dry_clean': Icons.dry_cleaning_rounded,
  'iron_only': Icons.checkroom_rounded,
  'shoe_clean': Icons.cleaning_services_rounded,
  'express': Icons.flash_on_rounded,
};

// =====================================================================
// EXPRESS BAG CARD
// =====================================================================

class ExpressBagCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String? timeSlot;
  final double bottomMargin;

  const ExpressBagCard({
    super.key,
    required this.items,
    this.timeSlot,
    this.bottomMargin = 12,
  });

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final item in items) {
      final sid = item['serviceId'] as String? ?? 'unknown';
      grouped.putIfAbsent(sid, () => []).add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrderSectionLabel(
          icon: Icons.bolt_rounded,
          label: 'Express Items',
          color: Colors.orange,
        ),
        const SizedBox(height: 12),
        Container(
          margin: EdgeInsets.only(bottom: bottomMargin),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.orange.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: Colors.orange,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Express',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    if (timeSlot != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          timeSlot!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
              ...grouped.entries.map(
                (entry) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                      child: Text(
                        orderServiceNames[entry.key] ?? entry.key,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.45),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ...entry.value.map(
                      (item) => OrderItemRow(
                        itemId: item['itemId'] as String? ?? '',
                        quantity: item['quantity'] as int? ?? 1,
                        customName: item['customName'] as String?,
                        fabric: item['fabric'] as String?,
                        imageUrl: item['imageUrl'] as String?, // ← NEW
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// REGULAR BAG CARD
// =====================================================================

class RegularBagCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final double bottomMargin;

  const RegularBagCard({
    super.key,
    required this.items,
    this.bottomMargin = 12,
  });

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final item in items) {
      final sid = item['serviceId'] as String? ?? 'unknown';
      grouped.putIfAbsent(sid, () => []).add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrderSectionLabel(
          icon: Icons.local_laundry_service_rounded,
          label: 'Regular Items',
        ),
        const SizedBox(height: 12),
        ...grouped.entries.map((entry) {
          final total = entry.value.fold(
            0,
            (s, e) => s + (e['quantity'] as int? ?? 1),
          );
          return Container(
            margin: EdgeInsets.only(bottom: bottomMargin),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          orderServiceIcons[entry.key] ??
                              Icons.local_laundry_service_rounded,
                          color: AppColors.secondary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        orderServiceNames[entry.key] ?? entry.key,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$total item${total > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
                ...entry.value.map(
                  (item) => OrderItemRow(
                    itemId: item['itemId'] as String? ?? '',
                    quantity: item['quantity'] as int? ?? 1,
                    customName: item['customName'] as String?,
                    fabric: item['fabric'] as String?,
                    imageUrl: item['imageUrl'] as String?, // ← NEW
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
