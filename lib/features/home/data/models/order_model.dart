import 'package:whirl_wash/features/home/data/models/cart_entry.dart';

// =====================================================================
// ORDER MODEL
// =====================================================================

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final String? specialInstructions;
  final String status;
  final bool isExpress;
  final String? expressTimeSlot;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    this.specialInstructions,
    required this.status,
    required this.isExpress,
    this.expressTimeSlot,
    required this.createdAt,
  });
}

// =====================================================================
// ORDER ITEM
// =====================================================================

class OrderItem {
  final String itemId;
  final String serviceId;
  final int quantity;
  final String? fabric;
  final String? customName;
  final bool isExpress;
  final String? expressTimeSlot;
  final String? imageUrl; // ← NEW

  const OrderItem({
    required this.itemId,
    required this.serviceId,
    required this.quantity,
    this.fabric,
    this.customName,
    required this.isExpress,
    this.expressTimeSlot,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() => {
    'itemId': itemId,
    'serviceId': serviceId,
    'quantity': quantity,
    'fabric': fabric,
    'customName': customName,
    'isExpress': isExpress,
    'expressTimeSlot': expressTimeSlot,
    'imageUrl': imageUrl, // ← NEW
  };

  static OrderItem fromCartEntry(CartEntry e) => OrderItem(
    itemId: e.itemId,
    serviceId: e.serviceId,
    quantity: e.quantity,
    fabric: e.fabric?.name,
    customName: e.customName,
    isExpress: e.isExpress,
    expressTimeSlot: e.expressTimeSlot,
    imageUrl: e.imageUrl, // ← NEW
  );
}
