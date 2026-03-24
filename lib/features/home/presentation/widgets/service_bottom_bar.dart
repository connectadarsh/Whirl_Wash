// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../../core/constants/app_colors.dart';

// class ServiceBottomBar extends ConsumerWidget {
//   final int totalItems;
//   final Color? accentColor;

//   const ServiceBottomBar({
//     super.key,
//     required this.totalItems,
//     this.accentColor,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final hasItems = totalItems > 0;
//     final color = accentColor ?? AppColors.secondary;

//     return Container(
//       padding: EdgeInsets.fromLTRB(
//         16,
//         12,
//         16,
//         MediaQuery.of(context).padding.bottom + 12,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         border: Border(
//           top: BorderSide(
//             color: Colors.white.withValues(alpha: 0.07),
//             width: 1,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           // Cart icon with badge
//           GestureDetector(
//             onTap: () => context.go('/home'),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 Container(
//                   width: 52,
//                   height: 52,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.06),
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(
//                       color: Colors.white.withValues(alpha: 0.1),
//                       width: 1,
//                     ),
//                   ),
//                   child: Icon(
//                     Icons.shopping_cart_outlined,
//                     color: hasItems
//                         ? Colors.white
//                         : Colors.white.withValues(alpha: 0.3),
//                     size: 24,
//                   ),
//                 ),
//                 if (hasItems)
//                   Positioned(
//                     top: -5,
//                     right: -5,
//                     child: Container(
//                       width: 20,
//                       height: 20,
//                       decoration: const BoxDecoration(
//                         color: Colors.red,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Text(
//                           '$totalItems',
//                           style: const TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),

//           const SizedBox(width: 12),

//           // Go to Cart button
//           Expanded(
//             child: GestureDetector(
//               onTap: hasItems ? () => context.go('/home') : null,
//               child: Container(
//                 height: 52,
//                 decoration: BoxDecoration(
//                   color: hasItems ? color : color.withValues(alpha: 0.3),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Go to Cart',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                       color: hasItems
//                           ? Colors.black
//                           : Colors.black.withValues(alpha: 0.4),
//                       letterSpacing: 0.3,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// --------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whirl_wash/features/home/presentation/providers/cart_provider.dart';
import '../../../../../core/constants/app_colors.dart';

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
          // Cart icon with badge
          GestureDetector(
            onTap: () => context.go('/home'),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: hasItems
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.3),
                    size: 24,
                  ),
                ),
                if (hasItems)
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$totalItems',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Go to Cart button
          Expanded(
            child: GestureDetector(
              onTap: hasItems ? () => context.go('/home') : null,
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
                      fontSize: 15,
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
