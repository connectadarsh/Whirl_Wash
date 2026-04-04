import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// =====================================================================
// TEXT CONTROLLERS — pre-filled from Firebase Auth
// =====================================================================

class CompleteProfileTextControllers {
  final TextEditingController name;
  final TextEditingController phone;
  final TextEditingController houseName;
  final TextEditingController address;

  CompleteProfileTextControllers({
    required this.name,
    required this.phone,
    required this.houseName,
    required this.address,
  });

  void dispose() {
    name.dispose();
    phone.dispose();
    houseName.dispose();
    address.dispose();
  }
}

final completeProfileTextControllersProvider =
    Provider.autoDispose<CompleteProfileTextControllers>((ref) {
      final user = FirebaseAuth.instance.currentUser;

      final controllers = CompleteProfileTextControllers(
        name: TextEditingController(text: user?.displayName ?? ''),
        phone: TextEditingController(text: user?.phoneNumber ?? ''),
        houseName: TextEditingController(),
        address: TextEditingController(),
      );

      ref.onDispose(() => controllers.dispose());
      return controllers;
    });

// =====================================================================
// LOCATION — lat/lng from map pin or Places API
// =====================================================================

final completeProfileLocationProvider = StateProvider.autoDispose<LatLng?>(
  (ref) => null,
);
