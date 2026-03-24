// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:flutter/material.dart';
// import '../../data/models/shoe_clean_item.dart';

// // =====================================================================
// // CATALOGUE
// // =====================================================================

// const List<ShoeCleanItem> shoeCleanCatalogue = [
//   ShoeCleanItem(id: 'sneakers', name: 'Sneakers / Sports Shoes', emoji: '👟'),
//   ShoeCleanItem(id: 'formal', name: 'Formal Shoes', emoji: '👞'),
//   ShoeCleanItem(id: 'sandals', name: 'Sandals / Slippers', emoji: '👡'),
//   ShoeCleanItem(id: 'boots', name: 'Boots', emoji: '👢'),
//   ShoeCleanItem(id: 'heels', name: 'Heels', emoji: '👠'),
//   ShoeCleanItem(id: 'loafers', name: 'Loafers', emoji: '🥿'),
//   ShoeCleanItem(id: 'flipflops', name: 'Flip Flops', emoji: '🩴'),
// ];

// // =====================================================================
// // CART NOTIFIER
// // =====================================================================

// class ShoeCleanCartNotifier extends Notifier<Map<String, ShoeCleanCartEntry>> {
//   @override
//   Map<String, ShoeCleanCartEntry> build() => {};

//   void increment(String itemId) {
//     final current = state[itemId];
//     if (current == null) {
//       state = {
//         ...state,
//         itemId: ShoeCleanCartEntry(itemId: itemId, quantity: 1),
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
//       final updated = Map<String, ShoeCleanCartEntry>.from(state);
//       updated.remove(itemId);
//       state = updated;
//     } else {
//       state = {
//         ...state,
//         itemId: current.copyWith(quantity: current.quantity - 1),
//       };
//     }
//   }

//   void addCustom(String name, int quantity) {
//     if (name.trim().isEmpty || quantity < 1) return;
//     final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
//     state = {
//       ...state,
//       id: ShoeCleanCartEntry(
//         itemId: id,
//         quantity: quantity,
//         customName: name.trim(),
//       ),
//     };
//   }

//   void clear() => state = {};

//   int get totalItems => state.values.fold(0, (sum, e) => sum + e.quantity);
// }

// final shoeCleanCartProvider =
//     NotifierProvider<ShoeCleanCartNotifier, Map<String, ShoeCleanCartEntry>>(
//       ShoeCleanCartNotifier.new,
//     );

// // =====================================================================
// // SEARCH PROVIDER
// // =====================================================================

// final shoeCleanSearchProvider = StateProvider.autoDispose<String>((ref) => '');
// -----------------------------------------------------------------------------------------
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';

// // =====================================================================
// // CART ENTRY
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

// // =====================================================================
// // CART NOTIFIER
// // =====================================================================

// class ShoeCleanCartNotifier extends Notifier<Map<String, ShoeCleanCartEntry>> {
//   @override
//   Map<String, ShoeCleanCartEntry> build() => {};

//   void increment(String itemId) {
//     final current = state[itemId];
//     if (current == null) {
//       state = {
//         ...state,
//         itemId: ShoeCleanCartEntry(itemId: itemId, quantity: 1),
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
//       final updated = Map<String, ShoeCleanCartEntry>.from(state);
//       updated.remove(itemId);
//       state = updated;
//     } else {
//       state = {
//         ...state,
//         itemId: current.copyWith(quantity: current.quantity - 1),
//       };
//     }
//   }

//   void addCustom(String name, int quantity) {
//     if (name.trim().isEmpty || quantity < 1) return;
//     final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
//     state = {
//       ...state,
//       id: ShoeCleanCartEntry(
//         itemId: id,
//         quantity: quantity,
//         customName: name.trim(),
//       ),
//     };
//   }

//   void clear() => state = {};

//   int get totalItems => state.values.fold(0, (sum, e) => sum + e.quantity);
// }

// final shoeCleanCartProvider =
//     NotifierProvider<ShoeCleanCartNotifier, Map<String, ShoeCleanCartEntry>>(
//       ShoeCleanCartNotifier.new,
//     );

// final shoeCleanSearchProvider = StateProvider.autoDispose<String>((ref) => '');
