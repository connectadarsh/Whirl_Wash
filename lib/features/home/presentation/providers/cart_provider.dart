import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whirl_wash/features/home/data/models/cart_entry.dart';
import 'package:whirl_wash/features/home/data/models/fabric_type.dart';
import 'package:whirl_wash/features/home/data/repositories/cart_repository.dart';

// =====================================================================
// CART NOTIFIER
// =====================================================================

class CartNotifier extends Notifier<Map<String, CartEntry>> {
  @override
  Map<String, CartEntry> build() {
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

  Future<void> clearAndSync() async {
    state = {};
    final uid = _userId;
    if (uid == null) return;
    await CartRepository().clearCart(uid);
  }

  String _key(String itemId, String serviceId, {bool isExpress = false}) =>
      isExpress ? 'express_${serviceId}_$itemId' : '${serviceId}_$itemId';

  void increment(
    String itemId,
    String serviceId, {
    FabricType? fabric,
    bool isExpress = false,
    String? expressTimeSlot,
    String? imageUrl, // ← NEW
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
          imageUrl: imageUrl, // ← NEW
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
        // no imageUrl for custom items
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
