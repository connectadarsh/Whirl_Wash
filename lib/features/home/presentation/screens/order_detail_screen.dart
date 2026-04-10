import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'package:whirl_wash/features/home/presentation/widgets/order_shared/order_address_card.dart';
import 'package:whirl_wash/features/home/presentation/widgets/order_shared/order_bag_card.dart';
import 'package:whirl_wash/features/home/presentation/widgets/order_shared/order_selection_label.dart';

// =====================================================================
// STATUS HELPERS
// =====================================================================

const _statusLabels = {
  'pending': 'Pending',
  'confirmed': 'Confirmed',
  'picked_up': 'Picked Up',
  'processing': 'Processing',
  'ready': 'Ready',
  'out_for_delivery': 'Out for Delivery',
  'delivered': 'Delivered',
};

Color _statusColor(String status) {
  switch (status) {
    case 'pending':
      return Colors.orange;
    case 'confirmed':
      return Colors.blue;
    case 'picked_up':
      return Colors.purple;
    case 'processing':
      return Colors.cyan;
    case 'ready':
      return Colors.teal;
    case 'out_for_delivery':
      return Colors.indigo;
    case 'delivered':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

IconData _statusIcon(String status) {
  switch (status) {
    case 'pending':
      return Icons.hourglass_empty_rounded;
    case 'confirmed':
      return Icons.check_circle_outline_rounded;
    case 'picked_up':
      return Icons.directions_bike_rounded;
    case 'processing':
      return Icons.local_laundry_service_rounded;
    case 'ready':
      return Icons.inventory_2_rounded;
    case 'out_for_delivery':
      return Icons.delivery_dining_rounded;
    case 'delivered':
      return Icons.done_all_rounded;
    default:
      return Icons.help_outline_rounded;
  }
}

// =====================================================================
// ORDER DETAIL SCREEN
// =====================================================================

class OrderDetailScreen extends ConsumerWidget {
  final String batchId;
  final List<Map<String, dynamic>> orders;

  const OrderDetailScreen({
    super.key,
    required this.batchId,
    required this.orders,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sorted = [...orders]
      ..sort((a, b) {
        final aExpress = a['isExpress'] == true ? 0 : 1;
        final bExpress = b['isExpress'] == true ? 0 : 1;
        return aExpress.compareTo(bExpress);
      });

    final createdAt = orders.first['createdAt'];
    String dateStr = '';
    if (createdAt is Timestamp) {
      final dt = createdAt.toDate();
      dateStr =
          '${dt.day}/${dt.month}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }

    final userAddress = orders.first['userAddress'] as String?;
    final houseName = orders.first['houseName'] as String?;
    final specialInstructions = orders.first['specialInstructions'] as String?;

    // Separate express and regular orders
    final expressOrder = sorted
        .where((o) => o['isExpress'] == true)
        .firstOrNull;
    final regularOrders = sorted.where((o) => o['isExpress'] != true).toList();

    final expressItems =
        (expressOrder?['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final regularItems = regularOrders.isNotEmpty
        ? (regularOrders.first['items'] as List?)
                  ?.cast<Map<String, dynamic>>() ??
              []
        : <Map<String, dynamic>>[];

    final expressTimeSlot = expressOrder?['expressTimeSlot'] as String?;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    AppColors.secondary.withValues(alpha: 0.25),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.06),
                    width: 1,
                  ),
                ),
              ),
              child: FlexibleSpaceBar(
                title: Text(
                  'Batch #${batchId.substring(0, 8).toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 72, bottom: 12),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Date ───────────────────────────────────────
                  if (dateStr.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Colors.white.withValues(alpha: 0.35),
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Placed on $dateStr',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.35),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // ── Bag Status ──────────────────────────────────
                  const OrderSectionLabel(
                    icon: Icons.inventory_2_rounded,
                    label: 'Bag Status',
                  ),
                  const SizedBox(height: 12),
                  ...sorted.map((order) => _BagStatusCard(order: order)),

                  const SizedBox(height: 24),

                  // ── Delivery Address ────────────────────────────
                  if (userAddress != null && userAddress.isNotEmpty) ...[
                    const OrderSectionLabel(
                      icon: Icons.location_on_rounded,
                      label: 'Delivery Address',
                    ),
                    const SizedBox(height: 12),
                    OrderAddressCard(
                      houseName: houseName,
                      address: userAddress,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── Express Items ───────────────────────────────
                  if (expressItems.isNotEmpty) ...[
                    ExpressBagCard(
                      items: expressItems,
                      timeSlot: expressTimeSlot,
                      bottomMargin: 20,
                    ),
                  ],

                  // ── Regular Items ───────────────────────────────
                  if (regularItems.isNotEmpty) ...[
                    RegularBagCard(items: regularItems, bottomMargin: 20),
                  ],

                  // ── Special Instructions ────────────────────────
                  if (specialInstructions != null &&
                      specialInstructions.trim().isNotEmpty) ...[
                    const OrderSectionLabel(
                      icon: Icons.note_alt_outlined,
                      label: 'Special Instructions',
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Text(
                        specialInstructions,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.75),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// BAG STATUS CARD (only on detail screen)
// =====================================================================

class _BagStatusCard extends StatelessWidget {
  final Map<String, dynamic> order;
  const _BagStatusCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final isExpress = order['isExpress'] == true;
    final status = order['status'] as String? ?? 'pending';
    final color = isExpress ? Colors.orange : AppColors.secondary;
    final timeSlot = order['expressTimeSlot'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isExpress
                  ? Icons.bolt_rounded
                  : Icons.local_laundry_service_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isExpress ? 'Express Bag' : 'Regular Bag',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (isExpress && timeSlot != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    'Slot: $timeSlot',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _statusColor(status).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _statusColor(status).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _statusIcon(status),
                  color: _statusColor(status),
                  size: 12,
                ),
                const SizedBox(width: 5),
                Text(
                  _statusLabels[status] ?? status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(status),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
