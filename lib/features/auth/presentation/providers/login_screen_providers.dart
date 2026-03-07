// =====================================================================
// LOGIN SCREEN PROVIDERS - Riverpod 3.0.3 Compatible
// File: lib/features/auth/presentation/providers/login_screen_providers.dart
// =====================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// =====================================================================
// 1. TEXT CONTROLLERS PROVIDER
// =====================================================================

class LoginTextControllers {
  final TextEditingController email;
  final TextEditingController password;

  LoginTextControllers({required this.email, required this.password});

  void dispose() {
    email.dispose();
    password.dispose();
  }
}

final loginTextControllersProvider = Provider.autoDispose<LoginTextControllers>(
  (ref) {
    final controllers = LoginTextControllers(
      email: TextEditingController(),
      password: TextEditingController(),
    );

    // Automatically dispose when provider is destroyed
    ref.onDispose(() {
      controllers.dispose();
    });

    return controllers;
  },
);

// =====================================================================
// 2. PASSWORD VISIBILITY PROVIDER
// =====================================================================

final loginPasswordVisibilityProvider = StateProvider.autoDispose<bool>((ref) {
  return true; // true = obscured (hidden), false = visible
});

// =====================================================================
// 3. FORM KEY PROVIDER
// =====================================================================

final loginFormKeyProvider = Provider.autoDispose<GlobalKey<FormState>>((ref) {
  return GlobalKey<FormState>();
});
