// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:whirl_wash/features/home/data/models/fabric_type.dart';

// // =====================================================================
// // CART ENTRY MODEL
// // =====================================================================

// class CartEntry {
//   final String itemId;
//   final String serviceId;
//   final int quantity;
//   final FabricType? fabric; // null for iron_only and shoe_clean
//   final String? customName; // non-null only for custom items

//   const CartEntry({
//     required this.itemId,
//     required this.serviceId,
//     required this.quantity,
//     this.fabric,
//     this.customName,
//   });

//   bool get isCustom => customName != null;

//   CartEntry copyWith({int? quantity, FabricType? fabric}) {
//     return CartEntry(
//       itemId: itemId,
//       serviceId: serviceId,
//       quantity: quantity ?? this.quantity,
//       fabric: fabric ?? this.fabric,
//       customName: customName,
//     );
//   }

//   @override
//   String toString() =>
//       'CartEntry(itemId: $itemId, serviceId: $serviceId, qty: $quantity)';
// }

// // =====================================================================
// // CART NOTIFIER
// // =====================================================================

// class CartNotifier extends Notifier<Map<String, CartEntry>> {
//   @override
//   Map<String, CartEntry> build() => {};

//   // Unique key per item per service — same item can exist in multiple services
//   String _key(String itemId, String serviceId) => '${serviceId}_$itemId';

//   void increment(String itemId, String serviceId, {FabricType? fabric}) {
//     final key = _key(itemId, serviceId);
//     final current = state[key];
//     if (current == null) {
//       state = {
//         ...state,
//         key: CartEntry(
//           itemId: itemId,
//           serviceId: serviceId,
//           quantity: 1,
//           fabric: fabric,
//         ),
//       };
//     } else {
//       state = {...state, key: current.copyWith(quantity: current.quantity + 1)};
//     }
//   }

//   void decrement(String itemId, String serviceId) {
//     final key = _key(itemId, serviceId);
//     final current = state[key];
//     if (current == null) return;
//     if (current.quantity <= 1) {
//       final updated = Map<String, CartEntry>.from(state);
//       updated.remove(key);
//       state = updated;
//     } else {
//       state = {...state, key: current.copyWith(quantity: current.quantity - 1)};
//     }
//   }

//   void setFabric(String itemId, String serviceId, FabricType fabric) {
//     final key = _key(itemId, serviceId);
//     final current = state[key];
//     if (current == null) return;
//     state = {...state, key: current.copyWith(fabric: fabric)};
//   }

//   void addCustom({
//     required String name,
//     required String serviceId,
//     required int quantity,
//     FabricType? fabric,
//   }) {
//     if (name.trim().isEmpty || quantity < 1) return;
//     final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
//     final key = _key(id, serviceId);
//     state = {
//       ...state,
//       key: CartEntry(
//         itemId: id,
//         serviceId: serviceId,
//         quantity: quantity,
//         fabric: fabric,
//         customName: name.trim(),
//       ),
//     };
//   }

//   void removeItem(String itemId, String serviceId) {
//     final key = _key(itemId, serviceId);
//     final updated = Map<String, CartEntry>.from(state);
//     updated.remove(key);
//     state = updated;
//   }

//   void clearService(String serviceId) {
//     state = Map.from(state)
//       ..removeWhere((_, entry) => entry.serviceId == serviceId);
//   }

//   void clearAll() => state = {};

//   // Get all entries for a specific service
//   Map<String, CartEntry> entriesForService(String serviceId) {
//     return {
//       for (final e in state.entries)
//         if (e.value.serviceId == serviceId) e.key: e.value,
//     };
//   }

//   // Get entry for a specific item in a specific service
//   CartEntry? entryFor(String itemId, String serviceId) {
//     return state[_key(itemId, serviceId)];
//   }
// }

// final cartProvider = NotifierProvider<CartNotifier, Map<String, CartEntry>>(
//   CartNotifier.new,
// );

