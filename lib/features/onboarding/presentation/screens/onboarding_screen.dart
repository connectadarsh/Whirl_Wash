// ----------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/onboarding_data.dart';
import '../providers/onboarding_provider.dart';
import '../../../../core/constants/app_colors.dart';

// Modern Riverpod Notifiers
class CurrentPageNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setPage(int page) {
    state = page;
  }
}

final currentPageProvider = NotifierProvider<CurrentPageNotifier, int>(() {
  return CurrentPageNotifier();
});

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
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background gradient (matching home screen)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.backgroundGradient,
              ),
            ),
          ),

          // Dark overlay (matching home/auth screens)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.overlayDark1.withValues(alpha: 0.78),
                    AppColors.overlayDark2,
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => _completeOnboarding(ref),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: AppColors.secondary,
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
                      ref.read(currentPageProvider.notifier).setPage(index);
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
                      _buildActionButton(
                        pages,
                        currentPage,
                        pageController,
                        ref,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
                  color: AppColors.secondary.withValues(alpha: 0.5),
                );
              },
            ),
          ),

          const SizedBox(height: 48),

          // Title - Bold, white, highly visible
          Text(
            item.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary.withValues(alpha: 0.95),
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
                color: AppColors.secondary,
                letterSpacing: 0.3,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),

          const SizedBox(height: 20),

          // Description - Clear, readable
          Text(
            item.description,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textDisabled,
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
                ? AppColors.secondary
                : AppColors.divider,
            borderRadius: BorderRadius.circular(5),
            boxShadow: currentPage == index
                ? [
                    BoxShadow(
                      color: AppColors.shadowSecondary,
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
        gradient: AppColors.buttonGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowSecondary,
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
          backgroundColor: AppColors.transparent,
          shadowColor: AppColors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastPage ? 'Get Started' : 'Next',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.textPrimary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
