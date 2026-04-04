import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:whirl_wash/features/home/data/models/fabric_type.dart';
import 'package:whirl_wash/features/home/presentation/providers/cart_provider.dart';
import '../../../../../core/constants/app_colors.dart';

// =====================================================================
// LOCAL PROVIDERS
// =====================================================================

final _specialInstructionsProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

// =====================================================================
// SERVICE NAME MAP
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
// CART TAB
// =====================================================================

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
          _buildAppBar(context, ref, isEmpty),
          if (isEmpty)
            _buildEmptyState()
          else ...[
            _buildCartItems(ref, cart),
            _buildSpecialInstructions(ref),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ],
      ),
      bottomSheet: isEmpty ? null : _PlaceOrderBar(),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, WidgetRef ref, bool isEmpty) {
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
                        width: 1,
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

  SliverFillRemaining _buildEmptyState() {
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

  SliverToBoxAdapter _buildCartItems(
    WidgetRef ref,
    Map<String, CartEntry> cart,
  ) {
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
            if (expressItems.isNotEmpty) _ExpressGroup(items: expressItems),
            ...grouped.entries.map((group) {
              return _ServiceGroup(serviceId: group.key, items: group.value);
            }),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSpecialInstructions(WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: _SpecialInstructionsCard(),
      ),
    );
  }
}

// =====================================================================
// EXPRESS GROUP
// =====================================================================

class _ExpressGroup extends ConsumerWidget {
  final List<CartEntry> items;

  const _ExpressGroup({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeSlot = items.first.expressTimeSlot;

    final grouped = <String, List<CartEntry>>{};
    for (final entry in items) {
      grouped.putIfAbsent(entry.serviceId, () => []).add(entry);
    }

    final totalItems = items.fold(0, (sum, e) => sum + e.quantity);
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
                        width: 1,
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

          ...grouped.entries.map((group) {
            final serviceId = group.key;
            final serviceItems = group.value;
            final serviceName = _serviceNames[serviceId] ?? serviceId;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                  child: Text(
                    serviceName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.45),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                ...serviceItems.map(
                  (entry) => _CartItemRow(entry: entry, serviceId: serviceId),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// =====================================================================
// SERVICE GROUP
// =====================================================================

class _ServiceGroup extends ConsumerWidget {
  final String serviceId;
  final List<CartEntry> items;

  const _ServiceGroup({required this.serviceId, required this.items});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceName = _serviceNames[serviceId] ?? serviceId;
    final serviceIcon =
        _serviceIcons[serviceId] ?? Icons.local_laundry_service_rounded;

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
                  '${items.fold(0, (sum, e) => sum + e.quantity)} item${items.fold(0, (sum, e) => sum + e.quantity) > 1 ? 's' : ''}',
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

          ...items.map(
            (entry) => _CartItemRow(entry: entry, serviceId: serviceId),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// CART ITEM ROW
// =====================================================================

class _CartItemRow extends ConsumerWidget {
  final CartEntry entry;
  final String serviceId;

  const _CartItemRow({required this.entry, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(cartProvider.notifier);
    final displayName = entry.isCustom ? entry.customName! : entry.itemId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: entry.isCustom
                  ? AppColors.secondary.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: entry.isCustom
                  ? Text(
                      entry.customName![0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    )
                  : Text(entry.itemId, style: const TextStyle(fontSize: 20)),
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
                ] else if (entry.fabric == FabricType.dontKnow) ...[
                  const SizedBox(height: 3),
                  Text(
                    'Not Sure',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ],
            ),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SmallBtn(
                icon: Icons.remove,
                onTap: () => notifier.decrement(
                  entry.itemId,
                  serviceId,
                  isExpress: entry.isExpress,
                ),
              ),
              SizedBox(
                width: 32,
                child: Text(
                  '${entry.quantity}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              _SmallBtn(
                icon: Icons.add,
                onTap: () => notifier.increment(
                  entry.itemId,
                  serviceId,
                  isExpress: entry.isExpress,
                ),
                filled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _SmallBtn({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: filled
              ? AppColors.secondary.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.08),
          shape: BoxShape.circle,
          border: Border.all(
            color: filled
                ? AppColors.secondary.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 14,
          color: filled
              ? AppColors.secondary
              : Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

// =====================================================================
// SPECIAL INSTRUCTIONS
// =====================================================================
class _SpecialInstructionsCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.note_alt_outlined,
                color: AppColors.secondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              const Text(
                'Special Instructions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '(optional)',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (val) =>
                ref.read(_specialInstructionsProvider.notifier).state = val,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            maxLines: 3,
            decoration: InputDecoration(
              hintText:
                  'e.g. Handle with care, avoid bleach, use mild detergent...',
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 13,
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// PLACE ORDER BAR
// =====================================================================

class _PlaceOrderBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalItems = ref.watch(cartTotalProvider);
    final cart = ref.watch(cartProvider);
    final specialInstructions = ref.watch(_specialInstructionsProvider);

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
        onTap: () {
          context.pushNamed(
            'order-confirm',
            extra: {
              'cart': cart,
              'specialInstructions': specialInstructions.trim().isEmpty
                  ? null
                  : specialInstructions.trim(),
            },
          );
        },
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Place Order',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$totalItems item${totalItems > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
