// // ----------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:whirl_wash/features/home/data/models/fabric_type.dart';

// // =====================================================================
// // WASH FOLD ITEM
// // =====================================================================

// class DryCleanItem {
//   final String id;
//   final String name;
//   final String emoji;

//   const DryCleanItem({
//     required this.id,
//     required this.name,
//     required this.emoji,
//   });
// }

// // =====================================================================
// // WASH FOLD CART ENTRY
// // =====================================================================

// class DryCleanCartEntry {
//   final String itemId;
//   final int quantity;
//   final FabricType fabric;
//   final String? customName; // non-null only for custom items

//   const DryCleanCartEntry({
//     required this.itemId,
//     required this.quantity,
//     required this.fabric,
//     this.customName,
//   });

//   bool get isCustom => customName != null;

//   DryCleanCartEntry copyWith({int? quantity, FabricType? fabric}) {
//     return DryCleanCartEntry(
//       itemId: itemId,
//       quantity: quantity ?? this.quantity,
//       fabric: fabric ?? this.fabric,
//       customName: customName,
//     );
//   }

//   @override
//   String toString() =>
//       'DryCleanCartEntry(itemId: $itemId, qty: $quantity, fabric: ${fabric.label})';
// }
