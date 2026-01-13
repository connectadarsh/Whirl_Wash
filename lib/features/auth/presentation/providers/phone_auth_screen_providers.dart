// =====================================================================
// PHONE AUTH SCREEN PROVIDERS - Replaces StatefulWidget Local State
// File: lib/features/auth/presentation/providers/phone_auth_screen_providers.dart
// =====================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// =====================================================================
// 1. TEXT CONTROLLERS PROVIDER
// =====================================================================

class PhoneAuthTextControllers {
  final TextEditingController phone;
  final TextEditingController otp;

  PhoneAuthTextControllers({required this.phone, required this.otp});

  void dispose() {
    phone.dispose();
    otp.dispose();
  }
}

final phoneAuthTextControllersProvider =
    Provider.autoDispose<PhoneAuthTextControllers>((ref) {
      final controllers = PhoneAuthTextControllers(
        phone: TextEditingController(),
        otp: TextEditingController(),
      );

      // Automatically dispose when provider is destroyed
      ref.onDispose(() {
        controllers.dispose();
      });

      return controllers;
    });

// =====================================================================
// 2. OTP SENT STATE PROVIDER
// =====================================================================

// Controls whether to show phone input or OTP input screen
final phoneAuthOtpSentProvider = StateProvider.autoDispose<bool>((ref) {
  return false; // false = phone input, true = OTP input
});

// =====================================================================
// 3. FORM KEY PROVIDER
// =====================================================================

final phoneAuthFormKeyProvider = Provider.autoDispose<GlobalKey<FormState>>((
  ref,
) {
  return GlobalKey<FormState>();
});
