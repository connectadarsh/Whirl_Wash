import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whirl_wash/features/splash/presentation/screens/splash_screen.dart';
import 'firebase_options.dart';

import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/onboarding/presentation/providers/onboarding_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhirlWash',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const AppRouter(),
    );
  }
}

class AppRouter extends ConsumerStatefulWidget {
  const AppRouter({Key? key}) : super(key: key);

  @override
  ConsumerState<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends ConsumerState<AppRouter> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Show splash screen for 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen while loading
    if (_isLoading) {
      return const SplashScreen(); // ← Works with both Stateful/Stateless
    }

    // Check if user has seen onboarding
    final hasSeenOnboarding = ref.watch(onboardingProvider);

    if (!hasSeenOnboarding) {
      return const OnboardingScreen(); // ← Works with both Stateful/Stateless
    }

    // After onboarding, show placeholder
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhirlWash'),
        backgroundColor: const Color(0xFF4ECDC4),
      ),
      body: Container(
        color: const Color(0xFF0D1B1E),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 80,
                color: Color(0xFF4ECDC4),
              ),
              const SizedBox(height: 20),
              const Text(
                'Onboarding Complete!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Next: We\'ll add Login Screen',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Reset onboarding to see it again
                  ref.read(onboardingProvider.notifier).resetOnboarding();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ECDC4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'Reset & See Onboarding Again',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
