// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// // =====================================================================
// // RUN ONCE — then remove from main.dart
// // =====================================================================

// Future<void> seedFirestoreConfigV2() async {
//   final base = FirebaseFirestore.instance.collection('config').doc('init');

//   debugPrint('🌱 Starting Firestore config v2 seed...');

//   // ── MASTER ITEMS ──────────────────────────────────────────────────
//   final masterItems = {
//     'shirt': {'name': 'Shirt / T-Shirt', 'emoji': '👕'},
//     'pants': {'name': 'Pants / Jeans', 'emoji': '👖'},
//     'saree': {'name': 'Saree', 'emoji': '🥻'},
//     'churidar': {'name': 'Churidar', 'emoji': '👗'},
//     'jacket': {'name': 'Jacket', 'emoji': '🧥'},
//     'hoodie': {'name': 'Hoodie', 'emoji': '🫙'},
//     'bedsheet': {'name': 'Bedsheet', 'emoji': '🛏️'},
//     'pillow_cover': {'name': 'Pillow Cover', 'emoji': '🪫'},
//     'kurta': {'name': 'Kurta', 'emoji': '👘'},
//     'innerwear': {'name': 'Innerwear / Socks', 'emoji': '🧦'},
//     'towel': {'name': 'Towel', 'emoji': '🏊'},
//     'suit': {'name': 'Suit / Blazer', 'emoji': '🤵'},
//     'sherwani': {'name': 'Sherwani', 'emoji': '👘'},
//     'gown': {'name': 'Gown / Dress', 'emoji': '👗'},
//     'sweater': {'name': 'Woolen Sweater', 'emoji': '🧶'},
//     'leather_jacket': {'name': 'Leather Jacket', 'emoji': '🧥'},
//     'curtains': {'name': 'Curtains', 'emoji': '🪟'},
//     'blanket': {'name': 'Blanket / Quilt', 'emoji': '🛌'},
//     'tie': {'name': 'Tie / Scarf', 'emoji': '🧣'},
//     'carpet': {'name': 'Carpet / Rug', 'emoji': '🪺'},
//     'sneakers': {'name': 'Sneakers / Sports Shoes', 'emoji': '👟'},
//     'formal': {'name': 'Formal Shoes', 'emoji': '👞'},
//     'sandals': {'name': 'Sandals / Slippers', 'emoji': '👡'},
//     'boots': {'name': 'Boots', 'emoji': '👢'},
//     'heels': {'name': 'Heels', 'emoji': '👠'},
//     'loafers': {'name': 'Loafers', 'emoji': '🥿'},
//     'flipflops': {'name': 'Flip Flops', 'emoji': '🩴'},
//   };

//   for (final entry in masterItems.entries) {
//     await base.collection('master_items').doc(entry.key).set(entry.value);
//     debugPrint('  ✓ master_item: ${entry.key}');
//   }

