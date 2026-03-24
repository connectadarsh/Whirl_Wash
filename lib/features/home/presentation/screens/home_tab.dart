// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:go_router/go_router.dart';
// import 'package:whirl_wash/features/auth/data/models/user_model.dart';
// import '../providers/home_screen_providers.dart';
// import '../../../auth/presentation/providers/auth_provider.dart';
// import '../../../../../core/constants/app_colors.dart';

// class HomeTab extends ConsumerWidget {
//   const HomeTab({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final bannerIndex = ref.watch(homeBannerIndexProvider);
//     final pageController = ref.watch(homeBannerPageControllerProvider);
//     final currentUserData = ref.watch(currentUserProvider);

//     // Start auto-scroll by watching it
//     ref.watch(homeBannerAutoScrollProvider);

//     return CustomScrollView(
//       slivers: [
//         _buildAppBar(context, ref, currentUserData),
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildBannerCarousel(ref, pageController, bannerIndex),
//                 const SizedBox(height: 24),
//                 _buildQuickStats(),
//                 const SizedBox(height: 28),
//                 const Text(
//                   'Our Services',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     letterSpacing: 0.3,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 _buildServicesGrid(context),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ================================================================
//   // APP BAR
//   // ================================================================

//   Widget _buildAppBar(
//     BuildContext context,
//     WidgetRef ref,
//     AsyncValue<UserModel?> currentUserData,
//   ) {
//     return SliverAppBar(
//       expandedHeight: 120,
//       floating: false,
//       pinned: true,
//       backgroundColor: Colors.transparent,
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.black.withValues(alpha: 0.85),
//               const Color(0xFF4ECDC4).withValues(alpha: 0.25),
//             ],
//           ),
//           border: Border(
//             bottom: BorderSide(
//               color: Colors.white.withValues(alpha: 0.06),
//               width: 1,
//             ),
//           ),
//         ),
//         child: FlexibleSpaceBar(
//           title: currentUserData.when(
//             data: (userData) {
//               final firstName =
//                   userData?.name?.split(' ').first ??
//                   FirebaseAuth.instance.currentUser?.displayName
//                       ?.split(' ')
//                       .first ??
//                   'there';
//               return Text(
//                 'Hi $firstName! 👋',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               );
//             },
//             loading: () => const Text(
//               'Hi there! 👋',
//               style: TextStyle(fontSize: 20, color: Colors.white),
//             ),
//             error: (_, __) => Text(
//               'Hi ${FirebaseAuth.instance.currentUser?.displayName?.split(' ').first ?? 'there'}! 👋',
//               style: const TextStyle(fontSize: 20, color: Colors.white),
//             ),
//           ),
//           centerTitle: false,
//           titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.notifications_outlined, color: Colors.white),
//           onPressed: () {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: const Text('Notifications — Coming soon'),
//                 backgroundColor: Colors.grey[850],
//                 behavior: SnackBarBehavior.floating,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             );
//           },
//         ),
//         const SizedBox(width: 8),
//       ],
//     );
//   }

//   // ================================================================
//   // BANNER CAROUSEL
//   // ================================================================

//   Widget _buildBannerCarousel(
//     WidgetRef ref,
//     PageController pageController,
//     int currentIndex,
//   ) {
//     final banners = [
//       _BannerData(
//         title: 'Premium Laundry',
//         subtitle: 'Get 20% off on your first order',
//         gradientColors: [const Color(0xFF2C5F7C), const Color(0xFF4ECDC4)],
//         icon: Icons.local_laundry_service_rounded,
//       ),
//       _BannerData(
//         title: 'Express Service',
//         subtitle: 'Same day delivery available',
//         gradientColors: [const Color(0xFF44A08D), const Color(0xFF093637)],
//         icon: Icons.flash_on_rounded,
//       ),
//     ];

//     return Container(
//       height: 175,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF4ECDC4).withValues(alpha: 0.25),
//             blurRadius: 24,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: PageView.builder(
//               controller: pageController,
//               onPageChanged: (index) => updateBannerIndexOnSwipe(ref, index),
//               itemCount: banners.length,
//               itemBuilder: (context, index) => _buildBannerCard(banners[index]),
//             ),
//           ),
//           // Dot indicators
//           Positioned(
//             bottom: 14,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(banners.length, (index) {
//                 final isActive = currentIndex == index;
//                 return AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                   width: isActive ? 22 : 7,
//                   height: 7,
//                   decoration: BoxDecoration(
//                     color: isActive
//                         ? Colors.white
//                         : Colors.white.withValues(alpha: 0.35),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBannerCard(_BannerData data) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: data.gradientColors,
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(22),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     data.title,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     data.subtitle,
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: Colors.white.withValues(alpha: 0.85),
//                       height: 1.4,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               data.icon,
//               size: 80,
//               color: Colors.white.withValues(alpha: 0.2),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================================================================
//   // QUICK STATS
//   // ================================================================

