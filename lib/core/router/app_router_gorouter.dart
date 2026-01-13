// // =====================================================================
// // FIXED GO_ROUTER IMPLEMENTATION - Proper Redirect Logic
// // File: lib/core/router/app_router_gorouter.dart
// // =====================================================================

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:async';

// // Import your existing screens
// import '../../features/splash/presentation/screens/splash_screen.dart';
// import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
// import '../../features/auth/presentation/screens/login_screen.dart';
// import '../../features/auth/presentation/screens/signup_screen.dart';
// import '../../features/auth/presentation/screens/phone_auth_screen.dart';
// import '../../features/auth/presentation/screens/complete_profile_screen.dart';
// import '../../features/home/presentation/home_screen.dart';

// // Import providers
// import '../../features/auth/presentation/providers/auth_provider.dart';
// import '../../features/onboarding/presentation/providers/onboarding_provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// // =====================================================================
// // PROFILE COMPLETION CHECK PROVIDER
// // =====================================================================

// final profileCompleteProvider = FutureProvider<bool>((ref) async {
//   final authState = ref.watch(authStateProvider);

//   return authState.when(
//     data: (User? user) async {
//       if (user == null) return false;

//       try {
//         final doc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .get();

//         if (!doc.exists) return false;

//         final data = doc.data();
//         return data?['profileComplete'] == true;
//       } catch (e) {
//         return false;
//       }
//     },
//     loading: () => false,
//     error: (_, __) => false,
//   );
// });

// // =====================================================================
// // HELPER CLASS - GoRouter Refresh Stream
// // =====================================================================

// class GoRouterRefreshStream extends ChangeNotifier {
//   GoRouterRefreshStream(Stream<dynamic> stream) {
//     notifyListeners();
//     _subscription = stream.asBroadcastStream().listen((_) {
//       notifyListeners();
//     });
//   }

//   late final StreamSubscription<dynamic> _subscription;

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }

// // =====================================================================
// // ROUTER PROVIDER - Main GoRouter Configuration
// // =====================================================================

// final routerProvider = Provider<GoRouter>((ref) {
//   // Watch auth state for reactive navigation
//   final authState = ref.watch(authStateProvider);
//   final onboardingComplete = ref.watch(onboardingProvider);

//   return GoRouter(
//     // Start on splash, redirect will handle the rest
//     initialLocation: '/',

//     // Enable debug logging
//     debugLogDiagnostics: true,

//     // Refresh router when auth state changes
//     refreshListenable: GoRouterRefreshStream(
//       authState.asData?.value != null
//           ? Stream.value(authState.asData!.value)
//           : const Stream.empty(),
//     ),

//     // ================================================================
//     // ROUTES DEFINITION
//     // ================================================================
//     routes: [
//       // ==================== SPLASH SCREEN ====================
//       GoRoute(
//         path: '/',
//         name: 'splash',
//         builder: (context, state) => const SplashScreen(),
//       ),

//       // ==================== ONBOARDING ====================
//       GoRoute(
//         path: '/onboarding',
//         name: 'onboarding',
//         builder: (context, state) => const OnboardingScreen(),
//       ),

//       // ==================== AUTH SCREENS ====================
//       GoRoute(
//         path: '/login',
//         name: 'login',
//         builder: (context, state) => const LoginScreen(),
//       ),

//       GoRoute(
//         path: '/signup',
//         name: 'signup',
//         builder: (context, state) => const SignupScreen(),
//       ),

//       GoRoute(
//         path: '/phone-auth',
//         name: 'phone-auth',
//         builder: (context, state) => const PhoneAuthScreen(),
//       ),

//       GoRoute(
//         path: '/complete-profile',
//         name: 'complete-profile',
//         builder: (context, state) => CompleteProfileScreen(
//           onComplete: () {
//             // Refresh profile status and navigate to home
//             ref.invalidate(profileCompleteProvider);
//             context.go('/home');
//           },
//         ),
//       ),

//       // ==================== HOME SCREEN ====================
//       GoRoute(
//         path: '/home',
//         name: 'home',
//         builder: (context, state) => const HomeScreen(),
//       ),
//     ],

