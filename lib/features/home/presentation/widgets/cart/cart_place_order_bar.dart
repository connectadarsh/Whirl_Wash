import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'package:whirl_wash/features/home/presentation/providers/cart_provider.dart';
import 'package:whirl_wash/features/home/presentation/widgets/cart/cart_instructions.dart';

class CartPlaceOrderBar extends ConsumerWidget {
  const CartPlaceOrderBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalItems = ref.watch(cartTotalProvider);
    final cart = ref.watch(cartProvider);
    final specialInstructions = ref.watch(specialInstructionsProvider);

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
