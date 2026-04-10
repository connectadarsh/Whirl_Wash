import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'package:whirl_wash/features/home/data/models/fabric_type.dart';
import 'package:whirl_wash/features/home/presentation/providers/cart_provider.dart';
import 'package:whirl_wash/features/home/presentation/providers/config_providers.dart';
import 'package:whirl_wash/features/home/presentation/providers/service_search_provider.dart';
import 'package:whirl_wash/features/home/presentation/widgets/service_bottom_bar.dart';
import 'package:whirl_wash/features/home/presentation/widgets/service_fabric_sheet.dart';
import 'package:whirl_wash/features/home/presentation/widgets/service_info_banner.dart';
import 'package:whirl_wash/features/home/presentation/widgets/service_item_card.dart';
import 'package:whirl_wash/features/home/presentation/widgets/service_search_bar.dart';

class WashIronScreen extends ConsumerWidget {
  const WashIronScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(washIronSearchProvider);
    final itemsAsync = ref.watch(itemsConfigProvider('wash_iron'));
    final cartEntries = ref.watch(cartProvider);
    final customItems = cartEntries.values
        .where((e) => e.serviceId == 'wash_iron' && e.isCustom)
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          const ServiceInfoBanner(
            message: 'Priced per kg · Final amount set by admin after weighing',
          ),
          ServiceSearchBar(searchProvider: washIronSearchProvider),
          Expanded(
            child: itemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(
                child: Text(
                  'Failed to load items',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              data: (items) {
                final filtered = items
                    .where(
                      (item) => item.name.toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      ),
                    )
                    .toList();
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: [
                    ...filtered.map((item) {
                      final cartEntry = ref.watch(
                        cartProvider,
                      )['wash_iron_${item.id}'];
                      return ServiceItemCard(
                        imageUrl: item.imageUrl,
                        name: item.name,
                        quantity: cartEntry?.quantity ?? 0,
                        fabric: cartEntry?.fabric,
                        onIncrement: () => ref
                            .read(cartProvider.notifier)
                            .increment(
                              item.id,
                              'wash_iron',
                              imageUrl: item.imageUrl,
                            ),
                        onDecrement: () => ref
                            .read(cartProvider.notifier)
                            .decrement(item.id, 'wash_iron'),
                        onFabricSelect: (f) => ref
                            .read(cartProvider.notifier)
                            .setFabric(item.id, 'wash_iron', f),
                      );
                    }),
                    ...customItems.map(
                      (e) => ServiceItemCard(
                        isCustom: true,
                        name: e.customName!,
                        quantity: e.quantity,
                        fabric: e.fabric,
                        onIncrement: () => ref
                            .read(cartProvider.notifier)
                            .increment(e.itemId, 'wash_iron'),
                        onDecrement: () => ref
                            .read(cartProvider.notifier)
                            .decrement(e.itemId, 'wash_iron'),
                        onFabricSelect: (f) => ref
                            .read(cartProvider.notifier)
                            .setFabric(e.itemId, 'wash_iron', f),
                      ),
                    ),
                    _AddCustomItemCard(serviceId: 'wash_iron', hasFabric: true),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: const ServiceBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
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
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.iron_rounded,
              color: AppColors.secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Wash & Iron',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// ADD CUSTOM ITEM CARD
// =====================================================================

class _AddCustomItemCard extends ConsumerWidget {
  final String serviceId;
  final bool hasFabric;
  const _AddCustomItemCard({required this.serviceId, required this.hasFabric});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(_customControllerProvider(serviceId));
    final qty = ref.watch(_customQtyProvider(serviceId));
    final fabric = hasFabric
        ? ref.watch(_customFabricProvider(serviceId))
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
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
                Icons.add_circle_outline_rounded,
                color: AppColors.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Add Custom Item',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Item name (e.g. Dupatta, Blanket...)',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 13,
                ),
                prefixIcon: Icon(
                  Icons.edit_rounded,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: qty > 1
                          ? () => ref
                                .read(_customQtyProvider(serviceId).notifier)
                                .state--
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 16,
                          color: Colors.white.withValues(
                            alpha: qty > 1 ? 0.8 : 0.25,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '$qty',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => ref
                          .read(_customQtyProvider(serviceId).notifier)
                          .state++,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        child: Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (hasFabric) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) => ServiceCustomFabricSheet(
                        selected: fabric ?? FabricType.dontKnow,
                        onSelect: (f) =>
                            ref
                                    .read(
                                      _customFabricProvider(serviceId).notifier,
                                    )
                                    .state =
                                f,
                      ),
                    ),
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.texture_rounded,
                            size: 16,
                            color:
                                fabric != null && fabric != FabricType.dontKnow
                                ? AppColors.secondary
                                : Colors.white.withValues(alpha: 0.35),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              fabric == null || fabric == FabricType.dontKnow
                                  ? 'Select fabric'
                                  : fabric.label,
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    fabric != null &&
                                        fabric != FabricType.dontKnow
                                    ? AppColors.secondary
                                    : Colors.white.withValues(alpha: 0.4),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else
                const Spacer(),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  final name = controller.text.trim();
                  if (name.isNotEmpty) {
                    ref
                        .read(cartProvider.notifier)
                        .addCustom(
                          name: name,
                          serviceId: serviceId,
                          quantity: qty,
                          fabric: fabric,
                        );
                    controller.clear();
                    ref.read(_customQtyProvider(serviceId).notifier).state = 1;
                    if (hasFabric) {
                      ref
                              .read(_customFabricProvider(serviceId).notifier)
                              .state =
                          FabricType.dontKnow;
                    }
                  }
                },
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.secondary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// LOCAL PROVIDERS
// =====================================================================

final _customControllerProvider = Provider.autoDispose
    .family<TextEditingController, String>((ref, _) {
      final c = TextEditingController();
      ref.onDispose(() => c.dispose());
      return c;
    });

final _customQtyProvider = StateProvider.autoDispose.family<int, String>(
  (ref, _) => 1,
);

final _customFabricProvider = StateProvider.autoDispose
    .family<FabricType, String>((ref, _) => FabricType.dontKnow);