//     // ================================================================
//     // REDIRECT LOGIC - Fixed Version
//     // ================================================================
//     redirect: (context, state) async {
//       final location = state.matchedLocation;

//       // Identify current location type
//       final isOnSplash = location == '/';
//       final isOnOnboarding = location == '/onboarding';
//       final isOnAuth = ['/login', '/signup', '/phone-auth'].contains(location);
//       final isOnCompleteProfile = location == '/complete-profile';
//       final isOnHome = location == '/home';

//       // Get auth state
//       final user = FirebaseAuth.instance.currentUser;
//       final isLoggedIn = user != null;

//       // Get onboarding state
//       final hasSeenOnboarding = onboardingComplete;

//       // Debug logging (disable in production)
//       print('🔍 GoRouter Redirect:');
//       print('   Current: $location');
//       print('   Logged In: $isLoggedIn');
//       print('   Seen Onboarding: $hasSeenOnboarding');

//       // =============== SPLASH SCREEN LOGIC ===============
//       // Splash should redirect based on state
//       if (isOnSplash) {
//         await Future.delayed(const Duration(milliseconds: 500)); // Brief splash

//         if (isLoggedIn) {
//           // Check profile completion
//           final profileCompleteAsync = ref.read(profileCompleteProvider);
//           final profileComplete = await profileCompleteAsync.when(
//             data: (complete) => complete,
//             loading: () => false,
//             error: (_, __) => false,
//           );

//           if (profileComplete) {
//             print('   → Redirecting to /home');
//             return '/home';
//           } else {
//             print('   → Redirecting to /complete-profile');
//             return '/complete-profile';
//           }
//         } else {
//           // Not logged in
//           if (!hasSeenOnboarding) {
//             print('   → Redirecting to /onboarding');
//             return '/onboarding';
//           } else {
//             print('   → Redirecting to /login');
//             return '/login';
//           }
//         }
//       }

//       // =============== NOT LOGGED IN ===============
//       if (!isLoggedIn) {
//         // Need to see onboarding
//         if (!hasSeenOnboarding) {
//           if (!isOnOnboarding) {
//             print('   → Redirecting to /onboarding');
//             return '/onboarding';
//           }
//           print('   ✅ Staying on onboarding');
//           return null; // Stay on onboarding
//         }

//         // Onboarding seen, need to login
//         if (!isOnAuth) {
//           print('   → Redirecting to /login');
//           return '/login';
//         }

//         print('   ✅ Staying on auth screen');
//         return null; // Stay on auth screen
//       }

//       // =============== LOGGED IN ===============

//       // Check profile completion
//       final profileCompleteAsync = ref.read(profileCompleteProvider);
//       final profileComplete = await profileCompleteAsync.when(
//         data: (complete) => complete,
//         loading: () => false,
//         error: (_, __) => false,
//       );

//       print('   Profile Complete: $profileComplete');

//       // Profile not complete
//       if (!profileComplete) {
//         if (!isOnCompleteProfile) {
//           print('   → Redirecting to /complete-profile');
//           return '/complete-profile';
//         }
//         print('   ✅ Staying on complete-profile');
//         return null;
//       }

//       // Profile complete - redirect to home if on auth/onboarding screens
//       if (isOnAuth || isOnOnboarding || isOnCompleteProfile) {
//         print('   → Redirecting to /home');
//         return '/home';
//       }

//       print('   ✅ Allowing navigation');
//       return null; // Allow current route
//     },

//     // ================================================================
//     // ERROR HANDLING
//     // ================================================================
//     errorBuilder: (context, state) => Scaffold(
//       appBar: AppBar(title: const Text('Error')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 64, color: Colors.red),
//             const SizedBox(height: 16),
//             Text(
//               'Page not found: ${state.matchedLocation}',
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => context.go('/home'),
//               child: const Text('Go Home'),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// });

// -------------------------------------------------------------------------------

// // =====================================================================
// // FIXED GO_ROUTER IMPLEMENTATION - With Debug Logging & Direct Firestore Check
// // File: lib/core/router/app_router_gorouter.dart
// // =====================================================================

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:async';

