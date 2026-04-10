import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// =====================================================================
// MODELS
// =====================================================================

class ServiceConfig {
  final String id;
  final String name;
  final String icon;
  final int order;
  final bool enabled;
  final bool expressEnabled;
  final int ratePerKg;

  const ServiceConfig({
    required this.id,
    required this.name,
    required this.icon,
    required this.order,
    required this.enabled,
    required this.expressEnabled,
    required this.ratePerKg,
  });

  factory ServiceConfig.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceConfig(
      id: doc.id,
      name: data['name'] ?? '',
      icon: data['icon'] ?? '',
      order: data['order'] ?? 0,
      enabled: data['enabled'] ?? true,
      expressEnabled: data['expressEnabled'] ?? false,
      ratePerKg: data['ratePerKg'] ?? 0,
    );
  }
}

class ItemConfig {
  final String id;
  final String name;
  final String? imageUrl; // ← replaces emoji
  final int order;

  const ItemConfig({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.order,
  });
}

class ExpressTimeConfig {
  final String id;
  final String label;
  final String sublabel;
  final int surcharge;
  final int order;
  final bool enabled;

  const ExpressTimeConfig({
    required this.id,
    required this.label,
    required this.sublabel,
    required this.surcharge,
    required this.order,
    required this.enabled,
  });

  factory ExpressTimeConfig.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExpressTimeConfig(
      id: doc.id,
      label: data['label'] ?? '',
      sublabel: data['sublabel'] ?? '',
      surcharge: data['surcharge'] ?? 0,
      order: data['order'] ?? 0,
      enabled: data['enabled'] ?? true,
    );
  }
}

// =====================================================================
// REPOSITORY
// =====================================================================

class ConfigRepository {
  final _base = FirebaseFirestore.instance.collection('config').doc('init');

  Future<List<ServiceConfig>> fetchServices() async {
    try {
      final snap = await _base.collection('services').orderBy('order').get();
      return snap.docs.map((doc) => ServiceConfig.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('fetchServices ERROR: $e');
      rethrow;
    }
  }

  Future<List<ItemConfig>> fetchItems(String serviceId) async {
    try {
      final serviceDoc = await _base
          .collection('services')
          .doc(serviceId)
          .get();

      if (!serviceDoc.exists) return [];

      final serviceData = serviceDoc.data() as Map<String, dynamic>;
      final itemsMap = serviceData['items'] as Map<String, dynamic>?;

      if (itemsMap == null || itemsMap.isEmpty) return [];

      final enabledItems = itemsMap.entries
          .where((e) => (e.value as Map<String, dynamic>)['enabled'] == true)
          .toList();

      if (enabledItems.isEmpty) return [];

      final masterSnap = await _base.collection('master_items').get();
      final masterMap = {for (final doc in masterSnap.docs) doc.id: doc.data()};

      final result = <ItemConfig>[];
      for (final entry in enabledItems) {
        final itemId = entry.key;
        final itemData = entry.value as Map<String, dynamic>;
        final master = masterMap[itemId];

        if (master == null) continue;

        result.add(
          ItemConfig(
            id: itemId,
            name: master['name'] ?? '',
            imageUrl: master['imageUrl'] as String?, // ← read imageUrl
            order: itemData['order'] ?? 0,
          ),
        );
      }

      result.sort((a, b) => a.order.compareTo(b.order));
      debugPrint('fetchItems($serviceId): loaded ${result.length} items');
      return result;
    } catch (e) {
      debugPrint('fetchItems($serviceId) ERROR: $e');
      rethrow;
    }
  }

  Future<List<ServiceConfig>> fetchExpressServices() async {
    try {
      final snap = await _base.collection('services').orderBy('order').get();
      return snap.docs
          .map((doc) => ServiceConfig.fromFirestore(doc))
          .where((s) => s.expressEnabled)
          .toList();
    } catch (e) {
      debugPrint('fetchExpressServices ERROR: $e');
      rethrow;
    }
  }

  Future<List<ExpressTimeConfig>> fetchExpressTimes() async {
    try {
      final snap = await _base
          .collection('express_times')
          .orderBy('order')
          .get();
      return snap.docs
          .map((doc) => ExpressTimeConfig.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('fetchExpressTimes ERROR: $e');
      rethrow;
    }
  }

  Future<ServiceConfig?> fetchService(String serviceId) async {
    try {
      final doc = await _base.collection('services').doc(serviceId).get();
      if (!doc.exists) return null;
      return ServiceConfig.fromFirestore(doc);
    } catch (e) {
      debugPrint('fetchService($serviceId) ERROR: $e');
      rethrow;
    }
  }
}
