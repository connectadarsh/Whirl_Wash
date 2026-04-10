import 'package:flutter/material.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';

class OrderItemRow extends StatelessWidget {
  final String itemId;
  final String? customName;
  final int quantity;
  final String? fabric;
  final String? imageUrl; // ← NEW

  const OrderItemRow({
    super.key,
    required this.itemId,
    required this.quantity,
    this.customName,
    this.fabric,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = customName ?? itemId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          // Avatar / Image
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: customName != null
                  ? AppColors.secondary.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: customName != null
                  ? Center(
                      child: Text(
                        customName![0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    )
                  : imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                      errorBuilder: (_, __, ___) => _placeholder(itemId),
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.secondary.withValues(alpha: 0.5),
                            ),
                          ),
                        );
                      },
                    )
                  : _placeholder(itemId),
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
                if (fabric != null &&
                    fabric != 'dontKnow' &&
                    fabric!.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    fabric!,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.secondary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Quantity badge
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

  Widget _placeholder(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
