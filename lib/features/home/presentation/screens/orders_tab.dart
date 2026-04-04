import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';

// =====================================================================
// ORDERS STREAM PROVIDER
// =====================================================================

final ordersStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('orders')
      .where('userId', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((d) => {'id': d.id, ...d.data()}).toList());
});

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

const _statusOrder = [
  'pending',
  'confirmed',
  'picked_up',
  'processing',
  'ready',
  'out_for_delivery',
  'delivered',
];

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
// ORDERS TAB
// =====================================================================

class OrdersTab extends ConsumerWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersStreamProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
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
              child: const FlexibleSpaceBar(
                title: Text(
                  'My Orders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: false,
                titlePadding: EdgeInsets.only(left: 20, bottom: 16),
              ),
            ),
          ),

          // ── Orders List ──────────────────────────────────────────
          ordersAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF4ECDC4)),
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(
                child: Text(
                  'Error loading orders',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                ),
              ),
            ),
            data: (orders) {
              if (orders.isEmpty) {
                return const SliverFillRemaining(child: _EmptyState());
              }

              // Group by batchId
              final batches = <String, List<Map<String, dynamic>>>{};
              for (final order in orders) {
                final batchId =
                    order['batchId'] as String? ?? order['id'] as String;
                batches.putIfAbsent(batchId, () => []).add(order);
              }

              final batchList = batches.entries.toList();

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final batch = batchList[index];
                    return GestureDetector(
                      onTap: () => context.pushNamed(
                        'order-detail',
                        extra: {'batchId': batch.key, 'orders': batch.value},
                      ),
                      child: _BatchCard(
                        batchId: batch.key,
                        orders: batch.value,
                      ),
                    );
                  }, childCount: batchList.length),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// BATCH CARD (groups express + regular under one batchId)
// =====================================================================

class _BatchCard extends StatelessWidget {
  final String batchId;
  final List<Map<String, dynamic>> orders;

  const _BatchCard({required this.batchId, required this.orders});

  @override
  Widget build(BuildContext context) {
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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E0E0E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Batch Header ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    'Batch #${batchId.substring(0, 8).toUpperCase()}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                if (dateStr.isNotEmpty)
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                  ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.white.withValues(alpha: 0.05)),

          // ── Individual order rows ────────────────────────────────
          ...sorted.map((order) => _OrderRow(order: order)),
        ],
      ),
    );
  }
}

// =====================================================================
// ORDER ROW (one bag = one row)
// =====================================================================

class _OrderRow extends StatelessWidget {
  final Map<String, dynamic> order;

  const _OrderRow({required this.order});

  @override
  Widget build(BuildContext context) {
    final isExpress = order['isExpress'] == true;
    final status = order['status'] as String? ?? 'pending';
    final statusLabel = _statusLabels[status] ?? status;
    final color = isExpress ? Colors.orange : AppColors.secondary;
    final itemCount = (order['items'] as List?)?.length ?? 0;
    final orderId = order['id'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          // Bag icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.25)),
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

          // Order info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isExpress ? 'Express Bag' : 'Regular Bag',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '$itemCount item${itemCount != 1 ? 's' : ''}  •  #${orderId.substring(0, 8).toUpperCase()}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),

          // Status badge
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
                  statusLabel,
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
// EMPTY STATE
// =====================================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: AppColors.secondary,
              size: 44,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Orders Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your order history will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
