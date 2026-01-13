import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// =====================================================================
// BOTTOM NAVIGATION
// =====================================================================

final homeBottomNavIndexProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

// =====================================================================
// BANNER STATE
// =====================================================================

final homeBannerIndexProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

final homeBannerPageControllerProvider = Provider.autoDispose<PageController>((
  ref,
) {
  final controller = PageController(initialPage: 0);
  ref.onDispose(() => controller.dispose());
  return controller;
});

// =====================================================================
// AUTO-SCROLL TIMER - RIVERPOD 3.0.3 CORRECT VERSION
// =====================================================================

const int _totalBanners = 2;
const Duration _scrollInterval = Duration(seconds: 5);

/// ✅ RIVERPOD 3.0+: Use Notifier directly (not AutoDisposeNotifier)
class BannerAutoScrollNotifier extends Notifier<Timer?> {
  @override
  Timer? build() {
    // Create timer
    final timer = Timer.periodic(_scrollInterval, (t) {
      final pageController = ref.read(homeBannerPageControllerProvider);
      final currentIndex = ref.read(homeBannerIndexProvider);

      final nextIndex = (currentIndex + 1) % _totalBanners;
      ref.read(homeBannerIndexProvider.notifier).state = nextIndex;

      if (pageController.hasClients) {
        pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });

    // ✅ Cleanup using ref.onDispose()
    ref.onDispose(() {
      timer.cancel();
    });

    return timer;
  }
}

/// ✅ RIVERPOD 3.0+: Use NotifierProvider.autoDispose
final homeBannerAutoScrollProvider =
    NotifierProvider.autoDispose<BannerAutoScrollNotifier, Timer?>(
      BannerAutoScrollNotifier.new,
    );

// =====================================================================
// HELPER FUNCTIONS
// =====================================================================

void updateBannerIndexOnSwipe(WidgetRef ref, int newIndex) {
  ref.read(homeBannerIndexProvider.notifier).state = newIndex;
}

void navigateToTab(WidgetRef ref, int tabIndex) {
  ref.read(homeBottomNavIndexProvider.notifier).state = tabIndex;
}
