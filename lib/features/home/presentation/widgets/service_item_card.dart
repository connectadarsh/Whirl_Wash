// import 'package:flutter/material.dart';
// import 'package:whirl_wash/features/home/data/models/fabric_type.dart';
// import 'package:whirl_wash/features/home/presentation/widgets/service_circle_btn.dart';
// import 'package:whirl_wash/features/home/presentation/widgets/service_fabric_sheet.dart';
// import '../../../../../core/constants/app_colors.dart';

// class ServiceItemCard extends StatelessWidget {
//   final String emoji;
//   final String name;
//   final int quantity;
//   final FabricType? fabric; // null = no fabric row shown
//   final String quantityLabel; // 'item' or 'pair'
//   final VoidCallback onIncrement;
//   final VoidCallback onDecrement;
//   final void Function(FabricType)? onFabricSelect; // null = hide fabric row

//   const ServiceItemCard({
//     super.key,
//     required this.emoji,
//     required this.name,
//     required this.quantity,
//     required this.onIncrement,
//     required this.onDecrement,
//     this.fabric,
//     this.quantityLabel = 'item',
//     this.onFabricSelect,
//   });

//   bool get _isInCart => quantity > 0;
//   bool get _showFabric => onFabricSelect != null;
//   bool get _hasSelection => fabric != null && fabric != FabricType.dontKnow;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: _isInCart ? const Color(0xFF1A1A1A) : const Color(0xFF141414),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: _isInCart
//               ? AppColors.secondary.withValues(alpha: 0.35)
//               : Colors.white.withValues(alpha: 0.07),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         children: [
//           // Main row
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Row(
//               children: [
//                 // Emoji container
//                 Container(
//                   width: 56,
//                   height: 56,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.06),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Center(
//                     child: Text(emoji, style: const TextStyle(fontSize: 28)),
//                   ),
//                 ),
//                 const SizedBox(width: 14),

//                 // Name + quantity badge
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         name,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                       if (_isInCart) ...[
//                         const SizedBox(height: 5),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 3,
//                           ),
//                           decoration: BoxDecoration(
//                             color: AppColors.secondary.withValues(alpha: 0.15),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             '$quantity $quantityLabel${quantity > 1 ? 's' : ''}',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: AppColors.secondary,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),

//                 // Quantity control
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     ServiceCircleBtn(
//                       icon: Icons.remove,
//                       onTap: quantity > 0 ? onDecrement : null,
//                       active: quantity > 0,
//                     ),
//                     SizedBox(
//                       width: 36,
//                       child: Text(
//                         '$quantity',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                           color: quantity > 0
//                               ? Colors.white
//                               : Colors.white.withValues(alpha: 0.4),
//                         ),
//                       ),
//                     ),
//                     ServiceCircleBtn(
//                       icon: Icons.add,
//                       onTap: onIncrement,
//                       active: true,
//                       filled: true,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Fabric row — only shown when onFabricSelect is provided
//           if (_showFabric) ...[
//             Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
//             GestureDetector(
//               onTap: _isInCart
//                   ? () => showModalBottomSheet(
//                       context: context,
//                       backgroundColor: Colors.transparent,
//                       isScrollControlled: true,
//                       builder: (_) => ServiceFabricSheet(
//                         itemName: name,
//                         itemEmoji: emoji,
//                         selected: fabric ?? FabricType.dontKnow,
//                         onSelect: onFabricSelect!,
//                       ),
//                     )
//                   : null,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 14,
//                   vertical: 12,
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.texture_rounded,
//                       size: 17,
//                       color: _hasSelection
//                           ? AppColors.secondary.withValues(alpha: 0.8)
//                           : Colors.white.withValues(
//                               alpha: _isInCart ? 0.35 : 0.2,
//                             ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Text(
//                         _hasSelection ? fabric!.label : 'Select fabric',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: _hasSelection
//                               ? AppColors.secondary
//                               : Colors.white.withValues(
//                                   alpha: _isInCart ? 0.4 : 0.22,
//                                 ),
//                           fontWeight: _hasSelection
//                               ? FontWeight.w500
//                               : FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                     Icon(
//                       Icons.keyboard_arrow_down_rounded,
//                       size: 18,
//                       color: Colors.white.withValues(
//                         alpha: _isInCart ? 0.35 : 0.15,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
// -----------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:whirl_wash/features/home/data/models/fabric_type.dart';
// import 'package:whirl_wash/features/home/presentation/widgets/service_circle_btn.dart';
// import 'package:whirl_wash/features/home/presentation/widgets/service_fabric_sheet.dart';
// import '../../../../../core/constants/app_colors.dart';

// class ServiceItemCard extends StatelessWidget {
//   final String emoji;
//   final String name;
//   final int quantity;
//   final FabricType? fabric;
//   final String quantityLabel;
//   final VoidCallback onIncrement;
//   final VoidCallback onDecrement;
//   final void Function(FabricType)? onFabricSelect;
//   final bool enabled; // false = faded, controls disabled

//   const ServiceItemCard({
//     super.key,
//     required this.emoji,
//     required this.name,
//     required this.quantity,
//     required this.onIncrement,
//     required this.onDecrement,
//     this.fabric,
//     this.quantityLabel = 'item',
//     this.onFabricSelect,
//     this.enabled = true,
//   });

//   bool get _isInCart => quantity > 0;
//   bool get _showFabric => onFabricSelect != null;
//   bool get _hasSelection => fabric != null && fabric != FabricType.dontKnow;

//   @override
//   Widget build(BuildContext context) {
//     return Opacity(
//       opacity: enabled ? 1.0 : 0.4,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           color: _isInCart ? const Color(0xFF1A1A1A) : const Color(0xFF141414),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: _isInCart
//                 ? AppColors.secondary.withValues(alpha: 0.35)
//                 : Colors.white.withValues(alpha: 0.07),
//             width: 1,
//           ),
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(14),
//               child: Row(
//                 children: [
//                   // Emoji container
//                   Container(
//                     width: 56,
//                     height: 56,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withValues(alpha: 0.06),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Center(
//                       child: Text(emoji, style: const TextStyle(fontSize: 28)),
//                     ),
//                   ),
//                   const SizedBox(width: 14),

//                   // Name + badge + unavailable tag
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           name,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         if (!enabled)
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 3,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withValues(alpha: 0.08),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               'Unavailable',
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.white.withValues(alpha: 0.5),
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           )
//                         else if (_isInCart) ...[
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 3,
//                             ),
//                             decoration: BoxDecoration(
//                               color: AppColors.secondary.withValues(
//                                 alpha: 0.15,
//                               ),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               '$quantity $quantityLabel${quantity > 1 ? 's' : ''}',
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: AppColors.secondary,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),

//                   // Quantity control — disabled when item unavailable
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ServiceCircleBtn(
//                         icon: Icons.remove,
//                         onTap: enabled && quantity > 0 ? onDecrement : null,
//                         active: enabled && quantity > 0,
//                       ),
//                       SizedBox(
//                         width: 36,
//                         child: Text(
//                           '$quantity',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                             color: quantity > 0
//                                 ? Colors.white
//                                 : Colors.white.withValues(alpha: 0.4),
//                           ),
//                         ),
//                       ),
//                       ServiceCircleBtn(
//                         icon: Icons.add,
//                         onTap: enabled ? onIncrement : null,
//                         active: enabled,
//                         filled: true,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             // Fabric row
//             if (_showFabric) ...[
//               Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
//               GestureDetector(
//                 onTap: enabled && _isInCart
//                     ? () => showModalBottomSheet(
//                         context: context,
//                         backgroundColor: Colors.transparent,
//                         isScrollControlled: true,
//                         builder: (_) => ServiceFabricSheet(
//                           itemName: name,
//                           itemEmoji: emoji,
//                           selected: fabric ?? FabricType.dontKnow,
//                           onSelect: onFabricSelect!,
//                         ),
//                       )
//                     : null,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                     vertical: 12,
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.texture_rounded,
//                         size: 17,
//                         color: _hasSelection
//                             ? AppColors.secondary.withValues(alpha: 0.8)
//                             : Colors.white.withValues(
//                                 alpha: _isInCart ? 0.35 : 0.2,
//                               ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           _hasSelection ? fabric!.label : 'Select fabric',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: _hasSelection
//                                 ? AppColors.secondary
//                                 : Colors.white.withValues(
//                                     alpha: _isInCart ? 0.4 : 0.22,
//                                   ),
//                             fontWeight: _hasSelection
//                                 ? FontWeight.w500
//                                 : FontWeight.w400,
//                           ),
//                         ),
//                       ),
//                       Icon(
//                         Icons.keyboard_arrow_down_rounded,
//                         size: 18,
//                         color: Colors.white.withValues(
//                           alpha: _isInCart ? 0.35 : 0.15,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// -----------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:whirl_wash/features/home/data/models/fabric_type.dart';
import 'package:whirl_wash/features/home/presentation/widgets/service_circle_btn.dart';
import 'package:whirl_wash/features/home/presentation/widgets/service_fabric_sheet.dart';
import '../../../../../core/constants/app_colors.dart';

class ServiceItemCard extends StatelessWidget {
  final String emoji;
  final String name;
  final int quantity;
  final FabricType? fabric;
  final String quantityLabel;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final void Function(FabricType)? onFabricSelect;
  final bool enabled;
  final bool isCustom;

  const ServiceItemCard({
    super.key,
    required this.emoji,
    required this.name,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.fabric,
    this.quantityLabel = 'item',
    this.onFabricSelect,
    this.enabled = true,
    this.isCustom = false,
  });

  bool get _isInCart => quantity > 0;
  bool get _showFabric => onFabricSelect != null;
  bool get _hasSelection => fabric != null && fabric != FabricType.dontKnow;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _isInCart ? const Color(0xFF1A1A1A) : const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isInCart
                ? AppColors.secondary.withValues(alpha: 0.35)
                : Colors.white.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Emoji container
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isCustom
                          ? AppColors.secondary.withValues(alpha: 0.15)
                          : Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: isCustom
                          ? Text(
                              name[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            )
                          : Text(emoji, style: const TextStyle(fontSize: 28)),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Name + badge + unavailable tag
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (!enabled)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Unavailable',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        else if (_isInCart) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$quantity $quantityLabel${quantity > 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Quantity control — disabled when item unavailable
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ServiceCircleBtn(
                        icon: Icons.remove,
                        onTap: enabled && quantity > 0 ? onDecrement : null,
                        active: enabled && quantity > 0,
                      ),
                      SizedBox(
                        width: 36,
                        child: Text(
                          '$quantity',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: quantity > 0
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                      ServiceCircleBtn(
                        icon: Icons.add,
                        onTap: enabled ? onIncrement : null,
                        active: enabled,
                        filled: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Fabric row
            if (_showFabric) ...[
              Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
              GestureDetector(
                onTap: enabled && _isInCart
                    ? () => showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) => ServiceFabricSheet(
                          itemName: name,
                          itemEmoji: emoji,
                          selected: fabric ?? FabricType.dontKnow,
                          onSelect: onFabricSelect!,
                        ),
                      )
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.texture_rounded,
                        size: 17,
                        color: _hasSelection
                            ? AppColors.secondary.withValues(alpha: 0.8)
                            : Colors.white.withValues(
                                alpha: _isInCart ? 0.35 : 0.2,
                              ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _hasSelection ? fabric!.label : 'Select fabric',
                          style: TextStyle(
                            fontSize: 13,
                            color: _hasSelection
                                ? AppColors.secondary
                                : Colors.white.withValues(
                                    alpha: _isInCart ? 0.4 : 0.22,
                                  ),
                            fontWeight: _hasSelection
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: Colors.white.withValues(
                          alpha: _isInCart ? 0.35 : 0.15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
