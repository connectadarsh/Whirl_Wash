import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'package:whirl_wash/features/home/data/models/cart_entry.dart';
import 'package:whirl_wash/features/home/data/models/fabric_type.dart';
import 'package:whirl_wash/features/home/presentation/providers/order_provider.dart';
import 'package:whirl_wash/features/home/presentation/widgets/order_shared/order_address_card.dart';
import 'package:whirl_wash/features/home/presentation/widgets/order_shared/order_bag_card.dart';
import 'package:whirl_wash/features/home/presentation/widgets/order_shared/order_selection_label.dart';

// =====================================================================
// USER ADDRESS PROVIDER
// =====================================================================

final userAddressProvider = FutureProvider.autoDispose<Map<String, String?>>((
  ref,
) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return {'address': null, 'houseName': null};
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();
  return {
    'address': doc.data()?['address'] as String?,
    'houseName': doc.data()?['houseName'] as String?,
  };
});

// =====================================================================
// ORDER CONFIRM SCREEN
// =====================================================================

class OrderConfirmScreen extends ConsumerWidget {
  final Map<String, CartEntry> cart;
  final String? specialInstructions;

  const OrderConfirmScreen({
    super.key,
    required this.cart,
    this.specialInstructions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderPlacementProvider);
    final addressAsync = ref.watch(userAddressProvider);

    ref.listen<OrderPlacementState>(orderPlacementProvider, (_, next) {
      if (next.isSuccess) {
        context.pushReplacementNamed('order-success', extra: next.orderId);
      }
    });

    if (orderState.isLoading) {
      return const _PlacingOrderLoader();
    }

    // Convert CartEntry items to Map for shared widgets
    final expressItems = cart.values
        .where((e) => e.isExpress)
        .map((e) => _cartEntryToMap(e))
        .toList();

    final regularItems = cart.values
        .where((e) => !e.isExpress)
        .map((e) => _cartEntryToMap(e))
        .toList();

    final totalItems = cart.values.fold(0, (sum, e) => sum + e.quantity);
    final addressData = addressAsync.value;
    final expressTimeSlot = cart.values
        .firstWhere((e) => e.isExpress, orElse: () => cart.values.first)
        .expressTimeSlot;

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
                  // ── Delivery Address ────────────────────────────
                  const OrderSectionLabel(
                    icon: Icons.location_on_rounded,
                    label: 'Delivery Address',
                  ),
                  const SizedBox(height: 12),
                  OrderAddressCard(
                    houseName: addressData?['houseName'],
                    address: addressData?['address'],
                    isLoading: addressAsync.isLoading,
                  ),
                  const SizedBox(height: 20),

                  // ── Order Summary ───────────────────────────────
                  const OrderSectionLabel(
                    icon: Icons.receipt_long_rounded,
                    label: 'Order Summary',
                  ),
                  const SizedBox(height: 12),

                  if (expressItems.isNotEmpty)
                    ExpressBagCard(
                      items: expressItems,
                      timeSlot: expressTimeSlot,
                    ),

                  if (regularItems.isNotEmpty)
                    RegularBagCard(items: regularItems),

                  // ── Special Instructions ────────────────────────
                  if (specialInstructions != null &&
                      specialInstructions!.trim().isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const OrderSectionLabel(
                      icon: Icons.note_alt_outlined,
                      label: 'Special Instructions',
                    ),
                    const SizedBox(height: 12),
                    _InstructionsCard(text: specialInstructions!),
                  ],

                  const SizedBox(height: 20),
                  _TotalRow(totalItems: totalItems),
                  const SizedBox(height: 16),
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
        cart: cart,
        specialInstructions: specialInstructions,
      ),
    );
  }

  Map<String, dynamic> _cartEntryToMap(CartEntry e) => {
    'itemId': e.itemId,
    'serviceId': e.serviceId,
    'quantity': e.quantity,
    'customName': e.customName,
    'fabric': e.fabric != null && e.fabric != FabricType.dontKnow
        ? e.fabric!.name
        : null,
    'isExpress': e.isExpress,
    'expressTimeSlot': e.expressTimeSlot,
    'imageUrl': e.imageUrl,
  };
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
// SUPPORTING WIDGETS
// =====================================================================

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
            : () => ref
                  .read(orderPlacementProvider.notifier)
                  .placeOrder(
                    cart: cart,
                    specialInstructions: specialInstructions,
                  ),
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
// --------------------------------------Cloudinary-------------------------------------------------------------
