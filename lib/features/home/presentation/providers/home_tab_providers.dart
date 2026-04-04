import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// =====================================================================
// BANNER PROVIDERS
// =====================================================================

final homeBannerIndexProvider = StateProvider<int>((ref) => 0);

final homeBannerPageControllerProvider = Provider.autoDispose<PageController>((
  ref,
) {
  final controller = PageController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final homeBannerAutoScrollProvider = Provider.autoDispose<void>((ref) {
  final timer = Timer.periodic(const Duration(seconds: 4), (_) {
    final controller = ref.read(homeBannerPageControllerProvider);
    final index = ref.read(homeBannerIndexProvider);
    if (!controller.hasClients) return;
    final next = (index + 1) % 2;
    controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    ref.read(homeBannerIndexProvider.notifier).state = next;
  });
  ref.onDispose(() => timer.cancel());
});

void updateBannerIndexOnSwipe(WidgetRef ref, int index) {
  ref.read(homeBannerIndexProvider.notifier).state = index;
}