// // Import your existing screens
// import '../../features/splash/presentation/screens/splash_screen.dart';
// import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
// import '../../features/auth/presentation/screens/login_screen.dart';
// import '../../features/auth/presentation/screens/signup_screen.dart';
// import '../../features/auth/presentation/screens/phone_auth_screen.dart';
// import '../../features/auth/presentation/screens/complete_profile_screen.dart';
// import '../../features/home/presentation/home_screen.dart';

// // Import providers
// import '../../features/auth/presentation/providers/auth_provider.dart';
// import '../../features/onboarding/presentation/providers/onboarding_provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// // =====================================================================
// // PROFILE COMPLETION CHECK PROVIDER
// // =====================================================================

// final profileCompleteProvider = FutureProvider<bool>((ref) async {
//   final authState = ref.watch(authStateProvider);

//   return authState.when(
//     data: (User? user) async {
//       if (user == null) return false;

//       try {
//         final doc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .get();

//         if (!doc.exists) return false;

//         final data = doc.data();
//         return data?['profileComplete'] == true;
//       } catch (e) {
//         return false;
//       }
//     },
//     loading: () => false,
//     error: (_, __) => false,
//   );
// });

// // =====================================================================
// // HELPER CLASS - GoRouter Refresh Stream
// // =====================================================================

// class GoRouterRefreshStream extends ChangeNotifier {
//   GoRouterRefreshStream(Stream<dynamic> stream) {
//     notifyListeners();
//     _subscription = stream.asBroadcastStream().listen((_) {
//       notifyListeners();
//     });
//   }

//   late final StreamSubscription<dynamic> _subscription;

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }

// // =====================================================================
// // ROUTER PROVIDER - Main GoRouter Configuration
// // =====================================================================

// final routerProvider = Provider<GoRouter>((ref) {
//   // Watch auth state for reactive navigation
//   final authState = ref.watch(authStateProvider);
//   final onboardingComplete = ref.watch(onboardingProvider);

//   return GoRouter(
//     // Start on splash, redirect will handle the rest
//     initialLocation: '/',

//     // Enable debug logging
//     debugLogDiagnostics: true,

//     // Refresh router when auth state changes
//     refreshListenable: GoRouterRefreshStream(
//       authState.asData?.value != null
//           ? Stream.value(authState.asData!.value)
//           : const Stream.empty(),
//     ),

//     // ================================================================
//     // ROUTES DEFINITION
//     // ================================================================
//     routes: [
//       // ==================== SPLASH SCREEN ====================
//       GoRoute(
//         path: '/',
//         name: 'splash',
//         builder: (context, state) => const SplashScreen(),
//       ),

//       // ==================== ONBOARDING ====================
//       GoRoute(
//         path: '/onboarding',
//         name: 'onboarding',
//         builder: (context, state) => const OnboardingScreen(),
//       ),

//       // ==================== AUTH SCREENS ====================
//       GoRoute(
//         path: '/login',
//         name: 'login',
//         builder: (context, state) => const LoginScreen(),
//       ),

//       GoRoute(
//         path: '/signup',
//         name: 'signup',
//         builder: (context, state) => const SignupScreen(),
//       ),

//       GoRoute(
//         path: '/phone-auth',
//         name: 'phone-auth',
//         builder: (context, state) => const PhoneAuthScreen(),
//       ),

//       GoRoute(
//         path: '/complete-profile',
//         name: 'complete-profile',
//         builder: (context, state) => CompleteProfileScreen(
//           onComplete: () {
//             // Refresh profile status and navigate to home
//             ref.invalidate(profileCompleteProvider);
//             context.go('/home');
//           },
//         ),
//       ),

//       // ==================== HOME SCREEN ====================
//       GoRoute(
//         path: '/home',
//         name: 'home',
//         builder: (context, state) => const HomeScreen(),
//       ),
//     ],

//     // ================================================================
//     // REDIRECT LOGIC - With Debug Logging & Direct Firestore Check
//     // ================================================================
//     redirect: (context, state) async {
//       final location = state.matchedLocation;

//       // Identify current location type
//       final isOnSplash = location == '/';
//       final isOnOnboarding = location == '/onboarding';
//       final isOnAuth = ['/login', '/signup', '/phone-auth'].contains(location);
//       final isOnCompleteProfile = location == '/complete-profile';

//       // Get auth state
//       final user = FirebaseAuth.instance.currentUser;
//       final isLoggedIn = user != null;

