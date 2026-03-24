// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:flutter/material.dart';
// import '../../data/models/wash_fold_item.dart';

// // =====================================================================
// // CATALOGUE
// // =====================================================================

// const List<WashFoldItem> washFoldCatalogue = [
//   WashFoldItem(
//     id: 'shirt',
//     name: 'Shirt / T-Shirt',
//     emoji: '👕',
//     icon: Icons.dry_cleaning_rounded,
//     accentColor: Color(0xFF4ECDC4),
//   ),
//   WashFoldItem(
//     id: 'pants',
//     name: 'Pants / Jeans',
//     emoji: '👖',
//     icon: Icons.accessibility_new_rounded,
//     accentColor: Color(0xFF8B5CF6),
//   ),
//   WashFoldItem(
//     id: 'saree',
//     name: 'Saree / Churidar',
//     emoji: '🥻',
//     icon: Icons.auto_awesome_rounded,
//     accentColor: Color(0xFFF59E0B),
//   ),
//   WashFoldItem(
//     id: 'bedsheet',
//     name: 'Bedsheet / Pillow Cover',
//     emoji: '🛏️',
//     icon: Icons.bed_rounded,
//     accentColor: Color(0xFF10B981),
//   ),
//   WashFoldItem(
//     id: 'jacket',
//     name: 'Jacket / Hoodie',
//     emoji: '🧥',
//     icon: Icons.downhill_skiing_rounded,
//     accentColor: Color(0xFFEF4444),
//   ),
// ];

// // =====================================================================
// // CART NOTIFIER
// // =====================================================================

// class WashFoldCartNotifier extends Notifier<Map<String, WashFoldCartEntry>> {
//   @override
//   Map<String, WashFoldCartEntry> build() => {};

//   void increment(String itemId) {
//     final current = state[itemId];
//     if (current == null) {
//       state = {
//         ...state,
//         itemId: WashFoldCartEntry(
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
//       final updated = Map<String, WashFoldCartEntry>.from(state);
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

//   void clear() => state = {};

//   int get totalItems => state.values.fold(0, (sum, e) => sum + e.quantity);
// }

// final washFoldCartProvider =
//     NotifierProvider<WashFoldCartNotifier, Map<String, WashFoldCartEntry>>(
//       WashFoldCartNotifier.new,
//     );

// // =====================================================================
// // SEARCH PROVIDER
// // =====================================================================

// final washFoldSearchProvider = StateProvider.autoDispose<String>((ref) => '');

// // =====================================================================
// // EXPANDED FABRIC PANEL
// // =====================================================================

// ----------------------------------------------------------------------------------------------------------

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:flutter/material.dart';
// import '../../data/models/wash_fold_item.dart';

// // =====================================================================
// // CATALOGUE
// // =====================================================================

// const List<WashFoldItem> washFoldCatalogue = [
//   WashFoldItem(
//     id: 'shirt',
//     name: 'Shirt / T-Shirt',
//     emoji: '👕',
//     icon: Icons.dry_cleaning_rounded,
//     accentColor: Color(0xFF4ECDC4),
//   ),
//   WashFoldItem(
//     id: 'pants',
//     name: 'Pants / Jeans',
//     emoji: '👖',
//     icon: Icons.accessibility_new_rounded,
//     accentColor: Color(0xFF8B5CF6),
//   ),
//   WashFoldItem(
//     id: 'saree',
//     name: 'Saree',
//     emoji: '🥻',
//     icon: Icons.auto_awesome_rounded,
//     accentColor: Color(0xFFF59E0B),
//   ),
//   WashFoldItem(
//     id: 'churidar',
//     name: 'Churidar',
//     emoji: '👗',
//     icon: Icons.auto_awesome_rounded,
//     accentColor: Color(0xFFF59E0B),
//   ),
//   WashFoldItem(
//     id: 'jacket',
//     name: 'Jacket',
//     emoji: '🧥',
//     icon: Icons.downhill_skiing_rounded,
//     accentColor: Color(0xFFEF4444),
//   ),
//   WashFoldItem(
//     id: 'hoodie',
//     name: 'Hoodie',
//     emoji: '🫙',
//     icon: Icons.downhill_skiing_rounded,
//     accentColor: Color(0xFFEF4444),
//   ),
//   WashFoldItem(
//     id: 'bedsheet',
//     name: 'Bedsheet',
//     emoji: '🛏️',
//     icon: Icons.bed_rounded,
//     accentColor: Color(0xFF10B981),
//   ),
// ];

// // =====================================================================
// // CART NOTIFIER
// // =====================================================================

// class WashFoldCartNotifier extends Notifier<Map<String, WashFoldCartEntry>> {
//   @override
//   Map<String, WashFoldCartEntry> build() => {};

//   void increment(String itemId) {
//     final current = state[itemId];
//     if (current == null) {
//       state = {
//         ...state,
//         itemId: WashFoldCartEntry(
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
//       final updated = Map<String, WashFoldCartEntry>.from(state);
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

//   void clear() => state = {};

//   int get totalItems => state.values.fold(0, (sum, e) => sum + e.quantity);
// }

// final washFoldCartProvider =
//     NotifierProvider<WashFoldCartNotifier, Map<String, WashFoldCartEntry>>(
//       WashFoldCartNotifier.new,
//     );

// // =====================================================================
// // SEARCH PROVIDER
// // =====================================================================

// final washFoldSearchProvider = StateProvider.autoDispose<String>((ref) => '');

// // =====================================================================
// // CUSTOM ITEMS PROVIDER
// // =====================================================================

// class WashFoldCustomEntry {
//   final String name;
//   final int quantity;
//   final FabricType fabric;