//   // ── SERVICES ──────────────────────────────────────────────────────
//   final services = [
//     {
//       'id': 'wash_fold',
//       'name': 'Wash & Fold',
//       'icon': 'local_laundry_service',
//       'order': 1,
//       'enabled': true,
//       'expressEnabled': true,
//       'ratePerKg': 30,
//       'items': {
//         'shirt': {'enabled': true, 'order': 1},
//         'pants': {'enabled': true, 'order': 2},
//         'saree': {'enabled': true, 'order': 3},
//         'churidar': {'enabled': true, 'order': 4},
//         'jacket': {'enabled': true, 'order': 5},
//         'hoodie': {'enabled': true, 'order': 6},
//         'bedsheet': {'enabled': true, 'order': 7},
//         'pillow_cover': {'enabled': true, 'order': 8},
//         'kurta': {'enabled': true, 'order': 9},
//         'innerwear': {'enabled': true, 'order': 10},
//         'towel': {'enabled': true, 'order': 11},
//       },
//     },
//     {
//       'id': 'wash_iron',
//       'name': 'Wash & Iron',
//       'icon': 'iron',
//       'order': 2,
//       'enabled': true,
//       'expressEnabled': true,
//       'ratePerKg': 45,
//       'items': {
//         'shirt': {'enabled': true, 'order': 1},
//         'pants': {'enabled': true, 'order': 2},
//         'saree': {'enabled': true, 'order': 3},
//         'churidar': {'enabled': true, 'order': 4},
//         'jacket': {'enabled': true, 'order': 5},
//         'hoodie': {'enabled': true, 'order': 6},
//         'bedsheet': {'enabled': true, 'order': 7},
//         'pillow_cover': {'enabled': true, 'order': 8},
//         'kurta': {'enabled': true, 'order': 9},
//         'innerwear': {'enabled': true, 'order': 10},
//         'towel': {'enabled': true, 'order': 11},
//       },
//     },
//     {
//       'id': 'dry_clean',
//       'name': 'Dry Clean',
//       'icon': 'dry_cleaning',
//       'order': 3,
//       'enabled': true,
//       'expressEnabled': true,
//       'ratePerKg': 80,
//       'items': {
//         'suit': {'enabled': true, 'order': 1},
//         'saree': {'enabled': true, 'order': 2},
//         'sherwani': {'enabled': true, 'order': 3},
//         'gown': {'enabled': true, 'order': 4},
//         'sweater': {'enabled': true, 'order': 5},
//         'leather_jacket': {'enabled': true, 'order': 6},
//         'curtains': {'enabled': true, 'order': 7},
//         'blanket': {'enabled': true, 'order': 8},
//         'tie': {'enabled': true, 'order': 9},
//         'carpet': {'enabled': true, 'order': 10},
//       },
//     },
//     {
//       'id': 'iron_only',
//       'name': 'Iron Only',
//       'icon': 'checkroom',
//       'order': 4,
//       'enabled': true,
//       'expressEnabled': true,
//       'ratePerKg': 25,
//       'items': {
//         'shirt': {'enabled': true, 'order': 1},
//         'pants': {'enabled': true, 'order': 2},
//         'saree': {'enabled': true, 'order': 3},
//         'churidar': {'enabled': true, 'order': 4},
//         'kurta': {'enabled': true, 'order': 5},
//         'jacket': {'enabled': true, 'order': 6},
//         'hoodie': {'enabled': true, 'order': 7},
//         'bedsheet': {'enabled': true, 'order': 8},
//         'pillow_cover': {'enabled': true, 'order': 9},
//         'towel': {'enabled': true, 'order': 10},
//       },
//     },
//     {
//       'id': 'shoe_clean',
//       'name': 'Shoe Clean',
//       'icon': 'cleaning_services',
//       'order': 5,
//       'enabled': true,
//       'expressEnabled': false,
//       'ratePerKg': 0,
//       'items': {
//         'sneakers': {'enabled': true, 'order': 1},
//         'formal': {'enabled': true, 'order': 2},
//         'sandals': {'enabled': true, 'order': 3},
//         'boots': {'enabled': true, 'order': 4},
//         'heels': {'enabled': true, 'order': 5},
//         'loafers': {'enabled': true, 'order': 6},
//         'flipflops': {'enabled': true, 'order': 7},
//       },
//     },
//     {
//       'id': 'express',
//       'name': 'Express',
//       'icon': 'flash_on',
//       'order': 6,
//       'enabled': true,
//       'expressEnabled': false,
//       'ratePerKg': 0,
//     },
//   ];

//   for (final service in services) {
//     final id = service['id'] as String;
//     final data = Map<String, dynamic>.from(service)..remove('id');
//     await base.collection('services').doc(id).set(data);
//     debugPrint('  ✓ service: $id');
//   }

//   // ── EXPRESS TIMES ─────────────────────────────────────────────────
//   final expressTimes = [
//     {
//       'id': '6hr',
//       'label': '6hr',
//       'sublabel': 'Same day',
//       'surcharge': 30,
//       'order': 1,
//       'enabled': true,
//     },
//     {
//       'id': '12hr',
//       'label': '12hr',
//       'sublabel': 'Half day',
//       'surcharge': 20,
//       'order': 2,
//       'enabled': true,
//     },
//     {
//       'id': '24hr',
//       'label': '24hr',
//       'sublabel': 'Next day',
//       'surcharge': 10,
//       'order': 3,
//       'enabled': true,
//     },
//   ];

//   for (final t in expressTimes) {
//     final id = t['id'] as String;
//     final data = Map<String, dynamic>.from(t)..remove('id');
//     await base.collection('express_times').doc(id).set(data);
//     debugPrint('  ✓ express_time: $id');
//   }

//   debugPrint('✅ Firestore config v2 seed complete!');
// }
