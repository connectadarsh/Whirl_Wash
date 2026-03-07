// Flutter & Riverpod
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Routing & Firebase
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Screens
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/phone_auth_screen.dart';
import '../../features/auth/presentation/screens/complete_profile_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/home/presentation/home_screen.dart';

// Providers
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/onboarding/presentation/providers/onboarding_provider.dart';

// =====================================================================
// SPLASH TIMER PROVIDER (FIRST THING USER SEES)
// =====================================================================

final splashTimerProvider = StateNotifierProvider<SplashTimerNotifier, bool>(
  (ref) => SplashTimerNotifier(),
);

class SplashTimerNotifier extends StateNotifier<bool> {
  Timer? _timer;

  SplashTimerNotifier() : super(false) {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 4), () {
      state = true; // Splash completed
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// =====================================================================
// GO ROUTER REFRESH HELPER (LISTENS TO AUTH STATE)
// =====================================================================

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// =====================================================================
// MAIN ROUTER PROVIDER (APP BRAIN)
// =====================================================================

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final onboardingComplete = ref.watch(onboardingProvider);
  final splashComplete = ref.watch(splashTimerProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,

    // Rebuild router when auth state changes
    refreshListenable: GoRouterRefreshStream(
      authState.asData?.value != null
          ? Stream.value(authState.asData!.value)
          : const Stream.empty(),
    ),

    // =================================================================
    // ROUTES (SCREEN MAP)
    // =================================================================
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),

      GoRoute(
        path: '/phone-auth',
        name: 'phone-auth',
        builder: (context, state) => const PhoneAuthScreen(),
      ),

      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      GoRoute(
        path: '/complete-profile',
        name: 'complete-profile',
        builder: (context, state) => const CompleteProfileScreen(),
      ),

      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],

    // =================================================================
    // REDIRECT LOGIC (DECISION MAKER)
    // =================================================================
    redirect: (context, state) async {
      final location = state.matchedLocation;

      final isOnSplash = location == '/';
      final isOnOnboarding = location == '/onboarding';
      final isOnAuth = [
        '/login',
        '/signup',
        '/phone-auth',
        '/forgot-password',
      ].contains(location);
      final isOnCompleteProfile = location == '/complete-profile';

      final user = FirebaseAuth.instance.currentUser;
      final isLoggedIn = user != null;
      final hasSeenOnboarding = onboardingComplete;

      // ================= SPLASH =================
      if (isOnSplash) {
        if (!splashComplete) return null;

        if (isLoggedIn) {
          try {
            final doc = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

            final profileComplete = doc.data()?['profileComplete'] == true;

            return profileComplete ? '/home' : '/complete-profile';
          } catch (_) {
            return '/complete-profile';
          }
        } else {
          return hasSeenOnboarding ? '/login' : '/onboarding';
        }
      }

      // ================= NOT LOGGED IN =================
      if (!isLoggedIn) {
        if (!hasSeenOnboarding && !isOnOnboarding) {
          return '/onboarding';
        }

        if (hasSeenOnboarding && !isOnAuth) {
          return '/login';
        }

        return null;
      }

      // ================= LOGGED IN =================
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!doc.exists) {
          return isOnCompleteProfile ? null : '/complete-profile';
        }

        final profileComplete = doc.data()?['profileComplete'] == true;

        if (!profileComplete) {
          return isOnCompleteProfile ? null : '/complete-profile';
        }

        if (isOnAuth || isOnOnboarding || isOnCompleteProfile) {
          return '/home';
        }

        return null;
      } catch (_) {
        return isOnCompleteProfile ? null : '/complete-profile';
      }
    },

    // =================================================================
    // ERROR HANDLING
    // =================================================================
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.matchedLocation}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