// // Total items across ALL services — for bottom bar badge
// final cartTotalProvider = Provider<int>((ref) {
//   return ref.watch(cartProvider).values.fold(0, (sum, e) => sum + e.quantity);
// });

// // Total items for a specific service — for service screen bottom bar
// final cartServiceTotalProvider = Provider.family<int, String>((ref, serviceId) {
//   return ref
//       .watch(cartProvider)
//       .values
//       .where((e) => e.serviceId == serviceId)
//       .fold(0, (sum, e) => sum + e.quantity);
// });

// ----------------------------------------------------------------------
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:whirl_wash/features/home/data/models/fabric_type.dart';

// // =====================================================================
// // CART ENTRY MODEL
// // =====================================================================

// class CartEntry {
//   final String itemId;
//   final String serviceId;
//   final int quantity;
//   final FabricType? fabric; // null for iron_only and shoe_clean
//   final String? customName; // non-null only for custom items
//   final bool isExpress; // true if added via express screen
//   final String? expressTimeSlot; // '6hr', '12hr', '24hr'

//   const CartEntry({
//     required this.itemId,
//     required this.serviceId,
//     required this.quantity,
//     this.fabric,
//     this.customName,
//     this.isExpress = false,
//     this.expressTimeSlot,
//   });

//   bool get isCustom => customName != null;

//   CartEntry copyWith({int? quantity, FabricType? fabric}) {
//     return CartEntry(
//       itemId: itemId,
//       serviceId: serviceId,
//       quantity: quantity ?? this.quantity,
//       fabric: fabric ?? this.fabric,
//       customName: customName,
//       isExpress: isExpress,
//       expressTimeSlot: expressTimeSlot,
//     );
//   }

//   @override
//   String toString() =>
//       'CartEntry(itemId: $itemId, serviceId: $serviceId, qty: $quantity)';
// }

// // =====================================================================
// // CART NOTIFIER
// // =====================================================================

// class CartNotifier extends Notifier<Map<String, CartEntry>> {
//   @override
//   Map<String, CartEntry> build() => {};

//   // Unique key per item per service — same item can exist in multiple services
//   String _key(String itemId, String serviceId) => '${serviceId}_$itemId';

//   void increment(
//     String itemId,
//     String serviceId, {
//     FabricType? fabric,
//     bool isExpress = false,
//     String? expressTimeSlot,
//   }) {
//     final key = _key(itemId, serviceId);
//     final current = state[key];
//     if (current == null) {
//       state = {
//         ...state,
//         key: CartEntry(
//           itemId: itemId,
//           serviceId: serviceId,
//           quantity: 1,
//           fabric: fabric,
//           isExpress: isExpress,
//           expressTimeSlot: expressTimeSlot,
//         ),
//       };
//     } else {
//       state = {...state, key: current.copyWith(quantity: current.quantity + 1)};
//     }
//   }

//   void decrement(String itemId, String serviceId) {
//     final key = _key(itemId, serviceId);
//     final current = state[key];
//     if (current == null) return;
//     if (current.quantity <= 1) {
//       final updated = Map<String, CartEntry>.from(state);
//       updated.remove(key);
//       state = updated;
//     } else {
//       state = {...state, key: current.copyWith(quantity: current.quantity - 1)};
//     }
//   }

//   void setFabric(String itemId, String serviceId, FabricType fabric) {
//     final key = _key(itemId, serviceId);
//     final current = state[key];
//     if (current == null) return;
//     state = {...state, key: current.copyWith(fabric: fabric)};
//   }

//   void addCustom({
//     required String name,
//     required String serviceId,
//     required int quantity,
//     FabricType? fabric,
//     bool isExpress = false,
//     String? expressTimeSlot,
//   }) {
//     if (name.trim().isEmpty || quantity < 1) return;
//     final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
//     final key = _key(id, serviceId);
//     state = {
//       ...state,
//       key: CartEntry(
//         itemId: id,
//         serviceId: serviceId,
//         quantity: quantity,
//         fabric: fabric,
//         customName: name.trim(),
//         isExpress: isExpress,
//         expressTimeSlot: expressTimeSlot,
//       ),
//     };
//   }

