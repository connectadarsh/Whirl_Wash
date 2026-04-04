import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'package:whirl_wash/features/home/data/models/fabric_type.dart';
import 'package:whirl_wash/features/home/presentation/providers/cart_provider.dart';
import 'package:whirl_wash/features/home/presentation/providers/order_provider.dart';

// =====================================================================
// SERVICE DISPLAY HELPERS
// =====================================================================

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

// =====================================================================
// ORDER CONFIRM SCREEN
// =====================================================================

class OrderConfirmScreen extends ConsumerStatefulWidget {
  final Map<String, CartEntry> cart;
  final String? specialInstructions;

  const OrderConfirmScreen({
    super.key,
    required this.cart,
    this.specialInstructions,
  });

  @override
  ConsumerState<OrderConfirmScreen> createState() => _OrderConfirmScreenState();
}

class _OrderConfirmScreenState extends ConsumerState<OrderConfirmScreen> {
  String? _userAddress;
  String? _houseName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderPlacementProvider.notifier).reset();
    });
    _loadUserAddress();
  }

  Future<void> _loadUserAddress() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (doc.exists) {
      setState(() {
        _userAddress = doc.data()?['address'] as String?;
        _houseName = doc.data()?['houseName'] as String?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderPlacementProvider);

    ref.listen<OrderPlacementState>(orderPlacementProvider, (prev, next) {
      if (next.isSuccess) {
        context.pushReplacementNamed('order-success', extra: next.orderId);
      }
    });

    if (orderState.isLoading) {
      return const _PlacingOrderLoader();
    }

    final expressItems = widget.cart.values.where((e) => e.isExpress).toList();
    final regularItems = widget.cart.values.where((e) => !e.isExpress).toList();
    final totalItems = widget.cart.values.fold(0, (sum, e) => sum + e.quantity);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────
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
              child: const FlexibleSpaceBar(
                title: Text(
                  'Confirm Order',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: false,
                titlePadding: EdgeInsets.only(left: 72, bottom: 12),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Delivery Address Card ───────────────────────
                  _SectionLabel(
                    icon: Icons.location_on_rounded,
                    label: 'Delivery Address',
                  ),
                  const SizedBox(height: 12),
                  _AddressCard(houseName: _houseName, address: _userAddress),

                  const SizedBox(height: 20),

                  // ── Order Summary ───────────────────────────────
                  _SectionLabel(
                    icon: Icons.receipt_long_rounded,
                    label: 'Order Summary',
                  ),
                  const SizedBox(height: 12),

                  if (expressItems.isNotEmpty)
                    _ExpressConfirmCard(items: expressItems),

                  ..._buildRegularGroups(regularItems),

                  if (widget.specialInstructions != null &&
                      widget.specialInstructions!.trim().isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _SectionLabel(
                      icon: Icons.note_alt_outlined,
                      label: 'Special Instructions',
                    ),
                    const SizedBox(height: 12),
                    _InstructionsCard(text: widget.specialInstructions!),
                  ],

                  const SizedBox(height: 20),

                  _TotalRow(totalItems: totalItems),

                  const SizedBox(height: 16),

                  // ── Payment Caution Banner ──────────────────────
                  const _PaymentCautionBanner(),

                  if (orderState.error != null) ...[
                    const SizedBox(height: 16),
                    _ErrorBanner(message: orderState.error!),
                  ],

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomSheet: _ConfirmBar(
        cart: widget.cart,
        specialInstructions: widget.specialInstructions,
      ),
    );
  }

  List<Widget> _buildRegularGroups(List<CartEntry> regularItems) {
    final grouped = <String, List<CartEntry>>{};
    for (final entry in regularItems) {
      grouped.putIfAbsent(entry.serviceId, () => []).add(entry);
    }
    return grouped.entries
        .map((g) => _RegularConfirmCard(serviceId: g.key, items: g.value))
        .toList();
  }
}

// =====================================================================
// ADDRESS CARD
// =====================================================================

class _AddressCard extends StatelessWidget {
  final String? houseName;
  final String? address;

  const _AddressCard({this.houseName, this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.12),
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
            child: address == null
                ? Text(
                    'No address saved. Please complete your profile.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red.withValues(alpha: 0.8),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (houseName != null && houseName!.isNotEmpty)
                        Text(
                          houseName!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      if (houseName != null && houseName!.isNotEmpty)
                        const SizedBox(height: 3),
                      Text(
                        address!,
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
    );
  }
}

// =====================================================================
// PAYMENT CAUTION BANNER
// =====================================================================

class _PaymentCautionBanner extends StatelessWidget {
  const _PaymentCautionBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.amber, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'A payment request will be sent after your clothes are collected. Complete the payment to begin processing your order.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.amber.withValues(alpha: 0.85),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// PLACING ORDER LOADER
// =====================================================================

class _PlacingOrderLoader extends StatelessWidget {
  const _PlacingOrderLoader();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: CircularProgressIndicator(
                color: AppColors.secondary,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Placing your order...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait a moment',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// EXPRESS CONFIRM CARD
// =====================================================================

class _ExpressConfirmCard extends StatelessWidget {
  final List<CartEntry> items;
  const _ExpressConfirmCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final timeSlot = items.first.expressTimeSlot;
    final grouped = <String, List<CartEntry>>{};
    for (final e in items) {
      grouped.putIfAbsent(e.serviceId, () => []).add(e);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.35),
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
                      timeSlot,
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
            (g) => _ServiceSubGroup(serviceId: g.key, items: g.value),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// REGULAR CONFIRM CARD
// =====================================================================

class _RegularConfirmCard extends StatelessWidget {
  final String serviceId;
  final List<CartEntry> items;
  const _RegularConfirmCard({required this.serviceId, required this.items});

  @override
  Widget build(BuildContext context) {
    final name = _serviceNames[serviceId] ?? serviceId;
    final icon =
        _serviceIcons[serviceId] ?? Icons.local_laundry_service_rounded;
    final total = items.fold(0, (s, e) => s + e.quantity);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                  child: Icon(icon, color: AppColors.secondary, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  name,
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
          ...items.map((e) => _ConfirmItemRow(entry: e)),
        ],
      ),
    );
  }
}

// =====================================================================
// SERVICE SUB GROUP
// =====================================================================

class _ServiceSubGroup extends StatelessWidget {
  final String serviceId;
  final List<CartEntry> items;
  const _ServiceSubGroup({required this.serviceId, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
          child: Text(
            _serviceNames[serviceId] ?? serviceId,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.45),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...items.map((e) => _ConfirmItemRow(entry: e)),
      ],
    );
  }
}

// =====================================================================
// CONFIRM ITEM ROW
// =====================================================================

class _ConfirmItemRow extends StatelessWidget {
  final CartEntry entry;
  const _ConfirmItemRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final displayName = entry.isCustom ? entry.customName! : entry.itemId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: entry.isCustom
                  ? AppColors.secondary.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: entry.isCustom
                  ? Text(
                      entry.customName![0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    )
                  : Text(entry.itemId, style: const TextStyle(fontSize: 18)),
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
                if (entry.fabric != null &&
                    entry.fabric != FabricType.dontKnow) ...[
                  const SizedBox(height: 3),
                  Text(
                    entry.fabric!.label,
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
              '× ${entry.quantity}',
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
// SUPPORTING WIDGETS
// =====================================================================

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: 16),
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

class _InstructionsCard extends StatelessWidget {
  final String text;
  const _InstructionsCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: Colors.white.withValues(alpha: 0.75),
          height: 1.5,
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final int totalItems;
  const _TotalRow({required this.totalItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shopping_bag_rounded,
            color: AppColors.secondary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            'Total Items',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const Spacer(),
          Text(
            '$totalItems item${totalItems > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.red, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// CONFIRM BAR
// =====================================================================

class _ConfirmBar extends ConsumerWidget {
  final Map<String, CartEntry> cart;
  final String? specialInstructions;

  const _ConfirmBar({required this.cart, this.specialInstructions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(orderPlacementProvider).isLoading;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: isLoading
            ? null
            : () {
                ref
                    .read(orderPlacementProvider.notifier)
                    .placeOrder(
                      cart: cart,
                      specialInstructions: specialInstructions,
                    );
              },
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: isLoading
                ? AppColors.secondary.withValues(alpha: 0.5)
                : AppColors.secondary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'Confirm & Place Order',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
