import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';

final specialInstructionsProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

class CartInstructionsCard extends ConsumerWidget {
  const CartInstructionsCard({super.key});

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
                ref.read(specialInstructionsProvider.notifier).state = val,
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