//       // Get onboarding state
//       final hasSeenOnboarding = onboardingComplete;

//       print('═══════════════════════════════════════');
//       print('🔍 REDIRECT CALLED');
//       print('═══════════════════════════════════════');
//       print('📍 Location: $location');
//       print('👤 Logged In: $isLoggedIn');
//       print('📋 Seen Onboarding: $hasSeenOnboarding');
//       if (isLoggedIn) {
//         print('🆔 User UID: ${user!.uid}');
//       }

//       // =============== SPLASH SCREEN LOGIC ===============
//       if (isOnSplash) {
//         print('⏳ On splash - waiting 500ms...');
//         await Future.delayed(const Duration(milliseconds: 500));

//         if (isLoggedIn) {
//           print('🔵 Checking profile completion via Direct Firestore...');

//           // Use Direct Firestore check for splash
//           bool profileComplete = false;
//           try {
//             final doc = await FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(user!.uid)
//                 .get();

//             if (doc.exists) {
//               final data = doc.data();
//               profileComplete = data?['profileComplete'] == true;
//               print('   ✅ Firestore profileComplete: $profileComplete');
//             } else {
//               print('   ❌ Document does not exist!');
//             }
//           } catch (e) {
//             print('   ❌ Firestore error: $e');
//           }

//           print('📊 Profile check result: $profileComplete');

//           if (profileComplete) {
//             print('➡️  Redirect: /splash → /home');
//             print('═══════════════════════════════════════\n');
//             return '/home';
//           } else {
//             print('➡️  Redirect: /splash → /complete-profile');
//             print('═══════════════════════════════════════\n');
//             return '/complete-profile';
//           }
//         } else {
//           // Not logged in
//           if (!hasSeenOnboarding) {
//             print('➡️  Redirect: /splash → /onboarding');
//             print('═══════════════════════════════════════\n');
//             return '/onboarding';
//           } else {
//             print('➡️  Redirect: /splash → /login');
//             print('═══════════════════════════════════════\n');
//             return '/login';
//           }
//         }
//       }

//       // =============== NOT LOGGED IN ===============
//       if (!isLoggedIn) {
//         if (!hasSeenOnboarding) {
//           if (!isOnOnboarding) {
//             print('➡️  Redirect: $location → /onboarding');
//             print('═══════════════════════════════════════\n');
//             return '/onboarding';
//           }
//           print('✅ Stay on /onboarding');
//           print('═══════════════════════════════════════\n');
//           return null;
//         }

//         if (!isOnAuth) {
//           print('➡️  Redirect: $location → /login');
//           print('═══════════════════════════════════════\n');
//           return '/login';
//         }

//         print('✅ Stay on auth screen');
//         print('═══════════════════════════════════════\n');
//         return null;
//       }

//       // =============== LOGGED IN ===============

//       print('🔵 User is logged in - checking profile...');

//       // OPTION 1: Check via Provider (current method)
//       print('🔵 Method 1: Checking via Provider...');
//       final profileCompleteAsync = ref.read(profileCompleteProvider);
//       final profileCompleteViaProvider = await profileCompleteAsync.when(
//         data: (complete) {
//           print('   ✅ Provider returned: $complete');
//           return complete;
//         },
//         loading: () {
//           print('   ⏳ Provider is loading');
//           return false;
//         },
//         error: (err, stack) {
//           print('   ❌ Provider error: $err');
//           return false;
//         },
//       );

//       // OPTION 2: Check via Direct Firestore (comparison)
//       print('🔵 Method 2: Checking via Direct Firestore...');
//       bool profileCompleteViaFirestore = false;
//       try {
//         final doc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user!.uid)
//             .get();

//         if (doc.exists) {
//           final data = doc.data();
//           profileCompleteViaFirestore = data?['profileComplete'] == true;
//           print('   📄 Firestore data: $data');
//           print('   ✅ Firestore profileComplete: ${data?['profileComplete']}');
//           print('   📊 Type: ${data?['profileComplete'].runtimeType}');
//         } else {
//           print('   ❌ Document does not exist!');
//         }
//       } catch (e) {
//         print('   ❌ Firestore error: $e');
//       }

