// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:flutter/material.dart';
// import '../../data/models/iron_only_item.dart';

// // =====================================================================
// // CATALOGUE
// // =====================================================================

// const List<IronOnlyItem> ironOnlyCatalogue = [
//   IronOnlyItem(id: 'shirt', name: 'Shirt / T-Shirt', emoji: '👕'),
//   IronOnlyItem(id: 'pants', name: 'Pants / Jeans', emoji: '👖'),
//   IronOnlyItem(id: 'saree', name: 'Saree', emoji: '🥻'),
//   IronOnlyItem(id: 'churidar', name: 'Churidar', emoji: '👗'),
//   IronOnlyItem(id: 'kurta', name: 'Kurta', emoji: '👘'),
//   IronOnlyItem(id: 'jacket', name: 'Jacket', emoji: '🧥'),
//   IronOnlyItem(id: 'hoodie', name: 'Hoodie', emoji: '🫙'),
//   IronOnlyItem(id: 'bedsheet', name: 'Bedsheet', emoji: '🛏️'),
//   IronOnlyItem(id: 'pillow_cover', name: 'Pillow Cover', emoji: '🪫'),
//   IronOnlyItem(id: 'towel', name: 'Towel', emoji: '🏊'),
// ];

// // =====================================================================
// // CART NOTIFIER
// // =====================================================================

// class IronOnlyCartNotifier extends Notifier<Map<String, IronOnlyCartEntry>> {
//   @override
//   Map<String, IronOnlyCartEntry> build() => {};

//   void increment(String itemId) {
//     final current = state[itemId];
//     if (current == null) {
//       state = {
//         ...state,
//         itemId: IronOnlyCartEntry(itemId: itemId, quantity: 1),
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
//       final updated = Map<String, IronOnlyCartEntry>.from(state);
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
//       id: IronOnlyCartEntry(
//         itemId: id,
//         quantity: quantity,
//         customName: name.trim(),
//       ),
//     };
//   }

//   void clear() => state = {};

//   int get totalItems => state.values.fold(0, (sum, e) => sum + e.quantity);
// }

// final ironOnlyCartProvider =
//     NotifierProvider<IronOnlyCartNotifier, Map<String, IronOnlyCartEntry>>(
//       IronOnlyCartNotifier.new,
//     );

// // =====================================================================
// // SEARCH PROVIDER
// // =====================================================================

// final ironOnlySearchProvider = StateProvider.autoDispose<String>((ref) => '');
// ------------------------------------------------------------------------------------
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';

// // =====================================================================
// // CART ENTRY
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

// // =====================================================================
// // CART NOTIFIER
// // =====================================================================

// class IronOnlyCartNotifier extends Notifier<Map<String, IronOnlyCartEntry>> {
//   @override
//   Map<String, IronOnlyCartEntry> build() => {};

//   void increment(String itemId) {
//     final current = state[itemId];
//     if (current == null) {
//       state = {
//         ...state,
//         itemId: IronOnlyCartEntry(itemId: itemId, quantity: 1),
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
//       final updated = Map<String, IronOnlyCartEntry>.from(state);
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
//       id: IronOnlyCartEntry(
//         itemId: id,
//         quantity: quantity,
//         customName: name.trim(),
//       ),
//     };
//   }

//   void clear() => state = {};

//   int get totalItems => state.values.fold(0, (sum, e) => sum + e.quantity);
// }

// final ironOnlyCartProvider =
//     NotifierProvider<IronOnlyCartNotifier, Map<String, IronOnlyCartEntry>>(
//       IronOnlyCartNotifier.new,
//     );

// final ironOnlySearchProvider = StateProvider.autoDispose<String>((ref) => '');