//   void removeItem(String itemId, String serviceId) {
//     final key = _key(itemId, serviceId);
//     final updated = Map<String, CartEntry>.from(state);
//     updated.remove(key);
//     state = updated;
//   }

//   void clearService(String serviceId) {
//     state = Map.from(state)
//       ..removeWhere((_, entry) => entry.serviceId == serviceId);
//   }

//   void clearAll() => state = {};

//   // Get all entries for a specific service
//   Map<String, CartEntry> entriesForService(String serviceId) {
//     return {
//       for (final e in state.entries)
//         if (e.value.serviceId == serviceId) e.key: e.value,
//     };
//   }

//   // Get entry for a specific item in a specific service
//   CartEntry? entryFor(String itemId, String serviceId) {
//     return state[_key(itemId, serviceId)];
//   }
// }

// final cartProvider = NotifierProvider<CartNotifier, Map<String, CartEntry>>(
//   CartNotifier.new,
// );

// // Total items across ALL services — for bottom bar badge
// final cartTotalProvider = Provider<int>((ref) {
//   return ref.watch(cartProvider).values.fold(0, (sum, e) => sum + e.quantity);
// });

// // Total items for a specific service — for service screen bottom bar
// final cartServiceTotalProvider = Provider.family<int, String>((ref, serviceId) {
//   return ref
//       .watch(cartProvider)
//       .values
//       .where((e) => e.serviceId == serviceId)
//       .fold(0, (sum, e) => sum + e.quantity);
// });

// -------------------------------------------------------------

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:whirl_wash/features/home/data/models/fabric_type.dart';

// // =====================================================================
// // CART ENTRY MODEL
// // =====================================================================

// class CartEntry {
//   final String itemId;
//   final String serviceId;
//   final int quantity;
//   final FabricType? fabric;      // null for iron_only and shoe_clean
//   final String? customName;     // non-null only for custom items
//   final bool isExpress;         // true if added via express screen
//   final String? expressTimeSlot; // '6hr', '12hr', '24hr'

//   const CartEntry({
//     required this.itemId,
//     required this.serviceId,
//     required this.quantity,
//     this.fabric,
//     this.customName,
//     this.isExpress = false,
//     this.expressTimeSlot,
//   });

//   bool get isCustom => customName != null;

//   CartEntry copyWith({int? quantity, FabricType? fabric}) {
//     return CartEntry(
//       itemId: itemId,
//       serviceId: serviceId,
//       quantity: quantity ?? this.quantity,
//       fabric: fabric ?? this.fabric,
//       customName: customName,
//       isExpress: isExpress,
//       expressTimeSlot: expressTimeSlot,
//     );
//   }

//   @override
//   String toString() =>
//       'CartEntry(itemId: $itemId, serviceId: $serviceId, qty: $quantity)';
// }

// // =====================================================================
// // CART NOTIFIER
// // =====================================================================

// class CartNotifier extends Notifier<Map<String, CartEntry>> {
//   @override
//   Map<String, CartEntry> build() => {};

//   // Unique key per item per service
//   // Express items get 'express_' prefix so they don't clash with regular items
//   String _key(String itemId, String serviceId, {bool isExpress = false}) =>
//       isExpress ? 'express_${serviceId}_$itemId' : '${serviceId}_$itemId';