//       print('═══════════════════════════════════════');
//       print('📊 COMPARISON:');
//       print('   Provider says: $profileCompleteViaProvider');
//       print('   Firestore says: $profileCompleteViaFirestore');
//       print(
//         '   Match: ${profileCompleteViaProvider == profileCompleteViaFirestore}',
//       );
//       print('═══════════════════════════════════════');

//       // ✅ USE DIRECT FIRESTORE CHECK (more reliable than provider)
//       final profileComplete = profileCompleteViaFirestore;

//       print('📊 Using profileComplete = $profileComplete');

//       // Profile not complete
//       if (!profileComplete) {
//         if (!isOnCompleteProfile) {
//           print('➡️  Redirect: $location → /complete-profile');
//           print('═══════════════════════════════════════\n');
//           return '/complete-profile';
//         }
//         print('✅ Stay on /complete-profile');
//         print('═══════════════════════════════════════\n');
//         return null;
//       }

//       // Profile complete - redirect to home if on auth/onboarding screens
//       if (isOnAuth || isOnOnboarding || isOnCompleteProfile) {
//         print('➡️  Redirect: $location → /home (profile complete)');
//         print('═══════════════════════════════════════\n');
//         return '/home';
//       }

//       print('✅ Allow navigation to $location');
//       print('═══════════════════════════════════════\n');
//       return null;
//     },

//     // ================================================================
//     // ERROR HANDLING
//     // ================================================================
//     errorBuilder: (context, state) => Scaffold(
//       appBar: AppBar(title: const Text('Error')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 64, color: Colors.red),
//             const SizedBox(height: 16),
//             Text(
//               'Page not found: ${state.matchedLocation}',
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => context.go('/home'),
//               child: const Text('Go Home'),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// });

// -----------------------------------------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:async';

// // Import your existing screens
// import '../../features/splash/presentation/screens/splash_screen.dart';
// import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
// import '../../features/auth/presentation/screens/login_screen.dart';
// import '../../features/auth/presentation/screens/signup_screen.dart';
// import '../../features/auth/presentation/screens/phone_auth_screen.dart';
// import '../../features/auth/presentation/screens/complete_profile_screen.dart';
// import '../../features/home/presentation/home_screen.dart';

// // Import providers
// import '../../features/auth/presentation/providers/auth_provider.dart';
// import '../../features/onboarding/presentation/providers/onboarding_provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// // =====================================================================
// // PROFILE COMPLETION CHECK PROVIDER
// // =====================================================================

// final profileCompleteProvider = FutureProvider<bool>((ref) async {
//   final authState = ref.watch(authStateProvider);

//   return authState.when(
//     data: (User? user) async {
//       if (user == null) return false;

//       try {
//         final doc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .get();

//         if (!doc.exists) return false;

//         final data = doc.data();
//         return data?['profileComplete'] == true;
//       } catch (e) {
//         return false;
//       }
//     },
//     loading: () => false,
//     error: (_, __) => false,
//   );
// });

// // =====================================================================
// // HELPER CLASS - GoRouter Refresh Stream
// // =====================================================================

// class GoRouterRefreshStream extends ChangeNotifier {
//   GoRouterRefreshStream(Stream<dynamic> stream) {
//     notifyListeners();
//     _subscription = stream.asBroadcastStream().listen((_) {
//       notifyListeners();
//     });
//   }

//   late final StreamSubscription<dynamic> _subscription;

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }

// // =====================================================================
// // ROUTER PROVIDER - Main GoRouter Configuration
// // =====================================================================

// final routerProvider = Provider<GoRouter>((ref) {
//   final authState = ref.watch(authStateProvider);
//   final onboardingComplete = ref.watch(onboardingProvider);

//   return GoRouter(
//     initialLocation: '/',
//     debugLogDiagnostics: false,

//     refreshListenable: GoRouterRefreshStream(
//       authState.asData?.value != null
//           ? Stream.value(authState.asData!.value)
//           : const Stream.empty(),
//     ),

//     // ================================================================
//     // ROUTES
//     // ================================================================
//     routes: [
//       GoRoute(
//         path: '/',
//         name: 'splash',
//         builder: (context, state) => const SplashScreen(),
//       ),

