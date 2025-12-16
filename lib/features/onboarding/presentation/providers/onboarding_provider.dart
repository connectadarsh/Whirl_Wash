// import 'package:riverpod/legacy.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class OnboardingNotifier extends StateNotifier<bool> {
//   OnboardingNotifier() : super(false) {
//     _loadOnboardingStatus();
//   }

//   Future<void> _loadOnboardingStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     state = prefs.getBool('hasSeenOnboarding') ?? false;
//   }

//   Future<void> completeOnboarding() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('hasSeenOnboarding', true);
//     state = true;
//   }

//   Future<void> resetOnboarding() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('hasSeenOnboarding', false);
//     state = false;
//   }
// }

// final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((
//   ref,
// ) {
//   return OnboardingNotifier();
// });

// ----------------------------------------------------------------------------------------

import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Track if onboarding has been seen
class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false) {
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('hasSeenOnboarding') ?? false;
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    state = true;
  }

  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', false);
    state = false;
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((
  ref,
) {
  return OnboardingNotifier();
});
