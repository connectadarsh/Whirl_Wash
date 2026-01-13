// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../providers/auth_provider.dart';
// import 'signup_screen.dart';
// import 'phone_auth_screen.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen>
//     with TickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   bool _obscurePassword = true;

//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
//       ),
//     );

//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
//           CurvedAnimation(
//             parent: _animationController,
//             curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
//           ),
//         );

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your email';
//     }
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(value)) {
//       return 'Please enter a valid email';
//     }
//     return null;
//   }

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter a password';
//     }
//     if (value.length < 6) {
//       return 'Password must be at least 6 characters';
//     }
//     return null;
//   }

//   Future<void> _handleSignIn() async {
//     if (_formKey.currentState!.validate()) {
//       ref
//           .read(authControllerProvider.notifier)
//           .signInWithEmail(
//             email: _emailController.text.trim(),
//             password: _passwordController.text,
//           );
//     }
//   }

//   void _handleGoogleSignIn() {
//     ref.read(authControllerProvider.notifier).signInWithGoogle();
//   }

//   // void _navigateToPhoneAuth() {
//   //   Navigator.push(
//   //     context,
//   //     MaterialPageRoute(builder: (context) => const PhoneAuthScreen()),
//   //   );
//   // }

//   void _navigateToPhoneAuth() {
//     context.push('/phone-auth'); // ← Simple!
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authControllerProvider);

//     // Listen for errors
//     ref.listen(authControllerProvider, (previous, next) {
//       if (next.error != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(next.error!),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//         ref.read(authControllerProvider.notifier).clearError();
//       }

//       if (next.successMessage != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(next.successMessage!),
//             backgroundColor: const Color(0xFF4ECDC4),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//         ref.read(authControllerProvider.notifier).clearSuccess();
//       }
//     });

