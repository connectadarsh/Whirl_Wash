import 'package:whirl_wash/features/home/data/models/fabric_type.dart';

class CartEntry {
  final String itemId;
  final String serviceId;
  final int quantity;
  final FabricType? fabric;
  final String? customName;
  final bool isExpress;
  final String? expressTimeSlot;
  final String? imageUrl; // ← NEW

  const CartEntry({
    required this.itemId,
    required this.serviceId,
    required this.quantity,
    this.fabric,
    this.customName,
    this.isExpress = false,
    this.expressTimeSlot,
    this.imageUrl,
  });

  bool get isCustom => customName != null;

  CartEntry copyWith({int? quantity, FabricType? fabric, String? imageUrl}) {
    return CartEntry(
      itemId: itemId,
      serviceId: serviceId,
      quantity: quantity ?? this.quantity,
      fabric: fabric ?? this.fabric,
      customName: customName,
      isExpress: isExpress,
      expressTimeSlot: expressTimeSlot,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() =>
      'CartEntry(itemId: $itemId, serviceId: $serviceId, qty: $quantity)';
}