//   Widget _buildQuickStats() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatCard(
//             'Active',
//             '3',
//             Icons.shopping_bag_rounded,
//             Colors.orange,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             'Done',
//             '15',
//             Icons.check_circle_rounded,
//             Colors.green,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             'Saved',
//             '₹250',
//             Icons.savings_rounded,
//             const Color(0xFF4ECDC4),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard(
//     String label,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.06),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.white.withValues(alpha: 0.1),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 26),
//           const SizedBox(height: 7),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           const SizedBox(height: 3),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               color: Colors.white.withValues(alpha: 0.5),
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   // ================================================================
//   // SERVICES GRID
//   // ================================================================

//   Widget _buildServicesGrid(BuildContext context) {
//     final services = [
//       _ServiceItem(
//         'Wash & Fold',
//         Icons.local_laundry_service_rounded,
//         const Color(0xFF4ECDC4),
//         '/home/wash-fold',
//       ),
//       _ServiceItem(
//         'Wash & Iron',
//         Icons.iron_rounded,
//         const Color(0xFF8B5CF6),
//         '/home/wash-iron',
//       ),
//       _ServiceItem(
//         'Dry Clean',
//         Icons.dry_cleaning_rounded,
//         const Color(0xFFF59E0B),
//         '/home/dry-clean',
//       ),
//       _ServiceItem(
//         'Iron Only',
//         Icons.checkroom_rounded,
//         const Color(0xFF10B981),
//         '/home/iron-only',
//       ),
//       _ServiceItem(
//         'Shoe Clean',
//         Icons.cleaning_services_rounded,
//         const Color(0xFFEF4444),
//         '/home/shoe-clean',
//       ),
//       _ServiceItem(
//         'Express',
//         Icons.flash_on_rounded,
//         const Color(0xFF2C5F7C),
//         '/home/express',
//       ),
//     ];

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         mainAxisSpacing: 12,
//         crossAxisSpacing: 12,
//         childAspectRatio: 0.88,
//       ),
//       itemCount: services.length,
//       itemBuilder: (context, index) =>
//           _buildServiceCard(context, services[index]),
//     );
//   }

//   Widget _buildServiceCard(BuildContext context, _ServiceItem service) {
//     return GestureDetector(
//       onTap: () => context.push(service.route),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white.withValues(alpha: 0.06),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: Colors.white.withValues(alpha: 0.1),
//             width: 1,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 52,
//               height: 52,
//               decoration: BoxDecoration(
//                 color: service.color.withValues(alpha: 0.15),
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Icon(service.icon, color: service.color, size: 28),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               service.title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 12,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 height: 1.3,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ================================================================
// // DATA MODELS (private to this file)
// // ================================================================

// class _BannerData {
//   final String title;
//   final String subtitle;
//   final List<Color> gradientColors;
//   final IconData icon;
//   _BannerData({
//     required this.title,
//     required this.subtitle,
//     required this.gradientColors,
//     required this.icon,
//   });
// }

// class _ServiceItem {
//   final String title;
//   final IconData icon;
//   final Color color;
//   final String route;
//   _ServiceItem(this.title, this.icon, this.color, this.route);
// }

// ----------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:go_router/go_router.dart';
// import 'package:whirl_wash/features/auth/data/models/user_model.dart';
// import 'package:whirl_wash/features/home/presentation/providers/config_providers.dart';
// import '../providers/home_screen_providers.dart';
// import '../../../auth/presentation/providers/auth_provider.dart';
// import '../../../../../core/constants/app_colors.dart';

// class HomeTab extends ConsumerWidget {
//   const HomeTab({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final bannerIndex = ref.watch(homeBannerIndexProvider);
//     final pageController = ref.watch(homeBannerPageControllerProvider);
//     final currentUserData = ref.watch(currentUserProvider);

//     // Start auto-scroll by watching it
//     ref.watch(homeBannerAutoScrollProvider);

