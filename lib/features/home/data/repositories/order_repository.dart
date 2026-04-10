import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:whirl_wash/features/home/data/models/cart_entry.dart';
import 'package:whirl_wash/features/home/data/models/order_model.dart';

// =====================================================================
// ORDER MODEL
// =====================================================================

// =====================================================================
// REPOSITORY
// =====================================================================

class OrderRepository {
  final _db = FirebaseFirestore.instance;

  /// Places a regular order — returns the new order document ID
  Future<String> placeRegularOrder({
    required String userId,
    required String batchId,
    required List<CartEntry> items,
    String? specialInstructions,
    required String userName,
    required String userPhone,
    required String userAddress,
    required String houseName,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final ref = _db.collection('orders').doc();
      await ref.set({
        'userId': userId,
        'batchId': batchId,
        'type': 'regular',
        'isExpress': false,
        'status': 'pending',
        'specialInstructions': specialInstructions,
        'items': items.map((e) => OrderItem.fromCartEntry(e).toMap()).toList(),
        // ── User snapshot ──
        'userName': userName,
        'userPhone': userPhone,
        'userAddress': userAddress,
        'houseName': houseName,
        'userLocation': latitude != null && longitude != null
            ? {'lat': latitude, 'lng': longitude}
            : null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('Regular order placed: ${ref.id}');
      return ref.id;
    } catch (e) {
      debugPrint('placeRegularOrder ERROR: $e');
      rethrow;
    }
  }

  /// Places an express order — returns the new order document ID
  Future<String> placeExpressOrder({
    required String userId,
    required String batchId,
    required List<CartEntry> items,
    required String expressTimeSlot,
    String? specialInstructions,
    required String userName,
    required String userPhone,
    required String userAddress,
    required String houseName,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final ref = _db.collection('orders').doc();
      await ref.set({
        'userId': userId,
        'batchId': batchId,
        'type': 'express',
        'isExpress': true,
        'expressTimeSlot': expressTimeSlot,
        'status': 'pending',
        'specialInstructions': specialInstructions,
        'items': items.map((e) => OrderItem.fromCartEntry(e).toMap()).toList(),
        // ── User snapshot ──
        'userName': userName,
        'userPhone': userPhone,
        'userAddress': userAddress,
        'houseName': houseName,
        'userLocation': latitude != null && longitude != null
            ? {'lat': latitude, 'lng': longitude}
            : null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('Express order placed: ${ref.id}');
      return ref.id;
    } catch (e) {
      debugPrint('placeExpressOrder ERROR: $e');
      rethrow;
    }
  }

  /// Fetches orders for a user sorted by newest first
  Stream<List<Map<String, dynamic>>> ordersStream(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList(),
        );
  }
}
