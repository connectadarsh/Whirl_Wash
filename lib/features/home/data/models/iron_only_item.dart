// // =====================================================================
// // IRON ONLY ITEM
// // =====================================================================

// class IronOnlyItem {
//   final String id;
//   final String name;
//   final String emoji;

//   const IronOnlyItem({
//     required this.id,
//     required this.name,
//     required this.emoji,
//   });
// }

// // =====================================================================
// // IRON ONLY CART ENTRY
// // =====================================================================

// class IronOnlyCartEntry {
//   final String itemId;
//   final int quantity;
//   final String? customName;

//   const IronOnlyCartEntry({
//     required this.itemId,
//     required this.quantity,
//     this.customName,
//   });

//   bool get isCustom => customName != null;

//   IronOnlyCartEntry copyWith({int? quantity}) {
//     return IronOnlyCartEntry(
//       itemId: itemId,
//       quantity: quantity ?? this.quantity,
//       customName: customName,
//     );
//   }
// }
