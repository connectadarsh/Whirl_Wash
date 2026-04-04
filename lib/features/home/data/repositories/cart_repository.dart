import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:whirl_wash/features/home/data/models/fabric_type.dart';
import 'package:whirl_wash/features/home/presentation/providers/cart_provider.dart';

// =====================================================================
// CART REPOSITORY — Firestore persistence for cart
// =====================================================================

class CartRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference _cartRef(String userId) =>
      _db.collection('carts').doc(userId).collection('items');

  // ── LOAD ────────────────────────────────────────────────────────────
  // Called on app start — loads saved cart from Firestore
  Future<Map<String, CartEntry>> loadCart(String userId) async {
    try {
      final snap = await _cartRef(userId).get();
      final result = <String, CartEntry>{};
      for (final doc in snap.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final entry = _entryFromMap(doc.id, data);
        if (entry != null) result[doc.id] = entry;
      }
      debugPrint('Cart loaded: ${result.length} items for user $userId');
      return result;
    } catch (e) {
      debugPrint('Cart load ERROR: $e');
      return {};
    }
  }

  // ── SAVE ────────────────────────────────────────────────────────────
  // Called when user opens cart tab or app goes to background
  Future<void> saveCart(String userId, Map<String, CartEntry> cart) async {
    try {
      final batch = _db.batch();
      final ref = _db.collection('carts').doc(userId);

      // Delete old items
      final oldSnap = await _cartRef(userId).get();
      for (final doc in oldSnap.docs) {
        batch.delete(doc.reference);
      }

      // Write new items
      for (final entry in cart.entries) {
        final docRef = _cartRef(userId).doc(entry.key);
        batch.set(docRef, _entryToMap(entry.value));
      }

      // Update timestamp
      batch.set(ref, {
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await batch.commit();
      debugPrint('Cart saved: ${cart.length} items for user $userId');
    } catch (e) {
      debugPrint('Cart save ERROR: $e');
    }
  }

  // ── CLEAR ───────────────────────────────────────────────────────────
  // Called after order is placed
  Future<void> clearCart(String userId) async {
    try {
      final snap = await _cartRef(userId).get();
      final batch = _db.batch();
      for (final doc in snap.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      debugPrint('Cart cleared for user $userId');
    } catch (e) {
      debugPrint('Cart clear ERROR: $e');
    }
  }

  // ── SERIALIZATION ───────────────────────────────────────────────────

  Map<String, dynamic> _entryToMap(CartEntry entry) {
    return {
      'itemId': entry.itemId,
      'serviceId': entry.serviceId,
      'quantity': entry.quantity,
      'fabric': entry.fabric?.name,
      'customName': entry.customName,
      'isExpress': entry.isExpress,
      'expressTimeSlot': entry.expressTimeSlot,
    };
  }

  CartEntry? _entryFromMap(String key, Map<String, dynamic> data) {
    try {
      return CartEntry(
        itemId: data['itemId'] as String,
        serviceId: data['serviceId'] as String,
        quantity: data['quantity'] as int,
        fabric: data['fabric'] != null
            ? FabricType.values.firstWhere(
                (f) => f.name == data['fabric'],
                orElse: () => FabricType.dontKnow,
              )
            : null,
        customName: data['customName'] as String?,
        isExpress: data['isExpress'] as bool? ?? false,
        expressTimeSlot: data['expressTimeSlot'] as String?,
      );
    } catch (e) {
      debugPrint('CartEntry parse error for key $key: $e');
      return null;
    }
  }
}
