// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:flutter/material.dart';
// import 'package:whirl_wash/features/home/data/models/fabric_type.dart';
// import '../../data/models/dry_clean_item.dart';

// // =====================================================================
// // CATALOGUE
// // =====================================================================

// const List<DryCleanItem> dryCleanCatalogue = [
//   DryCleanItem(id: 'suit_blazer', name: 'Suit / Blazer', emoji: '🤵'),
//   DryCleanItem(id: 'saree_heavy', name: 'Saree (Silk / Heavy)', emoji: '🥻'),
//   DryCleanItem(id: 'sherwani', name: 'Sherwani', emoji: '👘'),
//   DryCleanItem(id: 'gown_dress', name: 'Gown / Dress', emoji: '👗'),
//   DryCleanItem(id: 'woolen_sweater', name: 'Woolen Sweater', emoji: '🧶'),
//   DryCleanItem(id: 'leather_jacket', name: 'Leather Jacket', emoji: '🧥'),
//   DryCleanItem(id: 'curtains', name: 'Curtains', emoji: '🪟'),
//   DryCleanItem(id: 'blanket_quilt', name: 'Blanket / Quilt', emoji: '🛌'),
//   DryCleanItem(id: 'tie_scarf', name: 'Tie / Scarf', emoji: '🧣'),
//   DryCleanItem(id: 'carpet_rug', name: 'Carpet / Rug', emoji: '🪺'),
// ];

// // =====================================================================
// // CART NOTIFIER
// // =====================================================================

// class DryCleanCartNotifier extends Notifier<Map<String, DryCleanCartEntry>> {
//   @override
//   Map<String, DryCleanCartEntry> build() => {};

//   void increment(String itemId) {
//     final current = state[itemId];
//     if (current == null) {
//       state = {
//         ...state,
//         itemId: DryCleanCartEntry(
//           itemId: itemId,
//           quantity: 1,
//           fabric: FabricType.dontKnow,
//         ),
//       };
//     } else {
//       state = {
//         ...state,
//         itemId: current.copyWith(quantity: current.quantity + 1),
//       };
//     }
//   }

//   void decrement(String itemId) {
//     final current = state[itemId];
//     if (current == null) return;
//     if (current.quantity <= 1) {
//       final updated = Map<String, DryCleanCartEntry>.from(state);
//       updated.remove(itemId);
//       state = updated;
//     } else {
//       state = {
//         ...state,
//         itemId: current.copyWith(quantity: current.quantity - 1),
//       };
//     }
//   }

//   void setFabric(String itemId, FabricType fabric) {
//     final current = state[itemId];
//     if (current == null) return;
//     state = {...state, itemId: current.copyWith(fabric: fabric)};
//   }

//   void addCustom(String name, int quantity, FabricType fabric) {
//     if (name.trim().isEmpty || quantity < 1) return;
//     // Use timestamp-based unique id for custom items
//     final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
//     state = {
//       ...state,
//       id: DryCleanCartEntry(
//         itemId: id,
//         quantity: quantity,
//         fabric: fabric,
//         customName: name.trim(),
//       ),
//     };
//   }

//   void clear() => state = {};

//   int get totalItems => state.values.fold(0, (sum, e) => sum + e.quantity);
// }

// final dryCleanCartProvider =
//     NotifierProvider<DryCleanCartNotifier, Map<String, DryCleanCartEntry>>(
//       DryCleanCartNotifier.new,
//     );

// // =====================================================================
// // SEARCH PROVIDER
// // =====================================================================

// final dryCleanSearchProvider = StateProvider.autoDispose<String>((ref) => '');
// --------------------------------------------------------------------------------------
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:whirl_wash/features/home/data/models/fabric_type.dart';

// // =====================================================================
// // CART ENTRY
// // =====================================================================

// class DryCleanCartEntry {
//   final String itemId;
//   final int quantity;
//   final FabricType fabric;
//   final String? customName;

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
// }

// // =====================================================================
// // CART NOTIFIER
// // =====================================================================

// class DryCleanCartNotifier extends Notifier<Map<String, DryCleanCartEntry>> {
//   @override
//   Map<String, DryCleanCartEntry> build() => {};

//   void increment(String itemId) {
//     final current = state[itemId];
//     if (current == null) {
//       state = {
//         ...state,
//         itemId: DryCleanCartEntry(
//           itemId: itemId,
//           quantity: 1,
//           fabric: FabricType.dontKnow,
//         ),
//       };
//     } else {
//       state = {
//         ...state,
//         itemId: current.copyWith(quantity: current.quantity + 1),
//       };
//     }
//   }

//   void decrement(String itemId) {
//     final current = state[itemId];
//     if (current == null) return;
//     if (current.quantity <= 1) {
//       final updated = Map<String, DryCleanCartEntry>.from(state);
//       updated.remove(itemId);
//       state = updated;
//     } else {
//       state = {
//         ...state,
//         itemId: current.copyWith(quantity: current.quantity - 1),
//       };
//     }
//   }

//   void setFabric(String itemId, FabricType fabric) {
//     final current = state[itemId];
//     if (current == null) return;
//     state = {...state, itemId: current.copyWith(fabric: fabric)};
//   }

//   void addCustom(String name, int quantity, FabricType fabric) {
//     if (name.trim().isEmpty || quantity < 1) return;
//     final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
//     state = {
//       ...state,
//       id: DryCleanCartEntry(
//         itemId: id,
//         quantity: quantity,
//         fabric: fabric,
//         customName: name.trim(),
//       ),
//     };
//   }

//   void clear() => state = {};

//   int get totalItems => state.values.fold(0, (sum, e) => sum + e.quantity);
// }

// final dryCleanCartProvider =
//     NotifierProvider<DryCleanCartNotifier, Map<String, DryCleanCartEntry>>(
//       DryCleanCartNotifier.new,
//     );

// final dryCleanSearchProvider = StateProvider.autoDispose<String>((ref) => '');