//   void increment(String itemId, String serviceId, {
//     FabricType? fabric,
//     bool isExpress = false,
//     String? expressTimeSlot,
//   }) {
//     final key = _key(itemId, serviceId, isExpress: isExpress);
//     final current = state[key];
//     if (current == null) {
//       state = {
//         ...state,
//         key: CartEntry(
//           itemId: itemId,
//           serviceId: serviceId,
//           quantity: 1,
//           fabric: fabric,
//           isExpress: isExpress,
//           expressTimeSlot: expressTimeSlot,
//         ),
//       };
//     } else {
//       state = {
//         ...state,
//         key: current.copyWith(quantity: current.quantity + 1),
//       };
//     }
//   }

//   void decrement(String itemId, String serviceId, {bool isExpress = false}) {
//     final key = _key(itemId, serviceId, isExpress: isExpress);
//     final current = state[key];
//     if (current == null) return;
//     if (current.quantity <= 1) {
//       final updated = Map<String, CartEntry>.from(state);
//       updated.remove(key);
//       state = updated;
//     } else {
//       state = {
//         ...state,
//         key: current.copyWith(quantity: current.quantity - 1),
//       };
//     }
//   }

//   void setFabric(String itemId, String serviceId, FabricType fabric, {bool isExpress = false}) {
//     final key = _key(itemId, serviceId, isExpress: isExpress);
//     final current = state[key];
//     if (current == null) return;
//     state = {...state, key: current.copyWith(fabric: fabric)};
//   }

//   void addCustom({
//     required String name,
//     required String serviceId,
//     required int quantity,
//     FabricType? fabric,
//     bool isExpress = false,
//     String? expressTimeSlot,
//   }) {
//     if (name.trim().isEmpty || quantity < 1) return;
//     final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
//     final key = _key(id, serviceId);
//     state = {
//       ...state,
//       key: CartEntry(
//         itemId: id,
//         serviceId: serviceId,
//         quantity: quantity,
//         fabric: fabric,
//         customName: name.trim(),
//         isExpress: isExpress,
//         expressTimeSlot: expressTimeSlot,
//       ),
//     };
//   }

//   void removeItem(String itemId, String serviceId, {bool isExpress = false}) {
//     final key = _key(itemId, serviceId, isExpress: isExpress);
//     final updated = Map<String, CartEntry>.from(state);
//     updated.remove(key);
//     state = updated;
//   }

//   void clearService(String serviceId) {
//     state = Map.from(state)
//       ..removeWhere((_, entry) => entry.serviceId == serviceId);
//   }

//   void clearAll() => state = {};

//   // Get all entries for a specific service
//   Map<String, CartEntry> entriesForService(String serviceId) {
//     return {
//       for (final e in state.entries)
//         if (e.value.serviceId == serviceId) e.key: e.value
//     };
//   }

//   // Get entry for a specific item in a specific service
//   CartEntry? entryFor(String itemId, String serviceId, {bool isExpress = false}) {
//     return state[_key(itemId, serviceId, isExpress: isExpress)];
//   }
// }

// final cartProvider =
//     NotifierProvider<CartNotifier, Map<String, CartEntry>>(
//   CartNotifier.new,
// );

// // Total items across ALL services — for bottom bar badge
// final cartTotalProvider = Provider<int>((ref) {
//   return ref
//       .watch(cartProvider)
//       .values
//       .fold(0, (sum, e) => sum + e.quantity);
// });

// // Total items for a specific service — for service screen bottom bar
// final cartServiceTotalProvider =
//     Provider.family<int, String>((ref, serviceId) {
//   return ref
//       .watch(cartProvider)
//       .values
//       .where((e) => e.serviceId == serviceId)
//       .fold(0, (sum, e) => sum + e.quantity);
// });
// ----------------------------------------------------------------------------------------
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:whirl_wash/features/home/data/models/fabric_type.dart';
// import 'package:whirl_wash/features/home/data/repositories/cart_repository.dart';

// // =====================================================================
// // CART ENTRY MODEL
// // =====================================================================

// class CartEntry {
//   final String itemId;
//   final String serviceId;
//   final int quantity;
//   final FabricType? fabric;
//   final String? customName;
//   final bool isExpress;
//   final String? expressTimeSlot;

