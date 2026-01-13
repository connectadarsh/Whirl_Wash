// =====================================================================
// COMPLETE PROFILE SCREEN PROVIDERS - Replaces StatefulWidget Local State
// File: lib/features/auth/presentation/providers/complete_profile_screen_providers.dart
// =====================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';

// =====================================================================
// 1. TEXT CONTROLLERS PROVIDER (Pre-filled from Firebase Auth)
// =====================================================================

class CompleteProfileTextControllers {
  final TextEditingController name;
  final TextEditingController phone;

  CompleteProfileTextControllers({required this.name, required this.phone});

  void dispose() {
    name.dispose();
    phone.dispose();
  }
}

final completeProfileTextControllersProvider =
    Provider.autoDispose<CompleteProfileTextControllers>((ref) {
      final user = FirebaseAuth.instance.currentUser;

      final controllers = CompleteProfileTextControllers(
        name: TextEditingController(text: user?.displayName ?? ''),
        phone: TextEditingController(text: user?.phoneNumber ?? ''),
      );

      // Automatically dispose when provider is destroyed
      ref.onDispose(() {
        controllers.dispose();
      });

      return controllers;
    });

// =====================================================================
// 2. GENDER SELECTION PROVIDER
// =====================================================================

final completeProfileGenderProvider = StateProvider.autoDispose<String?>((ref) {
  return null; // null = not selected, 'Male', 'Female', 'Other'
});

// =====================================================================
// 3. FORM KEY PROVIDER
// =====================================================================

final completeProfileFormKeyProvider =
    Provider.autoDispose<GlobalKey<FormState>>((ref) {
      return GlobalKey<FormState>();
    });
