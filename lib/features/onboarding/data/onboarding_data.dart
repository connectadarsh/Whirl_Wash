// ----------------------------------New------------------------------------------

class OnboardingItem {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;

  OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
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
    ),
    OnboardingItem(
      title: 'Hygienic & Safe Cleaning',
      subtitle: 'Sanitized machines, fresh water.',
      description:
          'Sanitized machines, fresh water washes, and secure handling for every order.',
      imagePath: 'assets/images/onboarding_2.png',
    ),
    OnboardingItem(
      title: 'Doorstep Pickup & Fast Delivery',
      subtitle: 'Convenient service at your door.',
      description:
          'Schedule pickup from your home, get fast and reliable delivery, and pay only after accurate weighing — no guesswork.',
      imagePath: 'assets/images/onboarding_3.png',
    ),
  ];
}
