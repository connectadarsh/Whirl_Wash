// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:whirl_wash/features/onboarding/presentation/screens/onboarding_screen.dart';
// import 'package:whirl_wash/features/splash/presentation/screens/splash_screen.dart';
// import '../../features/auth/presentation/providers/auth_provider.dart';
// import '../../features/onboarding/presentation/providers/onboarding_provider.dart';

// import '../../features/auth/presentation/screens/login_screen.dart';
// import '../../features/auth/presentation/screens/complete_profile_screen.dart';
// import '../../features/home/presentation/home_screen.dart';

// // Provider to check if profile is complete
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

// class AppRouter extends ConsumerWidget {
//   const AppRouter({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authStateProvider);
//     final hasSeenOnboarding = ref.watch(onboardingProvider);

//     return authState.when(
//       data: (User? user) {
//         // User is logged in
//         if (user != null) {
//           // Check if profile is complete
//           final profileComplete = ref.watch(profileCompleteProvider);

//           return profileComplete.when(
//             data: (isComplete) {
//               if (isComplete) {
//                 return const HomeScreen();
//               } else {
//                 return CompleteProfileScreen(
//                   onComplete: () {
//                     // Refresh profile status
//                     ref.invalidate(profileCompleteProvider);
//                   },
//                 );
//               }
//             },
//             loading: () => const SplashScreen(),
//             error: (_, __) => CompleteProfileScreen(
//               onComplete: () {
//                 ref.invalidate(profileCompleteProvider);
//               },
//             ),
//           );
//         }

//         // User is not logged in
//         // Check if onboarding has been seen
//         if (hasSeenOnboarding) {
//           return const LoginScreen();
//         } else {
//           return const OnboardingScreen();
//         }
//       },
//       loading: () => const SplashScreen(),
//       error: (_, __) => const LoginScreen(),
//     );
//   }
// }