//   const CartEntry({
//     required this.itemId,
//     required this.serviceId,
//     required this.quantity,
//     this.fabric,
//     this.customName,
//     this.isExpress = false,
//     this.expressTimeSlot,
//   });

//   bool get isCustom => customName != null;

//   CartEntry copyWith({int? quantity, FabricType? fabric}) {
//     return CartEntry(
//       itemId: itemId,
//       serviceId: serviceId,
//       quantity: quantity ?? this.quantity,
//       fabric: fabric ?? this.fabric,
//       customName: customName,
//       isExpress: isExpress,
//       expressTimeSlot: expressTimeSlot,
//     );
//   }

//   @override
//   String toString() =>
//       'CartEntry(itemId: $itemId, serviceId: $serviceId, qty: $quantity)';
// }

// // =====================================================================
// // CART NOTIFIER
// // =====================================================================

// class CartNotifier extends Notifier<Map<String, CartEntry>> {
//   final _repo = CartRepository();

//   @override
//   Map<String, CartEntry> build() {
//     // Load cart from Firestore when notifier is built
//     _loadCart();
//     return {};
//   }

//   String? get _userId => FirebaseAuth.instance.currentUser?.uid;

//   // Load cart from Firestore on app start
//   Future<void> _loadCart() async {
//     final uid = _userId;
//     if (uid == null) return;
//     final saved = await _repo.loadCart(uid);
//     if (saved.isNotEmpty) state = saved;
//   }

//   // Save cart to Firestore — call when navigating to cart tab or app background
//   Future<void> saveToFirestore() async {
//     final uid = _userId;
//     if (uid == null) return;
//     await _repo.saveCart(uid, state);
//   }

//   // Clear cart from Firestore — call after order placed
//   Future<void> clearAndSync() async {
//     state = {};
//     final uid = _userId;
//     if (uid == null) return;
//     await _repo.clearCart(uid);
//   }

//   // ── KEY ─────────────────────────────────────────────────────────────
//   String _key(String itemId, String serviceId, {bool isExpress = false}) =>
//       isExpress ? 'express_${serviceId}_$itemId' : '${serviceId}_$itemId';

//   // ── CART OPERATIONS ─────────────────────────────────────────────────

//   void increment(
//     String itemId,
//     String serviceId, {
//     FabricType? fabric,
//     bool isExpress = false,
//     String? expressTimeSlot,
//   }) {
//     final key = _key(itemId, serviceId, isExpress: isExpress);
//     final current = state[key];
//     if (current == null) {
//       state = {
//         ...state,
//         key: CartEntry(
//           itemId: itemId,
//           serviceId: serviceId,
//           quantity: 1,
//           fabric: fabric,
//           isExpress: isExpress,
//           expressTimeSlot: expressTimeSlot,
//         ),
//       };
//     } else {
//       state = {...state, key: current.copyWith(quantity: current.quantity + 1)};
//     }
//   }

//   void decrement(String itemId, String serviceId, {bool isExpress = false}) {
//     final key = _key(itemId, serviceId, isExpress: isExpress);
//     final current = state[key];
//     if (current == null) return;
//     if (current.quantity <= 1) {
//       final updated = Map<String, CartEntry>.from(state);
//       updated.remove(key);
//       state = updated;
//     } else {
//       state = {...state, key: current.copyWith(quantity: current.quantity - 1)};
//     }
//   }

//   void setFabric(
//     String itemId,
//     String serviceId,
//     FabricType fabric, {
//     bool isExpress = false,
//   }) {
//     final key = _key(itemId, serviceId, isExpress: isExpress);
//     final current = state[key];
//     if (current == null) return;
//     state = {...state, key: current.copyWith(fabric: fabric)};
//   }

