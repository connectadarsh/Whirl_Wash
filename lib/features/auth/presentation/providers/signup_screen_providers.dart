// =====================================================================
// SIGNUP SCREEN PROVIDERS - Replaces StatefulWidget Local State
// File: lib/features/auth/presentation/providers/signup_screen_providers.dart
// =====================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// =====================================================================
// 1. TEXT CONTROLLERS PROVIDER
// =====================================================================

class SignupTextControllers {
  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirmPassword;

  SignupTextControllers({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
  }
}

final signupTextControllersProvider =
    Provider.autoDispose<SignupTextControllers>((ref) {
      final controllers = SignupTextControllers(
        name: TextEditingController(),
        email: TextEditingController(),
        password: TextEditingController(),
        confirmPassword: TextEditingController(),
      );

      // Automatically dispose when provider is destroyed
      ref.onDispose(() {
        controllers.dispose();
      });

      return controllers;
    });

// =====================================================================
// 2. PASSWORD VISIBILITY PROVIDERS
// =====================================================================

// Password field visibility
final signupPasswordVisibilityProvider = StateProvider.autoDispose<bool>((ref) {
  return true; // true = obscured (hidden)
});

// Confirm password field visibility
final signupConfirmPasswordVisibilityProvider = StateProvider.autoDispose<bool>(
  (ref) {
    return true; // true = obscured (hidden)
  },
);

// =====================================================================
// 3. FORM KEY PROVIDER
// =====================================================================

final signupFormKeyProvider = Provider.autoDispose<GlobalKey<FormState>>((ref) {
  return GlobalKey<FormState>();
});