//     return Scaffold(
//       backgroundColor: Colors.black,
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       body: Stack(
//         children: [
//           // Background Image - Full Screen
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/bg_signin.png',
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

//           // Dark Overlay
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.black.withValues(alpha: 0.72),
//                     Colors.black.withValues(alpha: 0.82),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // Content - FIXED: Now fills entire screen
//           SafeArea(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 return SingleChildScrollView(
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       minHeight: constraints.maxHeight,
//                     ),
//                     child: IntrinsicHeight(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 24,
//                           vertical: 24,
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             // Title
//                             FadeTransition(
//                               opacity: _fadeAnimation,
//                               child: Column(
//                                 children: [
//                                   const Text(
//                                     'Welcome Back!',
//                                     style: TextStyle(
//                                       fontSize: 28,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     'Sign in to continue',
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       color: Colors.white.withValues(
//                                         alpha: 0.9,
//                                       ),
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             const SizedBox(height: 50),

//                             // Form
//                             SlideTransition(
//                               position: _slideAnimation,
//                               child: FadeTransition(
//                                 opacity: _fadeAnimation,
//                                 child: Form(
//                                   key: _formKey,
//                                   child: Column(
//                                     children: [
//                                       // Email field
//                                       _buildInputField(
//                                         controller: _emailController,
//                                         label: 'Email Address',
//                                         hint: 'Enter your email',
//                                         icon: Icons.email_outlined,
//                                         keyboardType:
//                                             TextInputType.emailAddress,
//                                         validator: _validateEmail,
//                                       ),

//                                       const SizedBox(height: 18),

//                                       // Password field
//                                       _buildInputField(
//                                         controller: _passwordController,
//                                         label: 'Password',
//                                         hint: 'Enter your password',
//                                         icon: Icons.lock_outline,
//                                         obscureText: _obscurePassword,
//                                         validator: _validatePassword,
//                                         suffixIcon: IconButton(
//                                           icon: Icon(
//                                             _obscurePassword
//                                                 ? Icons.visibility_off_outlined
//                                                 : Icons.visibility_outlined,
//                                             color: Colors.white70,
//                                             size: 22,
//                                           ),
//                                           onPressed: () {
//                                             setState(() {
//                                               _obscurePassword =
//                                                   !_obscurePassword;
//                                             });
//                                           },
//                                         ),
//                                       ),

//                                       const SizedBox(height: 12),

//                                       // Forgot Password
//                                       Align(
//                                         alignment: Alignment.centerRight,
//                                         child: TextButton(
//                                           onPressed: () {
//                                             // TODO: Implement forgot password
//                                           },
//                                           child: Text(
//                                             'Forgot Password?',
//                                             style: TextStyle(
//                                               color: Colors.white.withValues(
//                                                 alpha: 0.9,
//                                               ),
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ),
//                                       ),

//                                       const SizedBox(height: 20),

//                                       // Sign In Button
//                                       SizedBox(
//                                         width: double.infinity,
//                                         height: 56,
//                                         child: ElevatedButton(
//                                           onPressed: authState.isLoading
//                                               ? null
//                                               : _handleSignIn,
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Colors.transparent,
//                                             shadowColor: Colors.transparent,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(16),
//                                             ),
//                                             padding: EdgeInsets.zero,
//                                           ),
//                                           child: Ink(
//                                             decoration: BoxDecoration(
//                                               gradient: const LinearGradient(
//                                                 colors: [
//                                                   Color(0xFF2C5F7C),
//                                                   Color(0xFF4ECDC4),
//                                                 ],
//                                               ),
//                                               borderRadius:
//                                                   BorderRadius.circular(16),
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: const Color(
//                                                     0xFF2C5F7C,
//                                                   ).withValues(alpha: 0.4),
//                                                   blurRadius: 20,
//                                                   offset: const Offset(0, 8),
//                                                 ),
//                                               ],
//                                             ),
//                                             child: Container(
//                                               alignment: Alignment.center,
//                                               child: authState.isLoading
//                                                   ? const SizedBox(
//                                                       width: 24,
//                                                       height: 24,
//                                                       child: CircularProgressIndicator(
//                                                         valueColor:
//                                                             AlwaysStoppedAnimation<
//                                                               Color
//                                                             >(Colors.white),
//                                                         strokeWidth: 2.5,
//                                                       ),
//                                                     )
//                                                   : const Text(
//                                                       'Sign In',
//                                                       style: TextStyle(
//                                                         fontSize: 17,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Colors.white,
//                                                         letterSpacing: 0.5,
//                                                       ),
//                                                     ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),

//                                       const SizedBox(height: 32),

//                                       // Sign up link
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             "Don't have an account? ",
//                                             style: TextStyle(
//                                               color: Colors.white.withValues(
//                                                 alpha: 0.8,
//                                               ),
//                                               fontSize: 14,
//                                             ),
//                                           ),

//                                           // GestureDetector(
//                                           //   onTap: () {
//                                           //     Navigator.pushReplacement(
//                                           //       context,
//                                           //       MaterialPageRoute(
//                                           //         builder: (context) =>
//                                           //             const SignupScreen(),
//                                           //       ),
//                                           //     );
//                                           //   },
//                                           //   child: const Text(
//                                           //     'Sign Up',
//                                           //     style: TextStyle(
//                                           //       color: Color(0xFF4ECDC4),
//                                           //       fontSize: 14,
//                                           //       fontWeight: FontWeight.bold,
//                                           //     ),
//                                           //   ),
//                                           // ),
//                                           GestureDetector(
//                                             onTap: () => context.go(
//                                               '/signup',
//                                             ), // ← Simple!
//                                             child: const Text('Sign Up'),
//                                           ),
//                                         ],
//                                       ),

//                                       const SizedBox(height: 32),

//                                       // Divider
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: Divider(
//                                               color: Colors.white.withValues(
//                                                 alpha: 0.3,
//                                               ),
//                                               thickness: 1,
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 16,
//                                             ),
//                                             child: Text(
//                                               'OR CONTINUE WITH',
//                                               style: TextStyle(
//                                                 color: Colors.white.withValues(
//                                                   alpha: 0.7,
//                                                 ),
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 12,
//                                                 letterSpacing: 0.5,
//                                               ),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Divider(
//                                               color: Colors.white.withValues(
//                                                 alpha: 0.3,
//                                               ),
//                                               thickness: 1,
//                                             ),
//                                           ),
//                                         ],
//                                       ),

//                                       const SizedBox(height: 28),

//                                       // Social login buttons
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           _buildIconOnlyButton(
//                                             icon: Icons.phone_android,
//                                             onPressed: _navigateToPhoneAuth,
//                                           ),
//                                           const SizedBox(width: 20),
//                                           _buildIconOnlyButton(
//                                             icon: Icons.g_mobiledata,
//                                             onPressed: _handleGoogleSignIn,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     TextInputType? keyboardType,
//     bool obscureText = false,
//     String? Function(String?)? validator,
//     Widget? suffixIcon,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Colors.white.withValues(alpha: 0.9),
//             letterSpacing: 0.3,
//           ),
//         ),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white.withValues(alpha: 0.15),
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(
//               color: Colors.white.withValues(alpha: 0.2),
//               width: 1,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: TextFormField(
//             controller: controller,
//             keyboardType: keyboardType,
//             obscureText: obscureText,
//             validator: validator,
//             style: const TextStyle(
//               fontSize: 15,
//               color: Colors.white,
//               fontWeight: FontWeight.w500,
//             ),
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: TextStyle(
//                 color: Colors.white.withValues(alpha: 0.5),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//               ),
//               prefixIcon: Icon(
//                 icon,
//                 color: Colors.white.withValues(alpha: 0.8),
//                 size: 22,
//               ),
//               suffixIcon: suffixIcon,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide.none,
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide.none,
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: Colors.white.withValues(alpha: 0.4),
//                   width: 2,
//                 ),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(color: Colors.red[300]!, width: 1.5),
//               ),
//               focusedErrorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(color: Colors.red, width: 2),
//               ),
//               filled: false,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//               errorStyle: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildIconOnlyButton({
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return Container(
//       width: 64,
//       height: 64,
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.15),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.white.withValues(alpha: 0.2),
//           width: 1.5,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.15),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onPressed,
//           borderRadius: BorderRadius.circular(16),
//           splashColor: Colors.white.withValues(alpha: 0.2),
//           child: Center(child: Icon(icon, color: Colors.white, size: 32)),
//         ),
//       ),
//     );
//   }
// }

// -----------------------------------Statless-------------------------
// =====================================================================
// LOGIN SCREEN - Pure Riverpod (No StatefulWidget)
// File: lib/features/auth/presentation/screens/login_screen.dart
// =====================================================================
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../providers/login_screen_providers.dart';
// import '../providers/auth_provider.dart';

// class LoginScreen extends ConsumerWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Get controllers from provider
//     final controllers = ref.watch(loginTextControllersProvider);
//     final formKey = ref.watch(loginFormKeyProvider);
//     final obscurePassword = ref.watch(loginPasswordVisibilityProvider);

//     // Get auth state
//     final authState = ref.watch(authControllerProvider);

//     // Listen for errors and success messages
//     ref.listen(authControllerProvider, (previous, next) {
//       if (next.error != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(next.error!),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//         ref.read(authControllerProvider.notifier).clearError();
//       }

//       if (next.successMessage != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(next.successMessage!),
//             backgroundColor: const Color(0xFF4ECDC4),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//         ref.read(authControllerProvider.notifier).clearSuccess();
//       }
//     });

//     return Scaffold(
//       backgroundColor: Colors.black,
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       body: Stack(
//         children: [
//           // Background Image - Full Screen
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/bg_signin.png',
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

//           // Dark Overlay
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.black.withValues(alpha: 0.72),
//                     Colors.black.withValues(alpha: 0.82),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // Content
//           SafeArea(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 return SingleChildScrollView(
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       minHeight: constraints.maxHeight,
//                     ),
//                     child: IntrinsicHeight(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 24,
//                           vertical: 24,
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             // Title (removed animations for pure Riverpod)
//                             Column(
//                               children: [
//                                 const Text(
//                                   'Welcome Back!',
//                                   style: TextStyle(
//                                     fontSize: 28,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Sign in to continue',
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.white.withValues(alpha: 0.9),
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 50),

//                             // Form
//                             Form(
//                               key: formKey,
//                               child: Column(
//                                 children: [
//                                   // Email field
//                                   _buildInputField(
//                                     controller: controllers.email,
//                                     label: 'Email Address',
//                                     hint: 'Enter your email',
//                                     icon: Icons.email_outlined,
//                                     keyboardType: TextInputType.emailAddress,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter your email';
//                                       }
//                                       final emailRegex = RegExp(
//                                         r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                                       );
//                                       if (!emailRegex.hasMatch(value)) {
//                                         return 'Please enter a valid email';
//                                       }
//                                       return null;
//                                     },
//                                   ),

//                                   const SizedBox(height: 18),

//                                   // Password field
//                                   _buildInputField(
//                                     controller: controllers.password,
//                                     label: 'Password',
//                                     hint: 'Enter your password',
//                                     icon: Icons.lock_outline,
//                                     obscureText: obscurePassword,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter a password';
//                                       }
//                                       if (value.length < 6) {
//                                         return 'Password must be at least 6 characters';
//                                       }
//                                       return null;
//                                     },
//                                     suffixIcon: IconButton(
//                                       icon: Icon(
//                                         obscurePassword
//                                             ? Icons.visibility_off_outlined
//                                             : Icons.visibility_outlined,
//                                         color: Colors.white70,
//                                         size: 22,
//                                       ),
//                                       onPressed: () {
//                                         // Toggle password visibility using Riverpod
//                                         ref
//                                                 .read(
//                                                   loginPasswordVisibilityProvider
//                                                       .notifier,
//                                                 )
//                                                 .state =
//                                             !obscurePassword;
//                                       },
//                                     ),
//                                   ),

//                                   const SizedBox(height: 12),

//                                   // Forgot Password
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: TextButton(
//                                       onPressed: () {
//                                         ScaffoldMessenger.of(
//                                           context,
//                                         ).showSnackBar(
//                                           const SnackBar(
//                                             content: Text(
//                                               'Feature coming soon',
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                       child: Text(
//                                         'Forgot Password?',
//                                         style: TextStyle(
//                                           color: Colors.white.withValues(
//                                             alpha: 0.9,
//                                           ),
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                   ),

//                                   const SizedBox(height: 20),

//                                   // Sign In Button
//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 56,
//                                     child: ElevatedButton(
//                                       onPressed: authState.isLoading
//                                           ? null
//                                           : () async {
//                                               if (formKey.currentState!
//                                                   .validate()) {
//                                                 await ref
//                                                     .read(
//                                                       authControllerProvider
//                                                           .notifier,
//                                                     )
//                                                     .signInWithEmail(
//                                                       email: controllers
//                                                           .email
//                                                           .text
//                                                           .trim(),
//                                                       password: controllers
//                                                           .password
//                                                           .text
//                                                           .trim(),
//                                                     );
//                                               }
//                                             },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.transparent,
//                                         shadowColor: Colors.transparent,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             16,
//                                           ),
//                                         ),
//                                         padding: EdgeInsets.zero,
//                                       ),
//                                       child: Ink(
//                                         decoration: BoxDecoration(
//                                           gradient: const LinearGradient(
//                                             colors: [
//                                               Color(0xFF2C5F7C),
//                                               Color(0xFF4ECDC4),
//                                             ],
//                                           ),
//                                           borderRadius: BorderRadius.circular(
//                                             16,
//                                           ),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: const Color(
//                                                 0xFF2C5F7C,
//                                               ).withValues(alpha: 0.4),
//                                               blurRadius: 20,
//                                               offset: const Offset(0, 8),
//                                             ),
//                                           ],
//                                         ),
//                                         child: Container(
//                                           alignment: Alignment.center,
//                                           child: authState.isLoading
//                                               ? SizedBox(
//                                                   width: 24,
//                                                   height: 24,
//                                                   child: CircularProgressIndicator(
//                                                     valueColor:
//                                                         AlwaysStoppedAnimation<
//                                                           Color
//                                                         >(Colors.white),
//                                                     strokeWidth: 2.5,
//                                                   ),
//                                                 )
//                                               : const Text(
//                                                   'Sign In',
//                                                   style: TextStyle(
//                                                     fontSize: 17,
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Colors.white,
//                                                     letterSpacing: 0.5,
//                                                   ),
//                                                 ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),

//                                   const SizedBox(height: 32),

//                                   // Sign up link
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "Don't have an account? ",
//                                         style: TextStyle(
//                                           color: Colors.white.withValues(
//                                             alpha: 0.8,
//                                           ),
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                       GestureDetector(
//                                         onTap: () => context.go('/signup'),
//                                         child: const Text(
//                                           'Sign Up',
//                                           style: TextStyle(
//                                             color: Color(0xFF4ECDC4),
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),

//                                   const SizedBox(height: 32),

//                                   // Divider
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: Divider(
//                                           color: Colors.white.withValues(
//                                             alpha: 0.3,
//                                           ),
//                                           thickness: 1,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 16,
//                                         ),
//                                         child: Text(
//                                           'OR CONTINUE WITH',
//                                           style: TextStyle(
//                                             color: Colors.white.withValues(
//                                               alpha: 0.7,
//                                             ),
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 12,
//                                             letterSpacing: 0.5,
//                                           ),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Divider(
//                                           color: Colors.white.withValues(
//                                             alpha: 0.3,
//                                           ),
//                                           thickness: 1,
//                                         ),
//                                       ),
//                                     ],
//                                   ),

//                                   const SizedBox(height: 28),

//                                   // Social login buttons
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       _buildIconOnlyButton(
//                                         icon: Icons.phone_android,
//                                         onPressed: () =>
//                                             context.push('/phone-auth'),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       _buildIconOnlyButton(
//                                         icon: Icons.g_mobiledata,
//                                         onPressed: () {
//                                           ref
//                                               .read(
//                                                 authControllerProvider.notifier,
//                                               )
//                                               .signInWithGoogle();
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     TextInputType? keyboardType,
//     bool obscureText = false,
//     String? Function(String?)? validator,
//     Widget? suffixIcon,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Colors.white.withValues(alpha: 0.9),
//             letterSpacing: 0.3,
//           ),
//         ),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white.withValues(alpha: 0.15),
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(
//               color: Colors.white.withValues(alpha: 0.2),
//               width: 1,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: TextFormField(
//             controller: controller,
//             keyboardType: keyboardType,
//             obscureText: obscureText,
//             validator: validator,
//             style: const TextStyle(
//               fontSize: 15,
//               color: Colors.white,
//               fontWeight: FontWeight.w500,
//             ),
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: TextStyle(
//                 color: Colors.white.withValues(alpha: 0.5),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//               ),
//               prefixIcon: Icon(
//                 icon,
//                 color: Colors.white.withValues(alpha: 0.8),
//                 size: 22,
//               ),
//               suffixIcon: suffixIcon,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide.none,
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide.none,
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: Colors.white.withValues(alpha: 0.4),
//                   width: 2,
//                 ),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(color: Colors.red[300]!, width: 1.5),
//               ),
//               focusedErrorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(color: Colors.red, width: 2),
//               ),
//               filled: false,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//               errorStyle: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildIconOnlyButton({
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return Container(
//       width: 64,
//       height: 64,
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.15),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.white.withValues(alpha: 0.2),
//           width: 1.5,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.15),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onPressed,
//           borderRadius: BorderRadius.circular(16),
//           splashColor: Colors.white.withValues(alpha: 0.2),
//           child: Center(child: Icon(icon, color: Colors.white, size: 32)),
//         ),
//       ),
//     );
//   }
// }
// ------------------------------------------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import '../providers/login_screen_providers.dart';
// import '../providers/auth_provider.dart';

// class LoginScreen extends ConsumerWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Get controllers from provider
//     final controllers = ref.watch(loginTextControllersProvider);
//     final formKey = ref.watch(loginFormKeyProvider);
//     final obscurePassword = ref.watch(loginPasswordVisibilityProvider);

//     // Get auth state
//     final authState = ref.watch(authControllerProvider);

//     // Listen for errors and success messages
//     ref.listen(authControllerProvider, (previous, next) {
//       if (next.error != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(next.error!),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//         ref.read(authControllerProvider.notifier).clearError();
//       }

//       if (next.successMessage != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(next.successMessage!),
//             backgroundColor: const Color(0xFF4ECDC4),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//         ref.read(authControllerProvider.notifier).clearSuccess();
//       }
//     });

//     return Scaffold(
//       backgroundColor: Colors.black,
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       body: Stack(
//         children: [
//           // Background Image - Full Screen
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/bg_signin.png',
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

//           // Dark Overlay
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.black.withValues(alpha: 0.72),
//                     Colors.black.withValues(alpha: 0.82),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // Content (WITH ANIMATIONS!)
//           SafeArea(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 return SingleChildScrollView(
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       minHeight: constraints.maxHeight,
//                     ),
//                     child: IntrinsicHeight(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 24,
//                           vertical: 24,
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             // Title (ANIMATED)
//                             Column(
//                                   children: [
//                                     const Text(
//                                       'Welcome Back!',
//                                       style: TextStyle(
//                                         fontSize: 28,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       'Sign in to continue',
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                         color: Colors.white.withValues(
//                                           alpha: 0.9,
//                                         ),
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                                 .animate()
//                                 .fadeIn(duration: 600.ms, curve: Curves.easeOut)
//                                 .slideY(begin: 0.2, end: 0, duration: 800.ms),

//                             const SizedBox(height: 50),

//                             // Form (ANIMATED)
//                             Form(
//                                   key: formKey,
//                                   child: Column(
//                                     children: [
//                                       // Email field
//                                       _buildInputField(
//                                         controller: controllers.email,
//                                         label: 'Email Address',
//                                         hint: 'Enter your email',
//                                         icon: Icons.email_outlined,
//                                         keyboardType:
//                                             TextInputType.emailAddress,
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return 'Please enter your email';
//                                           }
//                                           final emailRegex = RegExp(
//                                             r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                                           );
//                                           if (!emailRegex.hasMatch(value)) {
//                                             return 'Please enter a valid email';
//                                           }
//                                           return null;
//                                         },
//                                       ),

//                                       const SizedBox(height: 18),

//                                       // Password field
//                                       _buildInputField(
//                                         controller: controllers.password,
//                                         label: 'Password',
//                                         hint: 'Enter your password',
//                                         icon: Icons.lock_outline,
//                                         obscureText: obscurePassword,
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return 'Please enter a password';
//                                           }
//                                           if (value.length < 6) {
//                                             return 'Password must be at least 6 characters';
//                                           }
//                                           return null;
//                                         },
//                                         suffixIcon: IconButton(
//                                           icon: Icon(
//                                             obscurePassword
//                                                 ? Icons.visibility_off_outlined
//                                                 : Icons.visibility_outlined,
//                                             color: Colors.white70,
//                                             size: 22,
//                                           ),
//                                           onPressed: () {
//                                             // Toggle password visibility using Riverpod
//                                             ref
//                                                     .read(
//                                                       loginPasswordVisibilityProvider
//                                                           .notifier,
//                                                     )
//                                                     .state =
//                                                 !obscurePassword;
//                                           },
//                                         ),
//                                       ),

//                                       const SizedBox(height: 12),

//                                       // Forgot Password
//                                       Align(
//                                         alignment: Alignment.centerRight,
//                                         child: TextButton(
//                                           onPressed: () {
//                                             ScaffoldMessenger.of(
//                                               context,
//                                             ).showSnackBar(
//                                               const SnackBar(
//                                                 content: Text(
//                                                   'Feature coming soon',
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child: Text(
//                                             'Forgot Password?',
//                                             style: TextStyle(
//                                               color: Colors.white.withValues(
//                                                 alpha: 0.9,
//                                               ),
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ),
//                                       ),

//                                       const SizedBox(height: 20),

//                                       // Sign In Button
//                                       SizedBox(
//                                         width: double.infinity,
//                                         height: 56,
//                                         child: ElevatedButton(
//                                           onPressed: authState.isLoading
//                                               ? null
//                                               : () async {
//                                                   if (formKey.currentState!
//                                                       .validate()) {
//                                                     await ref
//                                                         .read(
//                                                           authControllerProvider
//                                                               .notifier,
//                                                         )
//                                                         .signInWithEmail(
//                                                           email: controllers
//                                                               .email
//                                                               .text
//                                                               .trim(),
//                                                           password: controllers
//                                                               .password
//                                                               .text
//                                                               .trim(),
//                                                         );
//                                                   }
//                                                 },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Colors.transparent,
//                                             shadowColor: Colors.transparent,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(16),
//                                             ),
//                                             padding: EdgeInsets.zero,
//                                           ),
//                                           child: Ink(
//                                             decoration: BoxDecoration(
//                                               gradient: const LinearGradient(
//                                                 colors: [
//                                                   Color(0xFF2C5F7C),
//                                                   Color(0xFF4ECDC4),
//                                                 ],
//                                               ),
//                                               borderRadius:
//                                                   BorderRadius.circular(16),
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: const Color(
//                                                     0xFF2C5F7C,
//                                                   ).withValues(alpha: 0.4),
//                                                   blurRadius: 20,
//                                                   offset: const Offset(0, 8),
//                                                 ),
//                                               ],
//                                             ),
//                                             child: Container(
//                                               alignment: Alignment.center,
//                                               child: authState.isLoading
//                                                   ? SizedBox(
//                                                       width: 24,
//                                                       height: 24,
//                                                       child: CircularProgressIndicator(
//                                                         valueColor:
//                                                             AlwaysStoppedAnimation<
//                                                               Color
//                                                             >(Colors.white),
//                                                         strokeWidth: 2.5,
//                                                       ),
//                                                     )
//                                                   : const Text(
//                                                       'Sign In',
//                                                       style: TextStyle(
//                                                         fontSize: 17,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Colors.white,
//                                                         letterSpacing: 0.5,
//                                                       ),
//                                                     ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),

//                                       const SizedBox(height: 32),

//                                       // Sign up link
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             "Don't have an account? ",
//                                             style: TextStyle(
//                                               color: Colors.white.withValues(
//                                                 alpha: 0.8,
//                                               ),
//                                               fontSize: 14,
//                                             ),
//                                           ),
//                                           GestureDetector(
//                                             onTap: () => context.go('/signup'),
//                                             child: const Text(
//                                               'Sign Up',
//                                               style: TextStyle(
//                                                 color: Color(0xFF4ECDC4),
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),

//                                       const SizedBox(height: 32),

//                                       // Divider
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: Divider(
//                                               color: Colors.white.withValues(
//                                                 alpha: 0.3,
//                                               ),
//                                               thickness: 1,
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 16,
//                                             ),
//                                             child: Text(
//                                               'OR CONTINUE WITH',
//                                               style: TextStyle(
//                                                 color: Colors.white.withValues(
//                                                   alpha: 0.7,
//                                                 ),
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 12,
//                                                 letterSpacing: 0.5,
//                                               ),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Divider(
//                                               color: Colors.white.withValues(
//                                                 alpha: 0.3,
//                                               ),
//                                               thickness: 1,
//                                             ),
//                                           ),
//                                         ],
//                                       ),

//                                       const SizedBox(height: 28),

//                                       // Social login buttons (ANIMATED)
//                                       Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               _buildIconOnlyButton(
//                                                 icon: Icons.phone_android,
//                                                 onPressed: () =>
//                                                     context.push('/phone-auth'),
//                                               ),
//                                               const SizedBox(width: 20),
//                                               _buildIconOnlyButton(
//                                                 icon: Icons.g_mobiledata,
//                                                 onPressed: () {
//                                                   ref
//                                                       .read(
//                                                         authControllerProvider
//                                                             .notifier,
//                                                       )
//                                                       .signInWithGoogle();
//                                                 },
//                                               ),
//                                             ],
//                                           )
//                                           .animate(delay: 600.ms)
//                                           .fadeIn(duration: 600.ms)
//                                           .scale(
//                                             begin: const Offset(0.8, 0.8),
//                                             duration: 600.ms,
//                                           ),
//                                     ],
//                                   ),
//                                 )
//                                 .animate(delay: 300.ms)
//                                 .fadeIn(duration: 600.ms, curve: Curves.easeOut)
//                                 .slideY(begin: 0.3, end: 0, duration: 800.ms),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     TextInputType? keyboardType,
//     bool obscureText = false,
//     String? Function(String?)? validator,
//     Widget? suffixIcon,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Colors.white.withValues(alpha: 0.9),
//             letterSpacing: 0.3,
//           ),
//         ),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white.withValues(alpha: 0.15),
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(
//               color: Colors.white.withValues(alpha: 0.2),
//               width: 1,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: TextFormField(
//             controller: controller,
//             keyboardType: keyboardType,
//             obscureText: obscureText,
//             validator: validator,
//             style: const TextStyle(
//               fontSize: 15,
//               color: Colors.white,
//               fontWeight: FontWeight.w500,
//             ),
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: TextStyle(
//                 color: Colors.white.withValues(alpha: 0.5),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//               ),
//               prefixIcon: Icon(
//                 icon,
//                 color: Colors.white.withValues(alpha: 0.8),
//                 size: 22,
//               ),
//               suffixIcon: suffixIcon,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide.none,
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide.none,
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: Colors.white.withValues(alpha: 0.4),
//                   width: 2,
//                 ),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(color: Colors.red[300]!, width: 1.5),
//               ),
//               focusedErrorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(color: Colors.red, width: 2),
//               ),
//               filled: false,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//               errorStyle: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildIconOnlyButton({
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return Container(
//       width: 64,
//       height: 64,
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.15),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.white.withValues(alpha: 0.2),
//           width: 1.5,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.15),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onPressed,
//           borderRadius: BorderRadius.circular(16),
//           splashColor: Colors.white.withValues(alpha: 0.2),
//           child: Center(child: Icon(icon, color: Colors.white, size: 32)),
//         ),
//       ),
//     );
//   }
// }

// ------------------------------With const Colors------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/login_screen_providers.dart';
import '../providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get controllers from provider
    final controllers = ref.watch(loginTextControllersProvider);
    final formKey = ref.watch(loginFormKeyProvider);
    final obscurePassword = ref.watch(loginPasswordVisibilityProvider);

    // Get auth state
    final authState = ref.watch(authControllerProvider);

    // Listen for errors and success messages
    ref.listen(authControllerProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.errorDark,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        ref.read(authControllerProvider.notifier).clearError();
      }

      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        ref.read(authControllerProvider.notifier).clearSuccess();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          // Background Image - Full Screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_signin.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.backgroundGradient,
                  ),
                );
              },
            ),
          ),

          // Dark Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(gradient: AppColors.overlayGradient),
            ),
          ),

          // Content (WITH ANIMATIONS!)
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Title (ANIMATED)
                            Column(
                                  children: [
                                    const Text(
                                      'Welcome Back!',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Sign in to continue',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                                .animate()
                                .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                                .slideY(begin: 0.2, end: 0, duration: 800.ms),

                            const SizedBox(height: 50),

                            // Form (ANIMATED)
                            Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      // Email field
                                      _buildInputField(
                                        controller: controllers.email,
                                        label: 'Email Address',
                                        hint: 'Enter your email',
                                        icon: Icons.email_outlined,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          final emailRegex = RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                          );
                                          if (!emailRegex.hasMatch(value)) {
                                            return 'Please enter a valid email';
                                          }
                                          return null;
                                        },
                                      ),

                                      const SizedBox(height: 18),

                                      // Password field
                                      _buildInputField(
                                        controller: controllers.password,
                                        label: 'Password',
                                        hint: 'Enter your password',
                                        icon: Icons.lock_outline,
                                        obscureText: obscurePassword,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a password';
                                          }
                                          if (value.length < 6) {
                                            return 'Password must be at least 6 characters';
                                          }
                                          return null;
                                        },
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            obscurePassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: AppColors.iconSecondary,
                                            size: 22,
                                          ),
                                          onPressed: () {
                                            ref
                                                    .read(
                                                      loginPasswordVisibilityProvider
                                                          .notifier,
                                                    )
                                                    .state =
                                                !obscurePassword;
                                          },
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      // Forgot Password
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Feature coming soon',
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      // Sign In Button
                                      SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: authState.isLoading
                                              ? null
                                              : () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    await ref
                                                        .read(
                                                          authControllerProvider
                                                              .notifier,
                                                        )
                                                        .signInWithEmail(
                                                          email: controllers
                                                              .email
                                                              .text
                                                              .trim(),
                                                          password: controllers
                                                              .password
                                                              .text
                                                              .trim(),
                                                        );
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.transparent,
                                            shadowColor: AppColors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            padding: EdgeInsets.zero,
                                          ),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              gradient:
                                                  AppColors.primaryGradient,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      AppColors.shadowPrimary,
                                                  blurRadius: 20,
                                                  offset: const Offset(0, 8),
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: authState.isLoading
                                                  ? SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child: CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                              Color
                                                            >(
                                                              AppColors
                                                                  .textPrimary,
                                                            ),
                                                        strokeWidth: 2.5,
                                                      ),
                                                    )
                                                  : const Text(
                                                      'Sign In',
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors
                                                            .textPrimary,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 32),

                                      // Sign up link
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Don't have an account? ",
                                            style: TextStyle(
                                              color: AppColors.textTertiary,
                                              fontSize: 14,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => context.go('/signup'),
                                            child: const Text(
                                              'Sign Up',
                                              style: TextStyle(
                                                color: AppColors.secondary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 32),

                                      // Divider
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              color: AppColors.divider,
                                              thickness: 1,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Text(
                                              'OR CONTINUE WITH',
                                              style: TextStyle(
                                                color: AppColors.textDisabled,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Divider(
                                              color: AppColors.divider,
                                              thickness: 1,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 28),

                                      // Social login buttons (ANIMATED)
                                      Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              _buildIconOnlyButton(
                                                icon: Icons.phone_android,
                                                onPressed: () =>
                                                    context.push('/phone-auth'),
                                              ),
                                              const SizedBox(width: 20),
                                              _buildIconOnlyButton(
                                                icon: Icons.g_mobiledata,
                                                onPressed: () {
                                                  ref
                                                      .read(
                                                        authControllerProvider
                                                            .notifier,
                                                      )
                                                      .signInWithGoogle();
                                                },
                                              ),
                                            ],
                                          )
                                          .animate(delay: 600.ms)
                                          .fadeIn(duration: 600.ms)
                                          .scale(
                                            begin: const Offset(0.8, 0.8),
                                            duration: 600.ms,
                                          ),
                                    ],
                                  ),
                                )
                                .animate(delay: 300.ms)
                                .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                                .slideY(begin: 0.3, end: 0, duration: 800.ms),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.glassBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowGlass,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.textHint,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(icon, color: AppColors.iconPrimary, size: 22),
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: AppColors.focusedBorder,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppColors.error, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.errorDark,
                  width: 2,
                ),
              ),
              filled: false,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              errorStyle: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconOnlyButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowButton,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.splash,
          child: Center(
            child: Icon(icon, color: AppColors.textPrimary, size: 32),
          ),
        ),
      ),
    );
  }
}