//     return CustomScrollView(
//       slivers: [
//         _buildAppBar(context, ref, currentUserData),
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildBannerCarousel(ref, pageController, bannerIndex),
//                 const SizedBox(height: 24),
//                 _buildQuickStats(),
//                 const SizedBox(height: 28),
//                 const Text(
//                   'Our Services',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     letterSpacing: 0.3,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 _buildServicesGrid(context, ref),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ================================================================
//   // APP BAR
//   // ================================================================

//   Widget _buildAppBar(
//     BuildContext context,
//     WidgetRef ref,
//     AsyncValue<UserModel?> currentUserData,
//   ) {
//     return SliverAppBar(
//       expandedHeight: 120,
//       floating: false,
//       pinned: true,
//       backgroundColor: Colors.transparent,
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.black.withValues(alpha: 0.85),
//               const Color(0xFF4ECDC4).withValues(alpha: 0.25),
//             ],
//           ),
//           border: Border(
//             bottom: BorderSide(
//               color: Colors.white.withValues(alpha: 0.06),
//               width: 1,
//             ),
//           ),
//         ),
//         child: FlexibleSpaceBar(
//           title: currentUserData.when(
//             data: (userData) {
//               final firstName =
//                   userData?.name?.split(' ').first ??
//                   FirebaseAuth.instance.currentUser?.displayName
//                       ?.split(' ')
//                       .first ??
//                   'there';
//               return Text(
//                 'Hi $firstName! 👋',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               );
//             },
//             loading: () => const Text(
//               'Hi there! 👋',
//               style: TextStyle(fontSize: 20, color: Colors.white),
//             ),
//             error: (_, __) => Text(
//               'Hi ${FirebaseAuth.instance.currentUser?.displayName?.split(' ').first ?? 'there'}! 👋',
//               style: const TextStyle(fontSize: 20, color: Colors.white),
//             ),
//           ),
//           centerTitle: false,
//           titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.notifications_outlined, color: Colors.white),
//           onPressed: () {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: const Text('Notifications — Coming soon'),
//                 backgroundColor: Colors.grey[850],
//                 behavior: SnackBarBehavior.floating,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             );
//           },
//         ),
//         const SizedBox(width: 8),
//       ],
//     );
//   }

//   // ================================================================
//   // BANNER CAROUSEL
//   // ================================================================

//   Widget _buildBannerCarousel(
//     WidgetRef ref,
//     PageController pageController,
//     int currentIndex,
//   ) {
//     final banners = [
//       _BannerData(
//         title: 'Premium Laundry',
//         subtitle: 'Get 20% off on your first order',
//         gradientColors: [const Color(0xFF2C5F7C), const Color(0xFF4ECDC4)],
//         icon: Icons.local_laundry_service_rounded,
//       ),
//       _BannerData(
//         title: 'Express Service',
//         subtitle: 'Same day delivery available',
//         gradientColors: [const Color(0xFF44A08D), const Color(0xFF093637)],
//         icon: Icons.flash_on_rounded,
//       ),
//     ];

//     return Container(
//       height: 175,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF4ECDC4).withValues(alpha: 0.25),
//             blurRadius: 24,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: PageView.builder(
//               controller: pageController,
//               onPageChanged: (index) => updateBannerIndexOnSwipe(ref, index),
//               itemCount: banners.length,
//               itemBuilder: (context, index) => _buildBannerCard(banners[index]),
//             ),
//           ),
//           // Dot indicators
//           Positioned(
//             bottom: 14,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(banners.length, (index) {
//                 final isActive = currentIndex == index;
//                 return AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                   width: isActive ? 22 : 7,
//                   height: 7,
//                   decoration: BoxDecoration(
//                     color: isActive
//                         ? Colors.white
//                         : Colors.white.withValues(alpha: 0.35),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBannerCard(_BannerData data) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: data.gradientColors,
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(22),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     data.title,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     data.subtitle,
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: Colors.white.withValues(alpha: 0.85),
//                       height: 1.4,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               data.icon,
//               size: 80,
//               color: Colors.white.withValues(alpha: 0.2),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================================================================
//   // QUICK STATS
//   // ================================================================

//   Widget _buildQuickStats() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatCard(
//             'Active',
//             '3',
//             Icons.shopping_bag_rounded,
//             Colors.orange,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             'Done',
//             '15',
//             Icons.check_circle_rounded,
//             Colors.green,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             'Saved',
//             '₹250',
//             Icons.savings_rounded,
//             const Color(0xFF4ECDC4),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard(
//     String label,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.06),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.white.withValues(alpha: 0.1),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 26),
//           const SizedBox(height: 7),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           const SizedBox(height: 3),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               color: Colors.white.withValues(alpha: 0.5),
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   // ================================================================
//   // SERVICES GRID
//   // ================================================================

