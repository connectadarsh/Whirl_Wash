import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'screens/home_tab.dart';
import 'screens/orders_tab.dart';
import 'screens/cart_tab.dart';
import 'screens/profile_tab.dart';

// =====================================================================
// BOTTOM NAV INDEX PROVIDER
// =====================================================================

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// =====================================================================
// BOTTOM NAV PAGE
// =====================================================================

class BottomNavPage extends ConsumerWidget {
  const BottomNavPage({super.key});

  static const List<String> _routes = ['/home', '/orders', '/cart', '/profile'];

  static const List<Widget> _tabs = [
    HomeTab(),
    OrdersTab(),
    CartTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sync index from current route
    final location = GoRouterState.of(context).matchedLocation;
    final routeIndex = _routes.indexWhere((r) => location.startsWith(r));
    final currentIndex = routeIndex >= 0 ? routeIndex : 0;

    // Keep provider in sync
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(bottomNavIndexProvider) != currentIndex) {
        ref.read(bottomNavIndexProvider.notifier).state = currentIndex;
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(index: currentIndex, children: _tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: GNav(
              selectedIndex: currentIndex,
              onTabChange: (index) => context.go(_routes[index]),
              color: Colors.white.withValues(alpha: 0.4),
              activeColor: Colors.white,
              tabBackgroundColor: AppColors.secondary.withValues(alpha: 0.15),
              gap: 8,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              haptic: true,
              tabBorderRadius: 14,
              tabs: const [
                GButton(
                  icon: Icons.home_rounded,
                  text: 'Home',
                  iconActiveColor: AppColors.secondary,
                  textColor: AppColors.secondary,
                ),
                GButton(
                  icon: Icons.receipt_long_rounded,
                  text: 'Orders',
                  iconActiveColor: AppColors.secondary,
                  textColor: AppColors.secondary,
                ),
                GButton(
                  icon: Icons.shopping_cart_rounded,
                  text: 'Cart',
                  iconActiveColor: AppColors.secondary,
                  textColor: AppColors.secondary,
                ),
                GButton(
                  icon: Icons.person_rounded,
                  text: 'Profile',
                  iconActiveColor: AppColors.secondary,
                  textColor: AppColors.secondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
