// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';

// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import '../../data/onboarding_data.dart';
// import '../providers/onboarding_provider.dart';

// // StateProvider to track current page
// final currentPageProvider = StateProvider<int>((ref) => 0);

// // Provider for PageController
// final pageControllerProvider = Provider<PageController>((ref) {
//   return PageController();
// });

// class OnboardingScreen extends ConsumerWidget {
//   const OnboardingScreen({Key? key}) : super(key: key);

//   void _completeOnboarding(WidgetRef ref) {
//     ref.read(onboardingProvider.notifier).completeOnboarding();
//   }

//   void _nextPage(WidgetRef ref, PageController controller) {
//     final currentPage = ref.read(currentPageProvider);

//     if (currentPage < OnboardingData.pages.length - 1) {
//       controller.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       _completeOnboarding(ref);
//     }
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentPage = ref.watch(currentPageProvider);
//     final pageController = ref.watch(pageControllerProvider);

//     return Scaffold(
//       backgroundColor: const Color(0xFF0D1B1E),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Skip button
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   if (currentPage < OnboardingData.pages.length - 1)
//                     TextButton(
//                       onPressed: () => _completeOnboarding(ref),
//                       child: Text(
//                         'Skip',
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.6),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//             // Page view
//             Expanded(
//               child: PageView.builder(
//                 controller: pageController,
//                 onPageChanged: (index) {
//                   ref.read(currentPageProvider.notifier).state = index;
//                 },
//                 itemCount: OnboardingData.pages.length,
//                 itemBuilder: (context, index) {
//                   return _buildPage(OnboardingData.pages[index]);
//                 },
//               ),
//             ),

//             // Page indicator
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: SmoothPageIndicator(
//                 controller: pageController,
//                 count: OnboardingData.pages.length,
//                 effect: ExpandingDotsEffect(
//                   activeDotColor: const Color(0xFF4ECDC4),
//                   dotColor: Colors.white.withOpacity(0.2),
//                   dotHeight: 10,
//                   dotWidth: 10,
//                   expansionFactor: 4,
//                   spacing: 8,
//                 ),
//               ),
//             ),

//             // Next/Get Started button
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () => _nextPage(ref, pageController),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF4ECDC4),
//                     padding: const EdgeInsets.symmetric(vertical: 18),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: Text(
//                     currentPage == OnboardingData.pages.length - 1
//                         ? 'Get Started'
//                         : 'Next',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPage(OnboardingPage page) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 40),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Icon
//           Container(
//             width: 200,
//             height: 200,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 colors: [
//                   page.color.withOpacity(0.3),
//                   page.color.withOpacity(0.1),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Icon(page.icon, size: 100, color: page.color),
//           ),

//           const SizedBox(height: 60),

//           // Title
//           Text(
//             page.title,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               letterSpacing: 0.5,
//               height: 1.2,
//             ),
//           ),

//           const SizedBox(height: 20),

//           // Description
//           Text(
//             page.description,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white.withOpacity(0.7),
//               height: 1.6,
//               letterSpacing: 0.3,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ---------------------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/onboarding_data.dart';
import '../providers/onboarding_provider.dart';

// Providers
final currentPageProvider = StateProvider<int>((ref) => 0);
final pageControllerProvider = Provider<PageController>(
  (ref) => PageController(),
);

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  void _completeOnboarding(WidgetRef ref) {
    ref.read(onboardingProvider.notifier).completeOnboarding();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);
    final pageController = ref.watch(pageControllerProvider);
    final pages = OnboardingData.pages;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(
                0xFF4ECDC4,
              ).withValues(alpha: 0.20), // Stronger teal at top
              const Color(
                0xFF4ECDC4,
              ).withValues(alpha: 0.18), // Keep teal longer
              const Color(
                0xFF4ECDC4,
              ).withValues(alpha: 0.12), // Gradual transition
              Colors.white.withValues(alpha: 0.95), // Less white at bottom
            ],
            stops: const [0.0, 0.4, 0.7, 1.0], // Control gradient spread
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => _completeOnboarding(ref),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFF2C9B8E), // Darker teal for contrast
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) {
                    ref.read(currentPageProvider.notifier).state = index;
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(pages[index]);
                  },
                ),
              ),

              // Bottom section with dots and button
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
                child: Column(
                  children: [
                    // Page indicators
                    _buildPageIndicators(pages, currentPage),
                    const SizedBox(height: 32),

                    // Next/Get Started button
                    _buildActionButton(pages, currentPage, pageController, ref),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image - blends with background
          SizedBox(
            height: 280,
            width: 280,
            child: Image.asset(
              item.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.local_laundry_service,
                  size: 120,
                  color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                );
              },
            ),
          ),

          const SizedBox(height: 48),

          // Title - Bold, dark, highly visible
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800, // Extra bold
              color: Color.fromARGB(
                255,
                240,
                236,
                236,
              ), // Almost black for maximum contrast
              letterSpacing: -0.5,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Subtitle - Teal accent
          if (item.subtitle.isNotEmpty)
            Text(
              item.subtitle,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C9B8E), // Darker teal for visibility
                letterSpacing: 0.3,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),

          const SizedBox(height: 20),

          // Description - Clear, readable
          Text(
            item.description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(
                255,
                122,
                119,
                119,
              ), // Dark gray for readability
              height: 1.7,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators(List<OnboardingItem> pages, int currentPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: currentPage == index ? 36 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: currentPage == index
                ? const Color(0xFF4ECDC4) // Bright teal when active
                : const Color(0xFFB0B0B0), // Medium gray when inactive
            borderRadius: BorderRadius.circular(5),
            boxShadow: currentPage == index
                ? [
                    BoxShadow(
                      color: const Color(0xFF4ECDC4).withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    List<OnboardingItem> pages,
    int currentPage,
    PageController pageController,
    WidgetRef ref,
  ) {
    final isLastPage = currentPage == pages.length - 1;

    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4ECDC4), // Bright teal
            Color(0xFF44A08D), // Green-teal
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(29),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ECDC4).withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (isLastPage) {
            _completeOnboarding(ref);
          } else {
            pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(29),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastPage ? 'Get Started' : 'Next',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700, // Bold
                color: Colors.white,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