//   // Maps icon string from Firestore to Flutter IconData
//   static const Map<String, IconData> _iconMap = {
//     'local_laundry_service': Icons.local_laundry_service_rounded,
//     'iron': Icons.iron_rounded,
//     'dry_cleaning': Icons.dry_cleaning_rounded,
//     'checkroom': Icons.checkroom_rounded,
//     'cleaning_services': Icons.cleaning_services_rounded,
//     'flash_on': Icons.flash_on_rounded,
//   };

//   // Maps service id to route
//   static const Map<String, String> _routeMap = {
//     'wash_fold': '/home/wash-fold',
//     'wash_iron': '/home/wash-iron',
//     'dry_clean': '/home/dry-clean',
//     'iron_only': '/home/iron-only',
//     'shoe_clean': '/home/shoe-clean',
//     'express': '/home/express',
//   };

//   // Maps service id to accent color
//   static const Map<String, Color> _colorMap = {
//     'wash_fold': const Color(0xFF4ECDC4),
//     'wash_iron': const Color(0xFF8B5CF6),
//     'dry_clean': const Color(0xFFF59E0B),
//     'iron_only': const Color(0xFF10B981),
//     'shoe_clean': const Color(0xFFEF4444),
//     'express': const Color(0xFF2C5F7C),
//   };

//   Widget _buildServicesGrid(BuildContext context, WidgetRef ref) {
//     final servicesAsync = ref.watch(servicesConfigProvider);

//     return servicesAsync.when(
//       loading: () => GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           mainAxisSpacing: 12,
//           crossAxisSpacing: 12,
//           childAspectRatio: 0.88,
//         ),
//         itemCount: 6,
//         itemBuilder: (_, __) => Container(
//           decoration: BoxDecoration(
//             color: Colors.white.withValues(alpha: 0.04),
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//       ),
//       error: (_, __) => const SizedBox.shrink(),
//       data: (services) => GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           mainAxisSpacing: 12,
//           crossAxisSpacing: 12,
//           childAspectRatio: 0.88,
//         ),
//         itemCount: services.length,
//         itemBuilder: (context, index) {
//           final service = services[index];
//           final icon =
//               _iconMap[service.icon] ?? Icons.local_laundry_service_rounded;
//           final route = _routeMap[service.id] ?? '/home';
//           final color = _colorMap[service.id] ?? AppColors.secondary;
//           return GestureDetector(
//             onTap: () => context.push(route),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white.withValues(alpha: 0.06),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: Colors.white.withValues(alpha: 0.1),
//                   width: 1,
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 52,
//                     height: 52,
//                     decoration: BoxDecoration(
//                       color: color.withValues(alpha: 0.15),
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: Icon(icon, color: color, size: 28),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     service.name,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       height: 1.3,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // ================================================================
// // DATA MODELS (private to this file)
// // ================================================================

// class _BannerData {
//   final String title;
//   final String subtitle;
//   final List<Color> gradientColors;
//   final IconData icon;
//   _BannerData({
//     required this.title,
//     required this.subtitle,
//     required this.gradientColors,
//     required this.icon,
//   });
// }

