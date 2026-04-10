import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'package:whirl_wash/features/home/data/models/cart_entry.dart';
import 'package:whirl_wash/features/home/presentation/providers/cart_provider.dart';
import 'package:whirl_wash/features/home/presentation/widgets/cart/cart_express_group.dart';
import 'package:whirl_wash/features/home/presentation/widgets/cart/cart_instructions.dart';
import 'package:whirl_wash/features/home/presentation/widgets/cart/cart_place_order_bar.dart';
import 'package:whirl_wash/features/home/presentation/widgets/cart/cart_service_group.dart';

class CartTab extends ConsumerWidget {
  const CartTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final isEmpty = cart.isEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          _CartAppBar(isEmpty: isEmpty),
          if (isEmpty)
            const _EmptyState()
          else ...[
            _CartItemsList(cart: cart),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: CartInstructionsCard(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ],
      ),
      bottomSheet: isEmpty ? null : const CartPlaceOrderBar(),
    );
  }
}

// =====================================================================
// APP BAR
// =====================================================================

class _CartAppBar extends ConsumerWidget {
  final bool isEmpty;
  const _CartAppBar({required this.isEmpty});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canPop = context.canPop();

    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: canPop
          ? GestureDetector(
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
            )
          : null,
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
          title: Row(
            children: [
              if (canPop) const SizedBox(width: 40),
              const Text(
                'My Cart',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              if (!isEmpty)
                GestureDetector(
                  onTap: () => _showClearCartDialog(context, ref),
                  child: Container(
                    margin: const EdgeInsets.only(right: 16, bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          centerTitle: false,
          titlePadding: const EdgeInsets.only(left: 20, bottom: 12),
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cart', style: TextStyle(color: Colors.white)),
        content: Text(
          'Remove all items from cart?',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clearAll();
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// CART ITEMS LIST
// =====================================================================

class _CartItemsList extends StatelessWidget {
  final Map<String, CartEntry> cart;
  const _CartItemsList({required this.cart});

  @override
  Widget build(BuildContext context) {
    final expressItems = cart.values.where((e) => e.isExpress).toList();
    final regularItems = cart.values.where((e) => !e.isExpress).toList();

    final grouped = <String, List<CartEntry>>{};
    for (final entry in regularItems) {
      grouped.putIfAbsent(entry.serviceId, () => []).add(entry);
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            if (expressItems.isNotEmpty) CartExpressGroup(items: expressItems),
            ...grouped.entries.map(
              (group) =>
                  CartServiceGroup(serviceId: group.key, items: group.value),
            ),
          ],
        ),
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
    return SliverFillRemaining(
      child: Center(
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
                Icons.shopping_cart_rounded,
                color: AppColors.secondary,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cart is Empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add items from any service to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
