import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:whirl_wash/features/auth/presentation/providers/complete_profile_screen_providers.dart';

// =====================================================================
// EDIT PROFILE TEXT CONTROLLERS — pre-filled from Firestore
// =====================================================================

final editProfileTextControllersProvider =
    FutureProvider.autoDispose<CompleteProfileTextControllers>((ref) async {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      String name = FirebaseAuth.instance.currentUser?.displayName ?? '';
      String phone = FirebaseAuth.instance.currentUser?.phoneNumber ?? '';
      String houseName = '';
      String address = '';

      if (uid != null) {
        try {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();
          if (doc.exists) {
            final data = doc.data()!;
            name = data['name'] as String? ?? name;
            phone = data['phone'] as String? ?? phone;
            houseName = data['houseName'] as String? ?? '';
            address = data['address'] as String? ?? '';
          }
        } catch (_) {}
      }

      final controllers = CompleteProfileTextControllers(
        name: TextEditingController(text: name),
        phone: TextEditingController(text: phone),
        houseName: TextEditingController(text: houseName),
        address: TextEditingController(text: address),
      );

      ref.onDispose(() => controllers.dispose());
      return controllers;
    });

// =====================================================================
// EDIT PROFILE LOCATION — pre-filled from Firestore
// =====================================================================

final editProfileLocationProvider = FutureProvider.autoDispose<LatLng?>((
  ref,
) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return null;

  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (doc.exists) {
      final data = doc.data()!;
      final lat = (data['latitude'] as num?)?.toDouble();
      final lng = (data['longitude'] as num?)?.toDouble();
      if (lat != null && lng != null) return LatLng(lat, lng);
    }
  } catch (_) {}
  return null;
});

// =====================================================================
// EDIT PROFILE LOCATION STATE — mutable after loading
// =====================================================================

final editProfileLocationStateProvider = StateProvider.autoDispose<LatLng?>((
  ref,
) {
  // Seed from Firestore once loaded
  final asyncLocation = ref.watch(editProfileLocationProvider);
  return asyncLocation.value;
});
