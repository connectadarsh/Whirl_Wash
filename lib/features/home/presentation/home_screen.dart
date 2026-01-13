// import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:whirl_wash/features/auth/presentation/providers/auth_provider.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen>
//     with TickerProviderStateMixin {
//   int _currentIndex = 0;
//   int _currentBannerIndex = 0;
//   late PageController _pageController;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(viewportFraction: 0.9);

//     // Animation for fade-in effect
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );

//     _animationController.forward();

//     Future.delayed(const Duration(seconds: 2), () {
//       _autoPlayBanner();
//     });
//   }

//   void _autoPlayBanner() {
//     if (mounted) {
//       Future.delayed(const Duration(seconds: 5), () {
//         if (mounted && _pageController.hasClients) {
//           int nextPage = (_currentBannerIndex + 1) % 2;
//           _pageController.animateToPage(
//             nextPage,
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//           );
//           _autoPlayBanner();
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   // Icons for bottom navigation
//   final List<IconData> _navIcons = [
//     Icons.home,
//     Icons.receipt_long,
//     Icons.shopping_cart,
//     Icons.person,
//   ];

//   final List<String> _navLabels = ['Home', 'Orders', 'Cart', 'Profile'];

//   final List<ServiceItem> _services = [
//     ServiceItem(
//       title: 'Wash',
//       subtitle: 'From ₹50',
//       icon: Icons.local_laundry_service,
//       color: const Color(0xFF2C5F7C),
//       gradient: const LinearGradient(
//         colors: [Color(0xFF2C5F7C), Color(0xFF4ECDC4)],
//       ),
//     ),
//     ServiceItem(
//       title: 'Iron',
//       subtitle: 'From ₹30',
//       icon: Icons.iron,
//       color: const Color(0xFFFF6B6B),
//       gradient: const LinearGradient(
//         colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
//       ),
//     ),
//     ServiceItem(
//       title: 'Dry Cleaning',
//       subtitle: 'From ₹80',
//       icon: Icons.dry_cleaning,
//       color: const Color(0xFF4ECDC4),
//       gradient: const LinearGradient(
//         colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
//       ),
//     ),
//     ServiceItem(
//       title: 'Bulky Items',
//       subtitle: 'From ₹100',
//       icon: Icons.weekend,
//       color: const Color(0xFF9B59B6),
//       gradient: const LinearGradient(
//         colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
//       ),
//     ),
//     ServiceItem(
//       title: 'Duvets',
//       subtitle: 'From ₹150',
//       icon: Icons.bed,
//       color: const Color(0xFFF39C12),
//       gradient: const LinearGradient(
//         colors: [Color(0xFFF39C12), Color(0xFFE67E22)],
//       ),
//     ),
//     ServiceItem(
//       title: 'Shoes & Others',
//       subtitle: 'From ₹60',
//       icon: Icons.checkroom,
//       color: const Color(0xFF3498DB),
//       gradient: const LinearGradient(
//         colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
//       ),
//     ),
//   ];

//   void _handleLogout() async {
//     // Show confirmation dialog
//     final shouldLogout = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF1F2937),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text(
//           'Logout',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         content: const Text(
//           'Are you sure you want to logout?',
//           style: TextStyle(color: Colors.white70),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text(
//               'Cancel',
//               style: TextStyle(color: Colors.white70),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF4ECDC4),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: const Text('Logout', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );

//     if (shouldLogout == true) {
//       await ref.read(authControllerProvider.notifier).signOut();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     final currentUserData = ref.watch(currentUserProvider);

