// import 'package:flutter/material.dart';

// class OnboardingPage {
//   final String title;
//   final String description;
//   final IconData icon;
//   final Color color;

//   OnboardingPage({
//     required this.title,
//     required this.description,
//     required this.icon,
//     required this.color,
//   });
// }

// class OnboardingData {
//   static List<OnboardingPage> pages = [
//     OnboardingPage(
//       title: 'Welcome to WhirlWash',
//       description:
//           'Your one-stop solution for all laundry needs. Get your clothes cleaned professionally.',
//       icon: Icons.local_laundry_service,
//       color: const Color(0xFF4ECDC4),
//     ),
//     OnboardingPage(
//       title: 'Easy Booking',
//       description:
//           'Browse services, add items to cart, and place orders in just a few taps.',
//       icon: Icons.shopping_cart,
//       color: const Color(0xFF6B9FE8),
//     ),
//     OnboardingPage(
//       title: 'Track Your Orders',
//       description:
//           'Real-time order tracking from pickup to delivery. Stay updated every step of the way.',
//       icon: Icons.track_changes,
//       color: const Color(0xFFFFB84D),
//     ),
//     OnboardingPage(
//       title: 'Fast & Reliable',
//       description:
//           'Professional cleaning with quick turnaround. Quality service you can trust.',
//       icon: Icons.rocket_launch,
//       color: const Color(0xFF9B59B6),
//     ),
//   ];
// }

// ----------------------------------------------------------------------------------------------------
import 'package:flutter/material.dart';

class OnboardingItem {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final Color color;
  final LinearGradient gradient;

  OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.color,
    required this.gradient,
  });
}

class OnboardingData {
  static List<OnboardingItem> pages = [
    OnboardingItem(
      title: 'Expert Fabric Care',
      subtitle: 'Professional handling, every time.',
      description:
          'Clothes are handled by trained professionals using fabric-specific cleaning methods.',
      imagePath: 'assets/images/onboarding_1.png',
      color: const Color(0xFF4ECDC4), // Teal
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
      ),
    ),
    OnboardingItem(
      title: 'Hygienic & Safe Cleaning',
      subtitle: 'Sanitized machines, fresh water.',
      description:
          'Sanitized machines, fresh water washes, and secure handling for every order.',
      imagePath: 'assets/images/onboarding_2.png',
      color: const Color(0xFF4ECDC4), // Same teal
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
      ),
    ),
    OnboardingItem(
      title: 'Doorstep Pickup & Fast Delivery.',
      subtitle: 'Convenient service at your door.',
      description:
          'Schedule pickup from your home, get fast and reliable delivery, and pay only after accurate weighing — no guesswork.',
      imagePath: 'assets/images/onboarding_3.png',
      color: const Color(0xFF4ECDC4), // Same teal
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
      ),
    ),
  ];
}
