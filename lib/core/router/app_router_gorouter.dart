import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whirl_wash/features/auth/presentation/screens/edit_profile_screen.dart';
import 'package:whirl_wash/features/home/data/models/cart_entry.dart';

// Screens
import 'package:whirl_wash/features/splash/presentation/screens/splash_screen.dart';
import 'package:whirl_wash/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:whirl_wash/features/auth/presentation/screens/login_screen.dart';
import 'package:whirl_wash/features/auth/presentation/screens/signup_screen.dart';
import 'package:whirl_wash/features/auth/presentation/screens/phone_auth_screen.dart';
import 'package:whirl_wash/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:whirl_wash/features/auth/presentation/screens/complete_profile_screen.dart';

// Bottom nav
import 'package:whirl_wash/features/home/presentation/bottom_nav_page.dart';

// Service screens
import 'package:whirl_wash/features/home/presentation/screens/services/wash_fold_screen.dart';
import 'package:whirl_wash/features/home/presentation/screens/services/wash_iron_screen.dart';
import 'package:whirl_wash/features/home/presentation/screens/services/dry_clean_screen.dart';
import 'package:whirl_wash/features/home/presentation/screens/services/iron_only_screen.dart';
import 'package:whirl_wash/features/home/presentation/screens/services/shoe_clean_screen.dart';
import 'package:whirl_wash/features/home/presentation/screens/services/express_screen.dart';

// Order screens
import 'package:whirl_wash/features/home/presentation/screens/order_confirm_screen.dart';
import 'package:whirl_wash/features/home/presentation/screens/order_success_screen.dart';
import 'package:whirl_wash/features/home/presentation/screens/order_detail_screen.dart';

// Providers
import 'package:whirl_wash/features/auth/presentation/providers/auth_provider.dart';
import 'package:whirl_wash/features/onboarding/presentation/providers/onboarding_provider.dart';

// =====================================================================
// SPLASH TIMER PROVIDER
// =====================================================================

class SplashTimerNotifier extends Notifier<bool> {
  Timer? _timer;

  @override
  bool build() {
    _timer = Timer(const Duration(seconds: 4), () {
      state = true;
    });
    ref.onDispose(() => _timer?.cancel());
    return false;
  }
}

final splashTimerProvider = NotifierProvider<SplashTimerNotifier, bool>(
  SplashTimerNotifier.new,
);

// =====================================================================
// GO ROUTER REFRESH HELPER
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
// ROUTER PROVIDER
// =====================================================================

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final onboardingComplete = ref.watch(onboardingProvider);
  final splashComplete = ref.watch(splashTimerProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,

    refreshListenable: GoRouterRefreshStream(
      authState.asData?.value != null
          ? Stream.value(authState.asData!.value)
          : const Stream.empty(),
    ),

    routes: [
      // ── SPLASH ──────────────────────────────────────────────────────
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // ── ONBOARDING ──────────────────────────────────────────────────
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // ── AUTH ────────────────────────────────────────────────────────
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

      // ── BOTTOM NAV — no transition animation ───────────────────────
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: BottomNavPage()),
      ),
      GoRoute(
        path: '/orders',
        name: 'orders',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: BottomNavPage()),
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: BottomNavPage()),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: BottomNavPage()),
      ),

      // ── SERVICE SCREENS — no transition ─────────────────────────────
      GoRoute(
        path: '/wash-fold',
        name: 'wash-fold',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: WashFoldScreen()),
      ),
      GoRoute(
        path: '/wash-iron',
        name: 'wash-iron',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: WashIronScreen()),
      ),
      GoRoute(
        path: '/dry-clean',
        name: 'dry-clean',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: DryCleanScreen()),
      ),
      GoRoute(
        path: '/iron-only',
        name: 'iron-only',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: IronOnlyScreen()),
      ),
      GoRoute(
        path: '/shoe-clean',
        name: 'shoe-clean',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ShoeCleanScreen()),
      ),
      GoRoute(
        path: '/express',
        name: 'express',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ExpressScreen()),
      ),

      // ── ORDER SCREENS ────────────────────────────────────────────────
      GoRoute(
        path: '/order-confirm',
        name: 'order-confirm',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final cart = extra['cart'] as Map<String, CartEntry>;
          final specialInstructions = extra['specialInstructions'] as String?;
          return OrderConfirmScreen(
            cart: cart,
            specialInstructions: specialInstructions,
          );
        },
      ),
      GoRoute(
        path: '/order-success',
        name: 'order-success',
        builder: (context, state) {
          final orderId = state.extra as String?;
          return OrderSuccessScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: '/order-detail',
        name: 'order-detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return OrderDetailScreen(
            batchId: extra['batchId'] as String,
            orders: (extra['orders'] as List).cast<Map<String, dynamic>>(),
          );
        },
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: EditProfileScreen()),
      ),
    ],

    // ── REDIRECT ──────────────────────────────────────────────────────
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

      // SPLASH
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

      // NOT LOGGED IN
      if (!isLoggedIn) {
        if (!hasSeenOnboarding && !isOnOnboarding) return '/onboarding';
        if (hasSeenOnboarding && !isOnAuth) return '/login';
        return null;
      }

      // LOGGED IN
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

    // ── ERROR ──────────────────────────────────────────────────────────
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
