// // =====================================================================
// // IRON ONLY ITEM
// // =====================================================================

// class ShoeCleanItem {
//   final String id;
//   final String name;
//   final String emoji;

//   const ShoeCleanItem({
//     required this.id,
//     required this.name,
//     required this.emoji,
//   });
// }

// // =====================================================================
// // IRON ONLY CART ENTRY
// // =====================================================================

// class ShoeCleanCartEntry {
//   final String itemId;
//   final int quantity;
//   final String? customName;

//   const ShoeCleanCartEntry({
//     required this.itemId,
//     required this.quantity,
//     this.customName,
//   });

//   bool get isCustom => customName != null;

//   ShoeCleanCartEntry copyWith({int? quantity}) {
//     return ShoeCleanCartEntry(
//       itemId: itemId,
//       quantity: quantity ?? this.quantity,
//       customName: customName,
//     );
//   }
// }
