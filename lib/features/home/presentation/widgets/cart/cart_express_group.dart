import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class CartExpressGroup extends ConsumerWidget {
  final List<CartEntry> items;

  const CartExpressGroup({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeSlot = items.first.expressTimeSlot;
    final totalItems = items.fold(0, (sum, e) => sum + e.quantity);

    final grouped = <String, List<CartEntry>>{};
    for (final entry in items) {
      grouped.putIfAbsent(entry.serviceId, () => []).add(entry);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
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
                const SizedBox(width: 8),
                if (timeSlot != null)
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
                      timeSlot,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const Spacer(),
                Text(
                  '$totalItems item${totalItems > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),

          // ── Items grouped by service ───────────────────────────
          ...grouped.entries.map(
            (group) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                  child: Text(
                    _serviceNames[group.key] ?? group.key,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.45),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                ...group.value.map(
                  (entry) => CartItemRow(entry: entry, serviceId: group.key),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