//       GoRoute(
//         path: '/onboarding',
//         name: 'onboarding',
//         builder: (context, state) => const OnboardingScreen(),
//       ),

//       GoRoute(
//         path: '/login',
//         name: 'login',
//         builder: (context, state) => const LoginScreen(),
//       ),

//       GoRoute(
//         path: '/signup',
//         name: 'signup',
//         builder: (context, state) => const SignupScreen(),
//       ),

//       GoRoute(
//         path: '/phone-auth',
//         name: 'phone-auth',
//         builder: (context, state) => const PhoneAuthScreen(),
//       ),

//       GoRoute(
//         path: '/complete-profile',
//         name: 'complete-profile',
//         builder: (context, state) => CompleteProfileScreen(
//           // onComplete: () {
//           //   ref.invalidate(profileCompleteProvider);
//           //   context.go('/home');
//           // },
//         ),
//       ),

//       GoRoute(
//         path: '/home',
//         name: 'home',
//         builder: (context, state) => const HomeScreen(),
//       ),
//     ],

//     // ================================================================
//     // REDIRECT LOGIC
//     // ================================================================
//     redirect: (context, state) async {
//       final location = state.matchedLocation;
//       final isOnSplash = location == '/';
//       final isOnOnboarding = location == '/onboarding';
//       final isOnAuth = ['/login', '/signup', '/phone-auth'].contains(location);
//       final isOnCompleteProfile = location == '/complete-profile';

//       final user = FirebaseAuth.instance.currentUser;
//       final isLoggedIn = user != null;
//       final hasSeenOnboarding = onboardingComplete;

//       // =============== SPLASH SCREEN ===============
//       if (isOnSplash) {
//         await Future.delayed(const Duration(milliseconds: 500));

//         if (isLoggedIn) {
//           // Direct Firestore check for reliability
//           try {
//             final doc = await FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(user!.uid)
//                 .get();

//             if (doc.exists) {
//               final profileComplete = doc.data()?['profileComplete'] == true;
//               return profileComplete ? '/home' : '/complete-profile';
//             }
//           } catch (e) {
//             return '/complete-profile';
//           }
//         } else {
//           return hasSeenOnboarding ? '/login' : '/onboarding';
//         }
//       }

//       // =============== NOT LOGGED IN ===============
//       if (!isLoggedIn) {
//         if (!hasSeenOnboarding && !isOnOnboarding) {
//           return '/onboarding';
//         }
//         if (hasSeenOnboarding && !isOnAuth) {
//           return '/login';
//         }
//         return null;
//       }

//       // =============== LOGGED IN ===============
//       // Direct Firestore check (bypasses provider caching)
//       try {
//         final doc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user!.uid)
//             .get();

//         if (!doc.exists) {
//           return isOnCompleteProfile ? null : '/complete-profile';
//         }

//         final profileComplete = doc.data()?['profileComplete'] == true;

//         if (!profileComplete) {
//           return isOnCompleteProfile ? null : '/complete-profile';
//         }

//         if (isOnAuth || isOnOnboarding || isOnCompleteProfile) {
//           return '/home';
//         }

//         return null;
//       } catch (e) {
//         return isOnCompleteProfile ? null : '/complete-profile';
//       }
//     },

//     // ================================================================
//     // ERROR HANDLING
//     // ================================================================
//     errorBuilder: (context, state) => Scaffold(
//       appBar: AppBar(title: const Text('Error')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 64, color: Colors.red),
//             const SizedBox(height: 16),
//             Text(
//               'Page not found: ${state.matchedLocation}',
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => context.go('/home'),
//               child: const Text('Go Home'),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// });

// -----------------------------------------Without call back of complete profile screen---------------------

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:async';

// // Import your existing screens
// import '../../features/splash/presentation/screens/splash_screen.dart';
// import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
// import '../../features/auth/presentation/screens/login_screen.dart';
// import '../../features/auth/presentation/screens/signup_screen.dart';
// import '../../features/auth/presentation/screens/phone_auth_screen.dart';
// import '../../features/auth/presentation/screens/complete_profile_screen.dart';
// import '../../features/home/presentation/home_screen.dart';

// // Import providers
// import '../../features/auth/presentation/providers/auth_provider.dart';
// import '../../features/onboarding/presentation/providers/onboarding_provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// // =====================================================================
// // PROFILE COMPLETION CHECK PROVIDER
// // =====================================================================

