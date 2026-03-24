// // ---------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:whirl_wash/features/home/data/models/fabric_type.dart';

// // =====================================================================
// // WASH FOLD ITEM
// // =====================================================================

// class WashIronItem {
//   final String id;
//   final String name;
//   final String emoji;

//   const WashIronItem({
//     required this.id,
//     required this.name,
//     required this.emoji,
//   });
// }

// // =====================================================================
// // WASH FOLD CART ENTRY
// // =====================================================================

// class WashIronCartEntry {
//   final String itemId;
//   final int quantity;
//   final FabricType fabric;
//   final String? customName; // non-null only for custom items

//   const WashIronCartEntry({
//     required this.itemId,
//     required this.quantity,
//     required this.fabric,
//     this.customName,
//   });

//   bool get isCustom => customName != null;

//   WashIronCartEntry copyWith({int? quantity, FabricType? fabric}) {
//     return WashIronCartEntry(
//       itemId: itemId,
//       quantity: quantity ?? this.quantity,
//       fabric: fabric ?? this.fabric,
//       customName: customName,
//     );
//   }

//   @override
//   String toString() =>
//       'WashIronCartEntry(itemId: $itemId, qty: $quantity, fabric: ${fabric.label})';
// }
