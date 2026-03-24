// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:flutter/material.dart';
// import 'package:whirl_wash/features/home/data/models/fabric_type.dart';
// import '../../data/models/wash_iron_item.dart';

// // =====================================================================
// // CATALOGUE
// // =====================================================================

// const List<WashIronItem> washIronCatalogue = [
//   WashIronItem(id: 'shirt', name: 'Shirt / T-Shirt', emoji: '👕'),
//   WashIronItem(id: 'pants', name: 'Pants / Jeans', emoji: '👖'),
//   WashIronItem(id: 'saree', name: 'Saree', emoji: '🥻'),
//   WashIronItem(id: 'churidar', name: 'Churidar', emoji: '👗'),
//   WashIronItem(id: 'jacket', name: 'Jacket', emoji: '🧥'),
//   WashIronItem(id: 'hoodie', name: 'Hoodie', emoji: '🫙'),
//   WashIronItem(id: 'bedsheet', name: 'Bedsheet', emoji: '🛏️'),
//   WashIronItem(id: 'pillow_cover', name: 'Pillow Cover', emoji: '🪫'),
//   WashIronItem(id: 'kurta', name: 'Kurta', emoji: '👘'),
//   WashIronItem(id: 'innerwear', name: 'Innerwear / Socks', emoji: '🧦'),
//   WashIronItem(id: 'towel', name: 'Towel', emoji: '🏊'),
// ];

// // =====================================================================
// // CART NOTIFIER
// // =====================================================================

// class WashIronCartNotifier extends Notifier<Map<String, WashIronCartEntry>> {
//   @override
//   Map<String, WashIronCartEntry> build() => {};

//   void increment(String itemId) {
//     final current = state[itemId];
//     if (current == null) {
//       state = {
//         ...state,
//         itemId: WashIronCartEntry(
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
//       final updated = Map<String, WashIronCartEntry>.from(state);
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
//       id: WashIronCartEntry(
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

// final washIronCartProvider =
//     NotifierProvider<WashIronCartNotifier, Map<String, WashIronCartEntry>>(
//       WashIronCartNotifier.new,
//     );

// // =====================================================================
// // SEARCH PROVIDER
// // =====================================================================

// final washIronSearchProvider = StateProvider.autoDispose<String>((ref) => '');
// ------------------------------------------------------------------------------------
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:whirl_wash/features/home/data/models/fabric_type.dart';

// // =====================================================================
// // CART ENTRY
// // =====================================================================

// class WashIronCartEntry {
//   final String itemId;
//   final int quantity;
//   final FabricType fabric;
//   final String? customName;

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
// }

// // =====================================================================
// // CART NOTIFIER
// // =====================================================================

// class WashIronCartNotifier extends Notifier<Map<String, WashIronCartEntry>> {
//   @override
//   Map<String, WashIronCartEntry> build() => {};

//   void increment(String itemId) {
//     final current = state[itemId];
//     if (current == null) {
//       state = {
//         ...state,
//         itemId: WashIronCartEntry(
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
//       final updated = Map<String, WashIronCartEntry>.from(state);
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
//       id: WashIronCartEntry(
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

// final washIronCartProvider =
//     NotifierProvider<WashIronCartNotifier, Map<String, WashIronCartEntry>>(
//       WashIronCartNotifier.new,
//     );

// final washIronSearchProvider = StateProvider.autoDispose<String>((ref) => '');