//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       backgroundColor: Colors.transparent,
//       // Enhanced AppBar with glass effect (darker theme)
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(55),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.6),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.15),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: AppBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             centerTitle: true,
//             leading: Padding(
//               padding: const EdgeInsets.all(10),
//               child: GestureDetector(
//                 onTap: () {
//                   // TODO: Open drawer/menu
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.12),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(Icons.menu, color: Colors.white, size: 20),
//                 ),
//               ),
//             ),
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: GestureDetector(
//                   onTap: () {
//                     // TODO: Open notifications
//                   },
//                   child: Stack(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.12),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Icon(
//                           Icons.notifications_outlined,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                       // Notification badge
//                       Positioned(
//                         right: 6,
//                         top: 6,
//                         child: Container(
//                           width: 8,
//                           height: 8,
//                           decoration: const BoxDecoration(
//                             color: Color(0xFF4ECDC4),
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//             ],
//           ),
//         ),
//       ),

//       body: Stack(
//         children: [
//           // Background Image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/home_background.png',
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [Color(0xFF2C5F7C), Color(0xFF4ECDC4)],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // Dark overlay (matching login page style - darker)
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.black.withOpacity(0.78),
//                     Colors.black.withOpacity(0.82),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // Content
//           FadeTransition(
//             opacity: _fadeAnimation,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 120),

//                   // Welcome Section - with user's name
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Greeting with waving hand
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 gradient: const LinearGradient(
//                                   colors: [
//                                     Color(0xFF4ECDC4),
//                                     Color(0xFF44A08D),
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(10),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: const Color(
//                                       0xFF4ECDC4,
//                                     ).withOpacity(0.3),
//                                     blurRadius: 8,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: const Icon(
//                                 Icons.waving_hand,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: currentUserData.when(
//                                 data: (userData) => Text(
//                                   'Hi ${userData?.name?.split(' ').first ?? user?.displayName?.split(' ').first ?? 'there'}!',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white.withOpacity(0.7),
//                                     letterSpacing: 0.3,
//                                   ),
//                                 ),
//                                 loading: () => Text(
//                                   'Hi there!',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white.withOpacity(0.7),
//                                     letterSpacing: 0.3,
//                                   ),
//                                 ),
//                                 error: (_, __) => Text(
//                                   'Hi ${user?.displayName?.split(' ').first ?? 'there'}!',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white.withOpacity(0.7),
//                                     letterSpacing: 0.3,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         // Main heading with gradient effect
//                         ShaderMask(
//                           shaderCallback: (bounds) => const LinearGradient(
//                             colors: [
//                               Color(0xFF4ECDC4),
//                               Color(0xFF6DD5CD),
//                               Colors.white,
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ).createShader(bounds),
//                           child: const Text(
//                             'Ready for fresh laundry?',
//                             style: TextStyle(
//                               fontSize: 26,
//                               fontWeight: FontWeight.w900,
//                               color: Colors.white,
//                               letterSpacing: 0.5,
//                               height: 1.2,
//                               shadows: [
//                                 Shadow(
//                                   color: Colors.black26,
//                                   offset: Offset(0, 2),
//                                   blurRadius: 8,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   // Banner Carousel
//                   SizedBox(
//                     height: 145,
//                     child: PageView(
//                       controller: _pageController,
//                       onPageChanged: (index) {
//                         setState(() {
//                           _currentBannerIndex = index;
//                         });
//                       },
//                       children: [_buildBanner1(), _buildBanner2()],
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   // Carousel indicators with animation
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [0, 1].map((index) {
//                       return AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         width: _currentBannerIndex == index ? 20 : 6,
//                         height: 6,
//                         margin: const EdgeInsets.symmetric(horizontal: 3),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(3),
//                           color: _currentBannerIndex == index
//                               ? const Color(0xFF4ECDC4)
//                               : Colors.white.withOpacity(0.3),
//                         ),
//                       );
//                     }).toList(),
//                   ),

//                   const SizedBox(height: 18),

//                   // Quick Stats Cards
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildStatCard(
//                             icon: Icons.local_laundry_service,
//                             title: 'Active',
//                             value: '3',
//                             color: const Color(0xFF4ECDC4),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: _buildStatCard(
//                             icon: Icons.check_circle_outline,
//                             title: 'Completed',
//                             value: '24',
//                             color: const Color(0xFF4ECDC4),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: _buildStatCard(
//                             icon: Icons.star_outline,
//                             title: 'Points',
//                             value: '450',
//                             color: const Color(0xFFFFB84D),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // Services Section Header
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Our Services',
//                           style: TextStyle(
//                             fontSize: 19,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white.withOpacity(0.95),
//                             letterSpacing: 0.3,
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {},
//                           style: TextButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                             minimumSize: const Size(50, 30),
//                             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                           ),
//                           child: const Text(
//                             'View All',
//                             style: TextStyle(
//                               color: Color(0xFF4ECDC4),
//                               fontWeight: FontWeight.w600,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 6),

//                   // Enhanced Services Grid
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             crossAxisSpacing: 12,
//                             mainAxisSpacing: 12,
//                             childAspectRatio: 1.05,
//                           ),
//                       itemCount: _services.length,
//                       itemBuilder: (context, index) {
//                         return GestureDetector(
//                           onTap: () {
//                             // TODO: Navigate to service screen
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                   '${_services[index].title} service - Coming soon!',
//                                 ),
//                                 backgroundColor: const Color(0xFF4ECDC4),
//                                 behavior: SnackBarBehavior.floating,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                             );
//                           },
//                           child: EnhancedServiceCard(
//                             service: _services[index],
//                             delay: Duration(milliseconds: 100 * index),
//                           ),
//                         );
//                       },
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // Logout Button (only visible in Profile tab)
//                   if (_currentIndex == 3)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: SizedBox(
//                         width: double.infinity,
//                         height: 56,
//                         child: OutlinedButton.icon(
//                           onPressed: _handleLogout,
//                           icon: const Icon(Icons.logout),
//                           label: const Text(
//                             'Logout',
//                             style: TextStyle(
//                               fontSize: 17,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: const Color(0xFF4ECDC4),
//                             side: const BorderSide(
//                               color: Color(0xFF4ECDC4),
//                               width: 2,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                   // Extra bottom padding
//                   const SizedBox(height: 90),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),

//       // Animated Bottom Navigation Bar
//       bottomNavigationBar: AnimatedBottomNavigationBar.builder(
//         itemCount: _navIcons.length,
//         tabBuilder: (int index, bool isActive) {
//           final color = isActive
//               ? const Color(0xFF4ECDC4)
//               : Colors.white.withOpacity(0.4);

//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(_navIcons[index], size: 26, color: color),
//               const SizedBox(height: 4),
//               Text(
//                 _navLabels[index],
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 12,
//                   fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
//                 ),
//               ),
//             ],
//           );
//         },
//         backgroundColor: Colors.black.withOpacity(0.75),
//         activeIndex: _currentIndex,
//         splashColor: const Color(0xFF4ECDC4),
//         splashSpeedInMilliseconds: 300,
//         notchSmoothness: NotchSmoothness.smoothEdge,
//         gapLocation: GapLocation.none,
//         leftCornerRadius: 20,
//         rightCornerRadius: 20,
//         onTap: (index) => setState(() => _currentIndex = index),
//         shadow: BoxShadow(
//           offset: const Offset(0, -3),
//           blurRadius: 15,
//           color: Colors.black.withOpacity(0.3),
//         ),
//       ),
//     );
//   }

//   // Stat Card Widget (dark theme)
//   Widget _buildStatCard({
//     required IconData icon,
//     required String title,
//     required String value,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3), width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 19,
//               fontWeight: FontWeight.bold,
//               color: Colors.white.withOpacity(0.95),
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 11,
//               color: Colors.white.withOpacity(0.6),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Banner 1 - Enhanced
//   Widget _buildBanner1() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF4ECDC4), Color(0xFF6DD5CD)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF4ECDC4).withOpacity(0.3),
//             blurRadius: 15,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           // Animated decorative circles
//           Positioned(
//             right: -25,
//             top: -25,
//             child: Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.12),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           Positioned(
//             right: 35,
//             bottom: -30,
//             child: Container(
//               width: 70,
//               height: 70,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.08),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 // Icon with glow effect
//                 Container(
//                   width: 55,
//                   height: 55,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.white.withOpacity(0.25),
//                         blurRadius: 12,
//                         spreadRadius: 1,
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.local_shipping,
//                     size: 32,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(width: 14),

//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'FREE DELIVERY',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 19,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: 0.3,
//                           shadows: [
//                             Shadow(
//                               color: Colors.black26,
//                               offset: Offset(0, 2),
//                               blurRadius: 4,
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'On orders above ₹500',
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.95),
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Banner 2 - Enhanced
//   Widget _buildBanner2() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF6B9FE8), Color(0xFF8BB5F0)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF6B9FE8).withOpacity(0.3),
//             blurRadius: 15,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             right: -25,
//             top: -25,
//             child: Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.12),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           Positioned(
//             right: 35,
//             bottom: -30,
//             child: Container(
//               width: 70,
//               height: 70,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.08),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 55,
//                   height: 55,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.white.withOpacity(0.25),
//                         blurRadius: 12,
//                         spreadRadius: 1,
//                       ),
//                     ],
//                   ),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       const Icon(
//                         Icons.local_offer,
//                         size: 30,
//                         color: Colors.white,
//                       ),
//                       Positioned(
//                         top: 8,
//                         right: 8,
//                         child: Container(
//                           padding: const EdgeInsets.all(3),
//                           decoration: BoxDecoration(
//                             color: Colors.orange,
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.orange.withOpacity(0.5),
//                                 blurRadius: 5,
//                                 spreadRadius: 1,
//                               ),
//                             ],
//                           ),
//                           child: const Text(
//                             '20%',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 7,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 14),

//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'GET 20% OFF',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 19,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: 0.3,
//                           shadows: [
//                             Shadow(
//                               color: Colors.black26,
//                               offset: Offset(0, 2),
//                               blurRadius: 4,
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'On your first 3 orders',
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.95),
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.3),
//                             width: 1,
//                           ),
//                         ),
//                         child: const Text(
//                           'Code: FIRST20',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Enhanced Service Card with Animation (dark theme)
// class EnhancedServiceCard extends StatefulWidget {
//   final ServiceItem service;
//   final Duration delay;

//   const EnhancedServiceCard({
//     super.key,
//     required this.service,
//     this.delay = Duration.zero,
//   });

//   @override
//   State<EnhancedServiceCard> createState() => _EnhancedServiceCardState();
// }

// class _EnhancedServiceCardState extends State<EnhancedServiceCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _scaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

//     Future.delayed(widget.delay, () {
//       if (mounted) _controller.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: ScaleTransition(
//         scale: _scaleAnimation,
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: () {},
//             borderRadius: BorderRadius.circular(16),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: widget.service.color.withOpacity(0.3),
//                   width: 1,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: widget.service.color.withOpacity(0.15),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Gradient icon container
//                   Container(
//                     width: 58,
//                     height: 58,
//                     decoration: BoxDecoration(
//                       gradient: widget.service.gradient,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: widget.service.color.withOpacity(0.3),
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       widget.service.icon,
//                       size: 28,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     widget.service.title,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white.withOpacity(0.95),
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                   const SizedBox(height: 3),
//                   Text(
//                     widget.service.subtitle,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.white.withOpacity(0.6),
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ServiceItem {
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final Color color;
//   final LinearGradient gradient;

//   ServiceItem({
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.color,
//     required this.gradient,
//   });
// }

// ---------------------------------------------------------------------------------------------

// =====================================================================
// HOME SCREEN - Converted to Riverpod (No StatefulWidget)
// File: lib/features/home/presentation/home_screen.dart
// =====================================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whirl_wash/features/auth/data/models/user_model.dart';
import 'package:go_router/go_router.dart';
import 'providers/home_screen_providers.dart';
import '../../auth/presentation/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch navigation index
    final currentIndex = ref.watch(homeBottomNavIndexProvider);

    // Watch banner state
    final bannerIndex = ref.watch(homeBannerIndexProvider);
    final pageController = ref.watch(homeBannerPageControllerProvider);

    // Start auto-scroll timer (just by watching it)
    ref.watch(homeBannerAutoScrollProvider);

    // Get user data
    final currentUserData = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildBody(
        context,
        ref,
        currentUserData,
        pageController,
        bannerIndex,
      ),
      bottomNavigationBar: _buildBottomNav(ref, currentIndex),
    );
  }

  // ================================================================
  // MAIN BODY
  // ================================================================

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<UserModel?> currentUserData,
    PageController pageController,
    int bannerIndex,
  ) {
    return CustomScrollView(
      slivers: [
        // App Bar with glass effect + Logout button
        _buildAppBar(context, ref, currentUserData),

        // Main content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner carousel
                _buildBannerCarousel(ref, pageController, bannerIndex),

                const SizedBox(height: 24),

                // Quick stats cards
                _buildQuickStats(),

                const SizedBox(height: 24),

                // Services section header
                const Text(
                  'Our Services',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                // Services grid
                _buildServicesGrid(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // APP BAR WITH LOGOUT BUTTON
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
              Colors.black.withOpacity(0.8),
              const Color(0xFF4ECDC4).withOpacity(0.3),
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: FlexibleSpaceBar(
          title: currentUserData.when(
            data: (userData) {
              // Try to get first name from Firestore, then Firebase Auth, then default
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
            error: (_, __) {
              final firstName =
                  FirebaseAuth.instance.currentUser?.displayName
                      ?.split(' ')
                      .first ??
                  'there';
              return Text(
                'Hi $firstName! 👋',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              );
            },
          ),
          centerTitle: false,
          titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        ),
      ),
      actions: [
        // Notifications button
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            // TODO: Implement notifications
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Notifications - Coming soon'),
                backgroundColor: Colors.grey[800],
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),

        // Logout button
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          tooltip: 'Logout',
          onPressed: () => _showLogoutDialog(context, ref),
        ),

        const SizedBox(width: 8),
      ],
    );
  }

  // ================================================================
  // LOGOUT DIALOG
  // ================================================================

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Logout',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
          ),

          // Logout button
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4ECDC4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    // If user confirmed logout
    if (shouldLogout == true && context.mounted) {
      await _handleLogout(context, ref);
    }
  }

  // ================================================================
  // LOGOUT HANDLER
  // ================================================================

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('Logging out...'),
            ],
          ),
          backgroundColor: Colors.grey[800],
          duration: const Duration(seconds: 2),
        ),
      );

      // Call signOut from auth provider
      await ref.read(authControllerProvider.notifier).signOut();

      // Navigate to login screen
      if (context.mounted) {
        context.go('/login');
      }
    } catch (e) {
      // Show error if logout fails
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ================================================================
  // BANNER CAROUSEL
  // ================================================================

  Widget _buildBannerCarousel(
    WidgetRef ref,
    PageController pageController,
    int currentIndex,
  ) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ECDC4).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // PageView with banners
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              // Update index when user swipes manually
              updateBannerIndexOnSwipe(ref, index);
            },
            children: [
              _buildBannerCard(
                'Premium Laundry',
                'Get 20% off on first order',
                Colors.blue,
                Icons.local_laundry_service,
              ),
              _buildBannerCard(
                'Express Service',
                'Same day delivery available',
                Colors.purple,
                Icons.flash_on,
              ),
            ],
          ),

          // Dot indicators
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                final isActive = currentIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
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

  Widget _buildBannerCard(
    String title,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Icon(icon, size: 80, color: Colors.white.withOpacity(0.3)),
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
            'Active Orders',
            '3',
            Icons.shopping_bag,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Completed',
            '15',
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Saved',
            '₹250',
            Icons.savings,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SERVICES GRID
  // ================================================================

  Widget _buildServicesGrid(BuildContext context) {
    final services = [
      _ServiceItem('Wash & Fold', Icons.local_laundry_service, Colors.blue),
      _ServiceItem('Wash & Iron', Icons.iron, Colors.purple),
      _ServiceItem('Dry Clean', Icons.dry_cleaning, Colors.orange),
      _ServiceItem('Iron Only', Icons.checkroom, Colors.green),
      _ServiceItem('Shoe Clean', Icons.cleaning_services, Colors.red),
      _ServiceItem('Express', Icons.flash_on, const Color(0xFF4ECDC4)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(context, service);
      },
    );
  }

  Widget _buildServiceCard(BuildContext context, _ServiceItem service) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${service.title} - Coming soon'),
            backgroundColor: Colors.grey[800],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(service.icon, color: service.color, size: 40),
            const SizedBox(height: 8),
            Text(
              service.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // BOTTOM NAVIGATION
  // ================================================================

  Widget _buildBottomNav(WidgetRef ref, int currentIndex) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // Update navigation index using Riverpod
          navigateToTab(ref, index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xFF4ECDC4),
        unselectedItemColor: Colors.grey,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ================================================================
// SERVICE ITEM MODEL
// ================================================================

class _ServiceItem {
  final String title;
  final IconData icon;
  final Color color;

  _ServiceItem(this.title, this.icon, this.color);
}
