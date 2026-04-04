import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';

// =====================================================================
// STATUS HELPERS (same as orders_tab)
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

const _serviceNames = {
  'wash_fold': 'Wash & Fold',
  'wash_iron': 'Wash & Iron',
  'dry_clean': 'Dry Clean',
  'iron_only': 'Iron Only',
  'shoe_clean': 'Shoe Clean',
  'express': 'Express',
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
    // Sort: express first
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

    final userAddress = orders.first['userAddress'] as String? ?? '';
    final houseName = orders.first['houseName'] as String? ?? '';
    final specialInstructions = orders.first['specialInstructions'] as String?;

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
                  // ── Date ─────────────────────────────────────────
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

                  // ── Bag Status Cards ──────────────────────────────
                  _SectionLabel(
                    icon: Icons.inventory_2_rounded,
                    label: 'Bag Status',
                  ),
                  const SizedBox(height: 12),
                  ...sorted.map((order) => _BagStatusCard(order: order)),

                  const SizedBox(height: 24),

                  // ── Delivery Address ──────────────────────────────
                  if (userAddress.isNotEmpty) ...[
                    _SectionLabel(
                      icon: Icons.location_on_rounded,
                      label: 'Delivery Address',
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.location_on_rounded,
                              color: AppColors.secondary,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (houseName.isNotEmpty)
                                  Text(
                                    houseName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                if (houseName.isNotEmpty)
                                  const SizedBox(height: 3),
                                Text(
                                  userAddress,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.55),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── Items per bag ─────────────────────────────────
                  ...sorted.map((order) => _BagItemsSection(order: order)),

                  // ── Special Instructions ──────────────────────────
                  if (specialInstructions != null &&
                      specialInstructions.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _SectionLabel(
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
// BAG STATUS CARD
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

// =====================================================================
// BAG ITEMS SECTION
// =====================================================================

class _BagItemsSection extends StatelessWidget {
  final Map<String, dynamic> order;
  const _BagItemsSection({required this.order});

  @override
  Widget build(BuildContext context) {
    final isExpress = order['isExpress'] == true;
    final items = (order['items'] as List?) ?? [];
    final color = isExpress ? Colors.orange : AppColors.secondary;

    if (items.isEmpty) return const SizedBox();

    // Group by serviceId
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final item in items) {
      final map = item as Map<String, dynamic>;
      final sid = map['serviceId'] as String? ?? 'unknown';
      grouped.putIfAbsent(sid, () => []).add(map);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(
          icon: isExpress
              ? Icons.bolt_rounded
              : Icons.local_laundry_service_rounded,
          label: isExpress ? 'Express Items' : 'Regular Items',
          color: color,
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: grouped.entries.map((entry) {
              final serviceItems = entry.value;
              final serviceName = _serviceNames[entry.key] ?? entry.key;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                    child: Text(
                      serviceName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ...serviceItems.map((item) => _ItemRow(item: item)),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// =====================================================================
// ITEM ROW
// =====================================================================

class _ItemRow extends StatelessWidget {
  final Map<String, dynamic> item;
  const _ItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final itemId = item['itemId'] as String? ?? '';
    final customName = item['customName'] as String?;
    final quantity = item['quantity'] as int? ?? 1;
    final fabric = item['fabric'] as String?;
    final displayName = customName ?? itemId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: customName != null
                  ? AppColors.secondary.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: customName != null
                  ? Text(
                      customName[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    )
                  : Text(itemId, style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (fabric != null && fabric != 'dontKnow') ...[
                  const SizedBox(height: 3),
                  Text(
                    fabric,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.secondary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Text(
              '× $quantity',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// SECTION LABEL
// =====================================================================

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _SectionLabel({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color ?? AppColors.secondary, size: 16),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