//   void addCustom({
//     required String name,
//     required String serviceId,
//     required int quantity,
//     FabricType? fabric,
//     bool isExpress = false,
//     String? expressTimeSlot,
//   }) {
//     if (name.trim().isEmpty || quantity < 1) return;
//     final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
//     final key = _key(id, serviceId, isExpress: isExpress);
//     state = {
//       ...state,
//       key: CartEntry(
//         itemId: id,
//         serviceId: serviceId,
//         quantity: quantity,
//         fabric: fabric,
//         customName: name.trim(),
//         isExpress: isExpress,
//         expressTimeSlot: expressTimeSlot,
//       ),
//     };
//   }

//   void removeItem(String itemId, String serviceId, {bool isExpress = false}) {
//     final key = _key(itemId, serviceId, isExpress: isExpress);
//     final updated = Map<String, CartEntry>.from(state);
//     updated.remove(key);
//     state = updated;
//   }

//   void clearService(String serviceId) {
//     state = Map.from(state)
//       ..removeWhere((_, entry) => entry.serviceId == serviceId);
//   }

//   void clearAll() => state = {};

//   Map<String, CartEntry> entriesForService(String serviceId) {
//     return {
//       for (final e in state.entries)
//         if (e.value.serviceId == serviceId) e.key: e.value,
//     };
//   }

//   CartEntry? entryFor(
//     String itemId,
//     String serviceId, {
//     bool isExpress = false,
//   }) {
//     return state[_key(itemId, serviceId, isExpress: isExpress)];
//   }

//   int get totalItems => state.values.fold(0, (sum, e) => sum + e.quantity);
// }

// // =====================================================================
// // PROVIDERS
// // =====================================================================

// final cartProvider = NotifierProvider<CartNotifier, Map<String, CartEntry>>(
//   CartNotifier.new,
// );

// final cartTotalProvider = Provider<int>((ref) {
//   return ref.watch(cartProvider).values.fold(0, (sum, e) => sum + e.quantity);
// });

// final cartServiceTotalProvider = Provider.family<int, String>((ref, serviceId) {
//   return ref
//       .watch(cartProvider)
//       .values
//       .where((e) => e.serviceId == serviceId)
//       .fold(0, (sum, e) => sum + e.quantity);
// });

// // Repository provider
// final cartRepositoryProvider = Provider<CartRepository>((ref) {
//   return CartRepository();
// });
// -----------------------------------------------------------------------------------
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:whirl_wash/features/home/data/models/fabric_type.dart';
import 'package:whirl_wash/features/home/data/repositories/cart_repository.dart';

// =====================================================================
// CART ENTRY MODEL
// =====================================================================

class CartEntry {
  final String itemId;
  final String serviceId;
  final int quantity;
  final FabricType? fabric;
  final String? customName;
  final bool isExpress;
  final String? expressTimeSlot;

  const CartEntry({
    required this.itemId,
    required this.serviceId,
    required this.quantity,
    this.fabric,
    this.customName,
    this.isExpress = false,
    this.expressTimeSlot,
  });

  bool get isCustom => customName != null;

  CartEntry copyWith({int? quantity, FabricType? fabric}) {
    return CartEntry(
      itemId: itemId,
      serviceId: serviceId,
      quantity: quantity ?? this.quantity,
      fabric: fabric ?? this.fabric,
      customName: customName,
      isExpress: isExpress,
      expressTimeSlot: expressTimeSlot,
    );
  }

  @override
  String toString() =>
      'CartEntry(itemId: $itemId, serviceId: $serviceId, qty: $quantity)';
}

// =====================================================================
// CART NOTIFIER
// =====================================================================

class CartNotifier extends Notifier<Map<String, CartEntry>> {
  @override
  Map<String, CartEntry> build() {
    // Load cart from Firestore on app start
    _loadCart();
    return {};
  }

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> _loadCart() async {
    final uid = _userId;
    if (uid == null) return;
    final saved = await CartRepository().loadCart(uid);
    if (saved.isNotEmpty) state = saved;
  }

