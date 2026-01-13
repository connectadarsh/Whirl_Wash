// ---------------------------------Main v7------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'core/router/app_router.dart';
// import 'firebase_options.dart';
// import 'features/auth/data/repositories/auth_repository.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Firebase
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   // Initialize Google Sign-In
//   final authRepository = AuthRepository();
//   await authRepository.initializeGoogleSignIn();

//   runApp(const ProviderScope(child: MyApp()));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'WhirlWash',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4ECDC4)),
//         useMaterial3: true,
//         fontFamily: 'SF Pro Display', // Optional: if you have custom fonts
//       ),
//       home: const AppRouter(), // This handles all navigation logic
//     );
//   }
// }

// ---------------------------------------------------------------------------------------------------

// =====================================================================
// UPDATED main.dart - With GoRouter
// Replace your existing main.dart with this
// =====================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/router/app_router_gorouter.dart'; // ← NEW: Import GoRouter
import 'firebase_options.dart';
import 'features/auth/data/repositories/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Google Sign-In
  final authRepository = AuthRepository();
  await authRepository.initializeGoogleSignIn();

  runApp(const ProviderScope(child: MyApp()));
}

// =====================================================================
// CHANGE 1: StatelessWidget → ConsumerWidget
// CHANGE 2: MaterialApp → MaterialApp.router
// =====================================================================

class MyApp extends ConsumerWidget {
  // ← Changed from StatelessWidget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ← Added WidgetRef
    final router = ref.watch(routerProvider); // ← Watch GoRouter provider

    return MaterialApp.router(
      // ← Changed from MaterialApp
      routerConfig: router, // ← Use GoRouter instead of home
      title: 'WhirlWash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4ECDC4)),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
    );
  }
}