// final profileCompleteProvider = FutureProvider<bool>((ref) async {
//   final authState = ref.watch(authStateProvider);

//   return authState.when(
//     data: (User? user) async {
//       if (user == null) return false;

//       try {
//         final doc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .get();

//         if (!doc.exists) return false;

//         final data = doc.data();
//         return data?['profileComplete'] == true;
//       } catch (e) {
//         return false;
//       }
//     },
//     loading: () => false,
//     error: (_, __) => false,
//   );
// });

// // =====================================================================
// // HELPER CLASS - GoRouter Refresh Stream
// // =====================================================================

// class GoRouterRefreshStream extends ChangeNotifier {
//   GoRouterRefreshStream(Stream<dynamic> stream) {
//     notifyListeners();
//     _subscription = stream.asBroadcastStream().listen((_) {
//       notifyListeners();
//     });
//   }

//   late final StreamSubscription<dynamic> _subscription;

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }

// // =====================================================================
// // ROUTER PROVIDER - Main GoRouter Configuration
// // =====================================================================

// final routerProvider = Provider<GoRouter>((ref) {
//   final authState = ref.watch(authStateProvider);
//   final onboardingComplete = ref.watch(onboardingProvider);

//   return GoRouter(
//     initialLocation: '/',
//     debugLogDiagnostics: false,

//     refreshListenable: GoRouterRefreshStream(
//       authState.asData?.value != null
//           ? Stream.value(authState.asData!.value)
//           : const Stream.empty(),
//     ),

//     // ================================================================
//     // ROUTES
//     // ================================================================
//     routes: [
//       GoRoute(
//         path: '/',
//         name: 'splash',
//         builder: (context, state) => const SplashScreen(),
//       ),

//       GoRoute(
//         path: '/onboarding',
//         name: 'onboarding',
//         builder: (context, state) => const OnboardingScreen(),
//       ),

//       GoRoute(
//         path: '/login',
//         name: 'login',
//         builder: (context, state) => const LoginScreen(),
//       ),

//       GoRoute(
//         path: '/signup',
//         name: 'signup',
//         builder: (context, state) => const SignupScreen(),
//       ),

//       GoRoute(
//         path: '/phone-auth',
//         name: 'phone-auth',
//         builder: (context, state) => const PhoneAuthScreen(),
//       ),

//       // ✅ FIXED: No onComplete callback needed
//       GoRoute(
//         path: '/complete-profile',
//         name: 'complete-profile',
//         builder: (context, state) => const CompleteProfileScreen(),
//       ),

//       GoRoute(
//         path: '/home',
//         name: 'home',
//         builder: (context, state) => const HomeScreen(),
//       ),
//     ],

//     // ================================================================
//     // REDIRECT LOGIC
//     // ================================================================
//     redirect: (context, state) async {
//       final location = state.matchedLocation;
//       final isOnSplash = location == '/';
//       final isOnOnboarding = location == '/onboarding';
//       final isOnAuth = ['/login', '/signup', '/phone-auth'].contains(location);
//       final isOnCompleteProfile = location == '/complete-profile';

//       final user = FirebaseAuth.instance.currentUser;
//       final isLoggedIn = user != null;
//       final hasSeenOnboarding = onboardingComplete;

//       // =============== SPLASH SCREEN ===============
//       if (isOnSplash) {
//         await Future.delayed(const Duration(seconds: 5));

//         if (isLoggedIn) {
//           // Direct Firestore check for reliability
//           try {
//             final doc = await FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(user!.uid)
//                 .get();

//             if (doc.exists) {
//               final profileComplete = doc.data()?['profileComplete'] == true;
//               return profileComplete ? '/home' : '/complete-profile';
//             }
//           } catch (e) {
//             return '/complete-profile';
//           }
//         } else {
//           return hasSeenOnboarding ? '/login' : '/onboarding';
//         }
//       }

//       // =============== NOT LOGGED IN ===============
//       if (!isLoggedIn) {
//         if (!hasSeenOnboarding && !isOnOnboarding) {
//           return '/onboarding';
//         }
//         if (hasSeenOnboarding && !isOnAuth) {
//           return '/login';
//         }
//         return null;
//       }

