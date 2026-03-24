// // -------------------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:whirl_wash/features/home/data/models/fabric_type.dart';

// // =====================================================================
// // WASH FOLD ITEM
// // =====================================================================

// class WashFoldItem {
//   final String id;
//   final String name;
//   final String emoji;

//   const WashFoldItem({
//     required this.id,
//     required this.name,
//     required this.emoji,
//   });
// }

// // =====================================================================
// // WASH FOLD CART ENTRY
// // =====================================================================

// class WashFoldCartEntry {
//   final String itemId;
//   final int quantity;
//   final FabricType fabric;
//   final String? customName; // non-null only for custom items

//   const WashFoldCartEntry({
//     required this.itemId,
//     required this.quantity,
//     required this.fabric,
//     this.customName,
//   });

//   bool get isCustom => customName != null;

//   WashFoldCartEntry copyWith({int? quantity, FabricType? fabric}) {
//     return WashFoldCartEntry(
//       itemId: itemId,
//       quantity: quantity ?? this.quantity,
//       fabric: fabric ?? this.fabric,
//       customName: customName,
//     );
//   }

//   @override
//   String toString() =>
//       'WashFoldCartEntry(itemId: $itemId, qty: $quantity, fabric: ${fabric.label})';
// }