//   const WashFoldCustomEntry({
//     required this.name,
//     required this.quantity,
//     required this.fabric,
//   });

//   WashFoldCustomEntry copyWith({
//     String? name,
//     int? quantity,
//     FabricType? fabric,
//   }) {
//     return WashFoldCustomEntry(
//       name: name ?? this.name,
//       quantity: quantity ?? this.quantity,
//       fabric: fabric ?? this.fabric,
//     );
//   }
// }

// class WashFoldCustomNotifier extends Notifier<List<WashFoldCustomEntry>> {
//   @override
//   List<WashFoldCustomEntry> build() => [];

//   void add(String name) {
//     if (name.trim().isEmpty) return;
//     state = [
//       ...state,
//       WashFoldCustomEntry(
//         name: name.trim(),
//         quantity: 1,
//         fabric: FabricType.dontKnow,
//       ),
//     ];
//   }

//   void increment(int index) {
//     final updated = List<WashFoldCustomEntry>.from(state);
//     updated[index] = updated[index].copyWith(
//       quantity: updated[index].quantity + 1,
//     );
//     state = updated;
//   }

//   void decrement(int index) {
//     final updated = List<WashFoldCustomEntry>.from(state);
//     if (updated[index].quantity <= 1) {
//       updated.removeAt(index);
//     } else {
//       updated[index] = updated[index].copyWith(
//         quantity: updated[index].quantity - 1,
//       );
//     }
//     state = updated;
//   }

//   void setFabric(int index, FabricType fabric) {
//     final updated = List<WashFoldCustomEntry>.from(state);
//     updated[index] = updated[index].copyWith(fabric: fabric);
//     state = updated;
//   }

//   void remove(int index) {
//     final updated = List<WashFoldCustomEntry>.from(state);
//     updated.removeAt(index);
//     state = updated;
//   }

//   int get totalItems => state.fold(0, (sum, e) => sum + e.quantity);
// }

// final washFoldCustomProvider =
//     NotifierProvider<WashFoldCustomNotifier, List<WashFoldCustomEntry>>(
//       WashFoldCustomNotifier.new,
//     );

// --------------------------------------------------------------------------

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:flutter/material.dart';
// import 'package:whirl_wash/features/home/data/models/fabric_type.dart';
// import '../../data/models/wash_fold_item.dart';

// // =====================================================================
// // CATALOGUE
// // =====================================================================

// const List<WashFoldItem> washFoldCatalogue = [
//   WashFoldItem(id: 'shirt', name: 'Shirt / T-Shirt', emoji: '👕'),
//   WashFoldItem(id: 'pants', name: 'Pants / Jeans', emoji: '👖'),
//   WashFoldItem(id: 'saree', name: 'Saree', emoji: '🥻'),
//   WashFoldItem(id: 'churidar', name: 'Churidar', emoji: '👗'),
//   WashFoldItem(id: 'jacket', name: 'Jacket', emoji: '🧥'),
//   WashFoldItem(id: 'hoodie', name: 'Hoodie', emoji: '🫙'),
//   WashFoldItem(id: 'bedsheet', name: 'Bedsheet', emoji: '🛏️'),
//   WashFoldItem(id: 'pillow_cover', name: 'Pillow Cover', emoji: '🪫'),
//   WashFoldItem(id: 'kurta', name: 'Kurta', emoji: '👘'),
//   WashFoldItem(id: 'innerwear', name: 'Innerwear / Socks', emoji: '🧦'),
//   WashFoldItem(id: 'towel', name: 'Towel', emoji: '🏊'),
// ];

// // =====================================================================
// // CART NOTIFIER
// // =====================================================================

// class WashFoldCartNotifier extends Notifier<Map<String, WashFoldCartEntry>> {
//   @override
//   Map<String, WashFoldCartEntry> build() => {};

//   void increment(String itemId) {
//     final current = state[itemId];
//     if (current == null) {
//       state = {
//         ...state,
//         itemId: WashFoldCartEntry(
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
//       final updated = Map<String, WashFoldCartEntry>.from(state);
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
//       id: WashFoldCartEntry(
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

// final washFoldCartProvider =
//     NotifierProvider<WashFoldCartNotifier, Map<String, WashFoldCartEntry>>(
//       WashFoldCartNotifier.new,
//     );

// // =====================================================================
// // SEARCH PROVIDER
// // =====================================================================

// final washFoldSearchProvider = StateProvider.autoDispose<String>((ref) => '');
// ---------------------------------------------------------------------------------------
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:whirl_wash/features/home/data/models/fabric_type.dart';

// // =====================================================================
// // CART ENTRY
// // =====================================================================

// class WashFoldCartEntry {
//   final String itemId;
//   final int quantity;
//   final FabricType fabric;
//   final String? customName;

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
// }

// // =====================================================================
// // CART NOTIFIER
// // =====================================================================

// class WashFoldCartNotifier extends Notifier<Map<String, WashFoldCartEntry>> {
//   @override
//   Map<String, WashFoldCartEntry> build() => {};

//   void increment(String itemId) {
//     final current = state[itemId];
//     if (current == null) {
//       state = {
//         ...state,
//         itemId: WashFoldCartEntry(
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
//       final updated = Map<String, WashFoldCartEntry>.from(state);
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
//       id: WashFoldCartEntry(
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

// final washFoldCartProvider =
//     NotifierProvider<WashFoldCartNotifier, Map<String, WashFoldCartEntry>>(
//       WashFoldCartNotifier.new,
//     );

// final washFoldSearchProvider = StateProvider.autoDispose<String>((ref) => '');
