// // =====================================================================
// // COMPLETE PROFILE SCREEN PROVIDERS - Replaces StatefulWidget Local State
// // File: lib/features/auth/presentation/providers/complete_profile_screen_providers.dart
// // =====================================================================

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/legacy.dart';

// // =====================================================================
// // 1. TEXT CONTROLLERS PROVIDER (Pre-filled from Firebase Auth)
// // =====================================================================

// class CompleteProfileTextControllers {
//   final TextEditingController name;
//   final TextEditingController phone;

//   CompleteProfileTextControllers({required this.name, required this.phone});

//   void dispose() {
//     name.dispose();
//     phone.dispose();
//   }
// }

// final completeProfileTextControllersProvider =
//     Provider.autoDispose<CompleteProfileTextControllers>((ref) {
//       final user = FirebaseAuth.instance.currentUser;

//       final controllers = CompleteProfileTextControllers(
//         name: TextEditingController(text: user?.displayName ?? ''),
//         phone: TextEditingController(text: user?.phoneNumber ?? ''),
//       );

//       // Automatically dispose when provider is destroyed
//       ref.onDispose(() {
//         controllers.dispose();
//       });

//       return controllers;
//     });

// // =====================================================================
// // 2. GENDER SELECTION PROVIDER
// // =====================================================================

// final completeProfileGenderProvider = StateProvider.autoDispose<String?>((ref) {
//   return null; // null = not selected, 'Male', 'Female', 'Other'
// });

// // =====================================================================
// // 3. FORM KEY PROVIDER
// // =====================================================================

// final completeProfileFormKeyProvider =
//     Provider.autoDispose<GlobalKey<FormState>>((ref) {
//       return GlobalKey<FormState>();
//     });

// --------------------------------Gmap------------------------------------
// =====================================================================
// COMPLETE PROFILE SCREEN PROVIDERS
// File: lib/features/auth/presentation/providers/complete_profile_screen_providers.dart
// =====================================================================

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// // =====================================================================
// // 1. TEXT CONTROLLERS PROVIDER (Pre-filled from Firebase Auth)
// // =====================================================================

// class CompleteProfileTextControllers {
//   final TextEditingController name;
//   final TextEditingController phone;
//   final TextEditingController houseName; // manual — "Mango Villa, 2nd floor"
//   final TextEditingController address; // from Places autocomplete

//   CompleteProfileTextControllers({
//     required this.name,
//     required this.phone,
//     required this.houseName,
//     required this.address,
//   });

//   void dispose() {
//     name.dispose();
//     phone.dispose();
//     houseName.dispose();
//     address.dispose();
//   }
// }

// final completeProfileTextControllersProvider =
//     Provider.autoDispose<CompleteProfileTextControllers>((ref) {
//       final user = FirebaseAuth.instance.currentUser;

//       final controllers = CompleteProfileTextControllers(
//         name: TextEditingController(text: user?.displayName ?? ''),
//         phone: TextEditingController(text: user?.phoneNumber ?? ''),
//         houseName: TextEditingController(),
//         address: TextEditingController(),
//       );

//       ref.onDispose(() => controllers.dispose());

//       return controllers;
//     });

// // =====================================================================
// // 2. GENDER SELECTION PROVIDER
// // =====================================================================

// final completeProfileGenderProvider = StateProvider.autoDispose<String?>((ref) {
//   return null;
// });

// // =====================================================================
// // 3. FORM KEY PROVIDER
// // =====================================================================

// final completeProfileFormKeyProvider =
//     Provider.autoDispose<GlobalKey<FormState>>((ref) {
//       return GlobalKey<FormState>();
//     });

// // =====================================================================
// // 4. ADDRESS LOCATION PROVIDER (lat/lng from map/autocomplete)
// // =====================================================================

// final completeProfileLocationProvider = StateProvider.autoDispose<LatLng?>((
//   ref,
// ) {
//   return null;
// });

// // =====================================================================
// // 5. PLACES AUTOCOMPLETE SUGGESTIONS PROVIDER
// // =====================================================================

// final addressSuggestionsProvider = StateProvider.autoDispose<List<String>>((
//   ref,
// ) {
//   return [];
// });

// // =====================================================================
// // 6. ADDRESS LOADING PROVIDER (for geocoding/places API calls)
// // =====================================================================

// final addressLoadingProvider = StateProvider.autoDispose<bool>((ref) {
//   return false;
// });

// ----------------------------------------Structured-------------------------------------------------------
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
