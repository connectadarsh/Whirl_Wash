import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'package:whirl_wash/features/home/data/models/cart_entry.dart';
import 'package:whirl_wash/features/home/data/models/fabric_type.dart';
import 'package:whirl_wash/features/home/presentation/providers/cart_provider.dart';

class CartItemRow extends ConsumerWidget {
  final CartEntry entry;
  final String serviceId;

  const CartItemRow({super.key, required this.entry, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(cartProvider.notifier);
    final displayName = entry.isCustom ? entry.customName! : entry.itemId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          // Image / Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: entry.isCustom
                  ? AppColors.secondary.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: entry.isCustom
                  ? Center(
                      child: Text(
                        entry.customName![0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    )
                  : entry.imageUrl != null
                  ? Image.network(
                      entry.imageUrl!,
                      fit: BoxFit.cover,
                      width: 44,
                      height: 44,
                      errorBuilder: (_, __, ___) => _placeholder(displayName),
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.secondary.withValues(alpha: 0.5),
                            ),
                          ),
                        );
                      },
                    )
                  : _placeholder(displayName),
            ),
          ),
          const SizedBox(width: 12),

          // Name + fabric
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

          // Quantity controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CartSmallBtn(
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
              CartSmallBtn(
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

  Widget _placeholder(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

// =====================================================================
// SMALL BUTTON
// =====================================================================

class CartSmallBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const CartSmallBtn({
    super.key,
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