  // Called after order placed
  Future<void> clearAndSync() async {
    state = {};
    final uid = _userId;
    if (uid == null) return;
    await CartRepository().clearCart(uid);
  }

  // ── KEY ─────────────────────────────────────────────────────────────
  String _key(String itemId, String serviceId, {bool isExpress = false}) =>
      isExpress ? 'express_${serviceId}_$itemId' : '${serviceId}_$itemId';

  // ── CART OPERATIONS ─────────────────────────────────────────────────

  void increment(
    String itemId,
    String serviceId, {
    FabricType? fabric,
    bool isExpress = false,
    String? expressTimeSlot,
  }) {
    final key = _key(itemId, serviceId, isExpress: isExpress);
    final current = state[key];
    if (current == null) {
      state = {
        ...state,
        key: CartEntry(
          itemId: itemId,
          serviceId: serviceId,
          quantity: 1,
          fabric: fabric,
          isExpress: isExpress,
          expressTimeSlot: expressTimeSlot,
        ),
      };
    } else {
      state = {...state, key: current.copyWith(quantity: current.quantity + 1)};
    }
  }

  void decrement(String itemId, String serviceId, {bool isExpress = false}) {
    final key = _key(itemId, serviceId, isExpress: isExpress);
    final current = state[key];
    if (current == null) return;
    if (current.quantity <= 1) {
      final updated = Map<String, CartEntry>.from(state);
      updated.remove(key);
      state = updated;
    } else {
      state = {...state, key: current.copyWith(quantity: current.quantity - 1)};
    }
  }

  void setFabric(
    String itemId,
    String serviceId,
    FabricType fabric, {
    bool isExpress = false,
  }) {
    final key = _key(itemId, serviceId, isExpress: isExpress);
    final current = state[key];
    if (current == null) return;
    state = {...state, key: current.copyWith(fabric: fabric)};
  }

  void addCustom({
    required String name,
    required String serviceId,
    required int quantity,
    FabricType? fabric,
    bool isExpress = false,
    String? expressTimeSlot,
  }) {
    if (name.trim().isEmpty || quantity < 1) return;
    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final key = _key(id, serviceId, isExpress: isExpress);
    state = {
      ...state,
      key: CartEntry(
        itemId: id,
        serviceId: serviceId,
        quantity: quantity,
        fabric: fabric,
        customName: name.trim(),
        isExpress: isExpress,
        expressTimeSlot: expressTimeSlot,
      ),
    };
  }

  void removeItem(String itemId, String serviceId, {bool isExpress = false}) {
    final key = _key(itemId, serviceId, isExpress: isExpress);
    final updated = Map<String, CartEntry>.from(state);
    updated.remove(key);
    state = updated;
  }

  void clearService(String serviceId) {
    state = Map.from(state)
      ..removeWhere((_, entry) => entry.serviceId == serviceId);
  }

  void clearAll() => state = {};

  Map<String, CartEntry> entriesForService(String serviceId) {
    return {
      for (final e in state.entries)
        if (e.value.serviceId == serviceId) e.key: e.value,
    };
  }

  CartEntry? entryFor(
    String itemId,
    String serviceId, {
    bool isExpress = false,
  }) {
    return state[_key(itemId, serviceId, isExpress: isExpress)];
  }

  int get totalItems => state.values.fold(0, (sum, e) => sum + e.quantity);
}

// =====================================================================
// PROVIDERS
// =====================================================================

final cartProvider = NotifierProvider<CartNotifier, Map<String, CartEntry>>(
  CartNotifier.new,
);

final cartTotalProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).values.fold(0, (sum, e) => sum + e.quantity);
});

final cartServiceTotalProvider = Provider.family<int, String>((ref, serviceId) {
  return ref
      .watch(cartProvider)
      .values
      .where((e) => e.serviceId == serviceId)
      .fold(0, (sum, e) => sum + e.quantity);
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository();
});
