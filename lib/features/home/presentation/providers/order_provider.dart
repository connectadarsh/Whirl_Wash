import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whirl_wash/features/home/data/repositories/order_repository.dart';
import 'package:whirl_wash/features/home/presentation/providers/cart_provider.dart';

// =====================================================================
// ORDER PLACEMENT STATE
// =====================================================================

enum OrderPlacementStatus { idle, loading, success, error }

class OrderPlacementState {
  final OrderPlacementStatus status;
  final String? orderId;
  final String? batchId;
  final String? error;

  const OrderPlacementState({
    this.status = OrderPlacementStatus.idle,
    this.orderId,
    this.batchId,
    this.error,
  });

  bool get isLoading => status == OrderPlacementStatus.loading;
  bool get isSuccess => status == OrderPlacementStatus.success;

  OrderPlacementState copyWith({
    OrderPlacementStatus? status,
    String? orderId,
    String? batchId,
    String? error,
  }) => OrderPlacementState(
    status: status ?? this.status,
    orderId: orderId ?? this.orderId,
    batchId: batchId ?? this.batchId,
    error: error,
  );
}

// =====================================================================
// NOTIFIER
// =====================================================================

class OrderPlacementNotifier extends Notifier<OrderPlacementState> {
  @override
  OrderPlacementState build() => const OrderPlacementState();

  final _repo = OrderRepository();

  Future<void> placeOrder({
    required Map<String, CartEntry> cart,
    String? specialInstructions,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      state = state.copyWith(
        status: OrderPlacementStatus.error,
        error: 'Not logged in',
      );
      return;
    }

    state = state.copyWith(status: OrderPlacementStatus.loading, error: null);

    try {
      // ── Fetch user details from Firestore ──────────────────────────
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        throw 'User profile not found. Please complete your profile first.';
      }

      final userData = userDoc.data()!;
      final userName = userData['name'] as String? ?? '';
      final userPhone = userData['phone'] as String? ?? '';
      final userAddress = userData['address'] as String? ?? '';
      final houseName = userData['houseName'] as String? ?? '';
      final latitude = (userData['latitude'] as num?)?.toDouble();
      final longitude = (userData['longitude'] as num?)?.toDouble();

      // ── Generate shared batchId ────────────────────────────────────
      final batchId = const Uuid().v4();

      final regularItems = cart.values.where((e) => !e.isExpress).toList();
      final expressItems = cart.values.where((e) => e.isExpress).toList();

      String? lastOrderId;

      // ── Place regular order if any ─────────────────────────────────
      if (regularItems.isNotEmpty) {
        lastOrderId = await _repo.placeRegularOrder(
          userId: uid,
          batchId: batchId,
          items: regularItems,
          specialInstructions: specialInstructions,
          userName: userName,
          userPhone: userPhone,
          userAddress: userAddress,
          houseName: houseName,
          latitude: latitude,
          longitude: longitude,
        );
      }

      // ── Place express order if any ─────────────────────────────────
      if (expressItems.isNotEmpty) {
        final timeSlot = expressItems.first.expressTimeSlot ?? 'Unknown';
        lastOrderId = await _repo.placeExpressOrder(
          userId: uid,
          batchId: batchId,
          items: expressItems,
          expressTimeSlot: timeSlot,
          specialInstructions: specialInstructions,
          userName: userName,
          userPhone: userPhone,
          userAddress: userAddress,
          houseName: houseName,
          latitude: latitude,
          longitude: longitude,
        );
      }

      // ── Clear cart ─────────────────────────────────────────────────
      await ref.read(cartProvider.notifier).clearAndSync();

      state = state.copyWith(
        status: OrderPlacementStatus.success,
        orderId: lastOrderId,
        batchId: batchId,
      );
    } catch (e) {
      state = state.copyWith(
        status: OrderPlacementStatus.error,
        error: e.toString(),
      );
    }
  }

  void reset() => state = const OrderPlacementState();
}

// =====================================================================
// PROVIDERS
// =====================================================================

final orderPlacementProvider =
    NotifierProvider<OrderPlacementNotifier, OrderPlacementState>(
      OrderPlacementNotifier.new,
    );

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});
