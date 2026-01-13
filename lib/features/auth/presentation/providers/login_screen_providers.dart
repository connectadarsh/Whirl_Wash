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

// =====================================================================
// 4. ANIMATION CONTROLLER PROVIDER - RIVERPOD 3.0 COMPATIBLE
// =====================================================================

// ✅ OPTION 1: Remove Animations (Simplest - Recommended)
// Animations aren't essential for login screen functionality
// Pure Riverpod without StatefulWidget complications

// ✅ OPTION 2: Use AnimationController in Provider (If you need animations)
// Note: This requires TickerProvider which is tricky without StatefulWidget

// For pure Riverpod, we'll remove the animation provider since:
// 1. Animations require TickerProviderStateMixin
// 2. TickerProvider only works with StatefulWidget
// 3. Login screen doesn't need animations for functionality

// If you absolutely need animations, keep the StatefulWidget approach
// or use implicit animations (AnimatedOpacity, AnimatedContainer)