// ---------------------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:whirl_wash/features/auth/data/models/user_model.dart';
import 'package:whirl_wash/features/home/presentation/providers/config_providers.dart';
import '../providers/home_screen_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../../core/constants/app_colors.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerIndex = ref.watch(homeBannerIndexProvider);
    final pageController = ref.watch(homeBannerPageControllerProvider);
    final currentUserData = ref.watch(currentUserProvider);

    // Start auto-scroll by watching it
    ref.watch(homeBannerAutoScrollProvider);

    return CustomScrollView(
      slivers: [
        _buildAppBar(context, ref, currentUserData),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBannerCarousel(ref, pageController, bannerIndex),
                const SizedBox(height: 24),
                _buildQuickStats(),
                const SizedBox(height: 28),
                const Text(
                  'Our Services',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 16),
                _buildServicesGrid(context, ref),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // APP BAR
  // ================================================================

  Widget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<UserModel?> currentUserData,
  ) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withValues(alpha: 0.85),
              const Color(0xFF4ECDC4).withValues(alpha: 0.25),
            ],
          ),
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withValues(alpha: 0.06),
              width: 1,
            ),
          ),
        ),
        child: FlexibleSpaceBar(
          title: currentUserData.when(
            data: (userData) {
              final firstName =
                  userData?.name?.split(' ').first ??
                  FirebaseAuth.instance.currentUser?.displayName
                      ?.split(' ')
                      .first ??
                  'there';
              return Text(
                'Hi $firstName! 👋',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
            loading: () => const Text(
              'Hi there! 👋',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            error: (_, __) => Text(
              'Hi ${FirebaseAuth.instance.currentUser?.displayName?.split(' ').first ?? 'there'}! 👋',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          centerTitle: false,
          titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Notifications — Coming soon'),
                backgroundColor: Colors.grey[850],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ================================================================
  // BANNER CAROUSEL
  // ================================================================

  Widget _buildBannerCarousel(
    WidgetRef ref,
    PageController pageController,
    int currentIndex,
  ) {
    final banners = [
      _BannerData(
        title: 'Premium Laundry',
        subtitle: 'Get 20% off on your first order',
        gradientColors: [const Color(0xFF2C5F7C), const Color(0xFF4ECDC4)],
        icon: Icons.local_laundry_service_rounded,
      ),
      _BannerData(
        title: 'Express Service',
        subtitle: 'Same day delivery available',
        gradientColors: [const Color(0xFF44A08D), const Color(0xFF093637)],
        icon: Icons.flash_on_rounded,
      ),
    ];

    return Container(
      height: 175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ECDC4).withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (index) => updateBannerIndexOnSwipe(ref, index),
              itemCount: banners.length,
              itemBuilder: (context, index) => _buildBannerCard(banners[index]),
            ),
          ),
          // Dot indicators
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(banners.length, (index) {
                final isActive = currentIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 22 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard(_BannerData data) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: data.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              data.icon,
              size: 80,
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // QUICK STATS
  // ================================================================

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Active',
            '3',
            Icons.shopping_bag_rounded,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Done',
            '15',
            Icons.check_circle_rounded,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Saved',
            '₹250',
            Icons.savings_rounded,
            const Color(0xFF4ECDC4),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 7),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SERVICES GRID
  // ================================================================

  // Maps icon string from Firestore to Flutter IconData
  static const Map<String, IconData> _iconMap = {
    'local_laundry_service': Icons.local_laundry_service_rounded,
    'iron': Icons.iron_rounded,
    'dry_cleaning': Icons.dry_cleaning_rounded,
    'checkroom': Icons.checkroom_rounded,
    'cleaning_services': Icons.cleaning_services_rounded,
    'flash_on': Icons.flash_on_rounded,
  };

  // Maps service id to route
  static const Map<String, String> _routeMap = {
    'wash_fold': '/home/wash-fold',
    'wash_iron': '/home/wash-iron',
    'dry_clean': '/home/dry-clean',
    'iron_only': '/home/iron-only',
    'shoe_clean': '/home/shoe-clean',
    'express': '/home/express',
  };

  // Maps service id to accent color
  static const Map<String, Color> _colorMap = {
    'wash_fold': const Color(0xFF4ECDC4),
    'wash_iron': const Color(0xFF8B5CF6),
    'dry_clean': const Color(0xFFF59E0B),
    'iron_only': const Color(0xFF10B981),
    'shoe_clean': const Color(0xFFEF4444),
    'express': const Color(0xFF2C5F7C),
  };

  Widget _buildServicesGrid(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesConfigProvider);

    return servicesAsync.when(
      loading: () => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.88,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (services) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.88,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          final icon =
              _iconMap[service.icon] ?? Icons.local_laundry_service_rounded;
          final route = _routeMap[service.id] ?? '/home';
          final color = _colorMap[service.id] ?? AppColors.secondary;
          final isEnabled = service.enabled;
          return Opacity(
            opacity: isEnabled ? 1.0 : 0.4,
            child: GestureDetector(
              onTap: isEnabled ? () => context.push(route) : null,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: isEnabled ? 0.15 : 0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        icon,
                        color: color.withValues(alpha: isEnabled ? 1.0 : 0.5),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      service.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    if (!isEnabled) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Unavailable',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.white.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ================================================================
// DATA MODELS (private to this file)
// ================================================================

class _BannerData {
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final IconData icon;
  _BannerData({
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.icon,
  });
}
