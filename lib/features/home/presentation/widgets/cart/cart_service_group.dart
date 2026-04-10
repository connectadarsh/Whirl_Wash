import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'package:whirl_wash/features/home/data/models/cart_entry.dart';
import 'package:whirl_wash/features/home/presentation/widgets/cart/cart_item_row.dart';

const Map<String, String> _serviceNames = {
  'wash_fold': 'Wash & Fold',
  'wash_iron': 'Wash & Iron',
  'dry_clean': 'Dry Clean',
  'iron_only': 'Iron Only',
  'shoe_clean': 'Shoe Clean',
  'express': 'Express',
};

const Map<String, IconData> _serviceIcons = {
  'wash_fold': Icons.local_laundry_service_rounded,
  'wash_iron': Icons.iron_rounded,
  'dry_clean': Icons.dry_cleaning_rounded,
  'iron_only': Icons.checkroom_rounded,
  'shoe_clean': Icons.cleaning_services_rounded,
  'express': Icons.flash_on_rounded,
};

class CartServiceGroup extends ConsumerWidget {
  final String serviceId;
  final List<CartEntry> items;

  const CartServiceGroup({
    super.key,
    required this.serviceId,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceName = _serviceNames[serviceId] ?? serviceId;
    final serviceIcon =
        _serviceIcons[serviceId] ?? Icons.local_laundry_service_rounded;
    final total = items.fold(0, (sum, e) => sum + e.quantity);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // ── Header ────────────────────────────────────────────
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
                    serviceIcon,
                    color: AppColors.secondary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  serviceName,
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

          // ── Items ─────────────────────────────────────────────
          ...items.map(
            (entry) => CartItemRow(entry: entry, serviceId: serviceId),
          ),
        ],
      ),
    );
  }
}