//       // =============== LOGGED IN ===============
//       // Direct Firestore check (bypasses provider caching)
//       try {
//         final doc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user!.uid)
//             .get();

//         if (!doc.exists) {
//           return isOnCompleteProfile ? null : '/complete-profile';
//         }

//         final profileComplete = doc.data()?['profileComplete'] == true;

//         if (!profileComplete) {
//           return isOnCompleteProfile ? null : '/complete-profile';
//         }

//         if (isOnAuth || isOnOnboarding || isOnCompleteProfile) {
//           return '/home';
//         }

//         return null;
//       } catch (e) {
//         return isOnCompleteProfile ? null : '/complete-profile';
//       }
//     },

//     // ================================================================
//     // ERROR HANDLING
//     // ================================================================
//     errorBuilder: (context, state) => Scaffold(
//       appBar: AppBar(title: const Text('Error')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 64, color: Colors.red),
//             const SizedBox(height: 16),
//             Text(
//               'Page not found: ${state.matchedLocation}',
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => context.go('/home'),
//               child: const Text('Go Home'),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// });

// ------------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

// Import your existing screens
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/phone_auth_screen.dart';
import '../../features/auth/presentation/screens/complete_profile_screen.dart';
import '../../features/home/presentation/home_screen.dart';

// Import providers
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// =====================================================================
// PROFILE COMPLETION CHECK PROVIDER
// =====================================================================

final profileCompleteProvider = FutureProvider<bool>((ref) async {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (User? user) async {
      if (user == null) return false;

      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!doc.exists) return false;

        final data = doc.data();
        return data?['profileComplete'] == true;
      } catch (e) {
        return false;
      }
    },
    loading: () => false,
    error: (_, __) => false,
  );
});

// =====================================================================
// HELPER CLASS - GoRouter Refresh Stream
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
// SPLASH TIMER PROVIDER (Non-blocking)
// =====================================================================

final splashTimerProvider = StateNotifierProvider<SplashTimerNotifier, bool>(
  (ref) => SplashTimerNotifier(),
);

class SplashTimerNotifier extends StateNotifier<bool> {
  Timer? _timer;

  SplashTimerNotifier() : super(false) {
    // Start timer when created
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 4), () {
      state = true; // Timer completed
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// =====================================================================
// ROUTER PROVIDER - Main GoRouter Configuration
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

    // ================================================================
    // ROUTES
    // ================================================================
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

    // ================================================================
    // REDIRECT LOGIC (Non-blocking!)
    // ================================================================
    redirect: (context, state) async {
      final location = state.matchedLocation;
      final isOnSplash = location == '/';
      final isOnOnboarding = location == '/onboarding';
      final isOnAuth = ['/login', '/signup', '/phone-auth'].contains(location);
      final isOnCompleteProfile = location == '/complete-profile';

      final user = FirebaseAuth.instance.currentUser;
      final isLoggedIn = user != null;
      final hasSeenOnboarding = onboardingComplete;

      // =============== SPLASH SCREEN ===============
      // ✅ Non-blocking check - UI renders while timer runs!
      if (isOnSplash) {
        // If timer not complete, stay on splash
        if (!splashComplete) {
          return null;
        }

        // Timer complete - navigate!
        if (isLoggedIn) {
          try {
            final doc = await FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .get();

            if (doc.exists) {
              final profileComplete = doc.data()?['profileComplete'] == true;
              return profileComplete ? '/home' : '/complete-profile';
            }
            return '/complete-profile';
          } catch (e) {
            return '/complete-profile';
          }
        } else {
          return hasSeenOnboarding ? '/login' : '/onboarding';
        }
      }

      // =============== NOT LOGGED IN ===============
      if (!isLoggedIn) {
        if (!hasSeenOnboarding && !isOnOnboarding) {
          return '/onboarding';
        }
        if (hasSeenOnboarding && !isOnAuth) {
          return '/login';
        }
        return null;
      }

      // =============== LOGGED IN ===============
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
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
      } catch (e) {
        return isOnCompleteProfile ? null : '/complete-profile';
      }
    },

    // ================================================================
    // ERROR HANDLING
    // ================================================================
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
