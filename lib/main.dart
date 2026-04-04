import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/router/app_router_gorouter.dart'; // ← NEW: Import GoRouter
import 'firebase_options.dart';
import 'features/auth/data/repositories/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
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
