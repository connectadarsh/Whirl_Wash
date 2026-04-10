import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'package:whirl_wash/features/home/data/repositories/cart_repository.dart';
import 'package:whirl_wash/features/home/presentation/providers/cart_provider.dart';

class ServiceBottomBar extends ConsumerWidget {
  final Color? accentColor;

  const ServiceBottomBar({super.key, this.accentColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalItems = ref.watch(cartTotalProvider);
    final hasItems = totalItems > 0;
    final color = accentColor ?? AppColors.secondary;

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
      child: Row(
        children: [
          // Add to Cart button
          Expanded(
            child: GestureDetector(
              onTap: hasItems
                  ? () async {
                      final uid = FirebaseAuth.instance.currentUser?.uid;
                      if (uid == null) return;
                      await CartRepository().saveCart(
                        uid,
                        ref.read(cartProvider),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: color,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                const Text('Your Cart Has Been Saved'),
                              ],
                            ),
                            backgroundColor: const Color(0xFF1A1A1A),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  : null,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: hasItems
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: hasItems
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: hasItems
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.3),
                          size: 20,
                        ),
                        if (hasItems)
                          Positioned(
                            top: -6,
                            right: -8,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$totalItems',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Save Cart',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: hasItems
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Go to Cart button
          Expanded(
            child: GestureDetector(
              onTap: hasItems ? () => context.push('/cart') : null,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: hasItems ? color : color.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'Go to Cart',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: hasItems
                          ? Colors.black
                          : Colors.black.withValues(alpha: 0.4),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
