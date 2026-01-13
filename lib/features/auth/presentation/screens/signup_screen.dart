// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../providers/auth_provider.dart';
// import 'login_screen.dart';
// import 'phone_auth_screen.dart';

// class SignupScreen extends ConsumerStatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   ConsumerState<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends ConsumerState<SignupScreen>
//     with TickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

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
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
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

//   String? _validateConfirmPassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please confirm your password';
//     }
//     if (value != _passwordController.text) {
//       return 'Passwords do not match';
//     }
//     return null;
//   }

//   String? _validateName(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your name';
//     }
//     return null;
//   }

//   Future<void> _handleSignup() async {
//     if (_formKey.currentState!.validate()) {
//       ref
//           .read(authControllerProvider.notifier)
//           .signUpWithEmail(
//             email: _emailController.text.trim(),
//             password: _passwordController.text,
//             name: _nameController.text.trim(),
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
//           // Background Image
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
//           SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.only(
//                 left: 24,
//                 right: 24,
//                 top: MediaQuery.of(context).padding.top + 24,
//                 bottom: MediaQuery.of(context).padding.bottom + 24,
//               ),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 60),

//                   // Title
//                   FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: Column(
//                       children: [
//                         const Text(
//                           'Create Account',
//                           style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Sign up to get started',
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.white.withValues(alpha: 0.9),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 50),

//                   // Form
//                   SlideTransition(
//                     position: _slideAnimation,
//                     child: FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//                             // Name field
//                             _buildInputField(
//                               controller: _nameController,
//                               label: 'Full Name',
//                               hint: 'Enter your name',
//                               icon: Icons.person_outline,
//                               validator: _validateName,
//                             ),

//                             const SizedBox(height: 18),

//                             // Email field
//                             _buildInputField(
//                               controller: _emailController,
//                               label: 'Email Address',
//                               hint: 'Enter your email',
//                               icon: Icons.email_outlined,
//                               keyboardType: TextInputType.emailAddress,
//                               validator: _validateEmail,
//                             ),

//                             const SizedBox(height: 18),

//                             // Password field
//                             _buildInputField(
//                               controller: _passwordController,
//                               label: 'Password',
//                               hint: 'Enter your password',
//                               icon: Icons.lock_outline,
//                               obscureText: _obscurePassword,
//                               validator: _validatePassword,
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   _obscurePassword
//                                       ? Icons.visibility_off_outlined
//                                       : Icons.visibility_outlined,
//                                   color: Colors.white70,
//                                   size: 22,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     _obscurePassword = !_obscurePassword;
//                                   });
//                                 },
//                               ),
//                             ),

//                             const SizedBox(height: 18),

//                             // Confirm Password field
//                             _buildInputField(
//                               controller: _confirmPasswordController,
//                               label: 'Confirm Password',
//                               hint: 'Re-enter your password',
//                               icon: Icons.lock_outline,
//                               obscureText: _obscureConfirmPassword,
//                               validator: _validateConfirmPassword,
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   _obscureConfirmPassword
//                                       ? Icons.visibility_off_outlined
//                                       : Icons.visibility_outlined,
//                                   color: Colors.white70,
//                                   size: 22,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     _obscureConfirmPassword =
//                                         !_obscureConfirmPassword;
//                                   });
//                                 },
//                               ),
//                             ),

//                             const SizedBox(height: 28),

//                             // Sign Up Button
//                             SizedBox(
//                               width: double.infinity,
//                               height: 56,
//                               child: ElevatedButton(
//                                 onPressed: authState.isLoading
//                                     ? null
//                                     : _handleSignup,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.transparent,
//                                   shadowColor: Colors.transparent,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   padding: EdgeInsets.zero,
//                                 ),
//                                 child: Ink(
//                                   decoration: BoxDecoration(
//                                     gradient: const LinearGradient(
//                                       colors: [
//                                         Color(0xFF2C5F7C),
//                                         Color(0xFF4ECDC4),
//                                       ],
//                                     ),
//                                     borderRadius: BorderRadius.circular(16),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: const Color(
//                                           0xFF2C5F7C,
//                                         ).withValues(alpha: 0.4),
//                                         blurRadius: 20,
//                                         offset: const Offset(0, 8),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     child: authState.isLoading
//                                         ? const SizedBox(
//                                             width: 24,
//                                             height: 24,
//                                             child: CircularProgressIndicator(
//                                               valueColor:
//                                                   AlwaysStoppedAnimation<Color>(
//                                                     Colors.white,
//                                                   ),
//                                               strokeWidth: 2.5,
//                                             ),
//                                           )
//                                         : const Text(
//                                             'Sign Up',
//                                             style: TextStyle(
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             const SizedBox(height: 28),

//                             // Sign in link
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'Already have an account? ',
//                                   style: TextStyle(
//                                     color: Colors.white.withValues(alpha: 0.8),
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 // GestureDetector(
//                                 //   onTap: () {
//                                 //     Navigator.pushReplacement(
//                                 //       context,
//                                 //       MaterialPageRoute(
//                                 //         builder: (context) =>
//                                 //             const LoginScreen(),
//                                 //       ),
//                                 //     );
//                                 //   },
//                                 //   child: const Text(
//                                 //     'Sign In',
//                                 //     style: TextStyle(
//                                 //       color: Color(0xFF4ECDC4),
//                                 //       fontSize: 14,
//                                 //       fontWeight: FontWeight.bold,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                                 GestureDetector(
//                                   onTap: () =>
//                                       context.go('/login'), // ← Simple!
//                                   child: const Text('Sign In'),
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 32),

//                             // Divider
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Divider(
//                                     color: Colors.white.withValues(alpha: 0.3),
//                                     thickness: 1,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                   ),
//                                   child: Text(
//                                     'OR CONTINUE WITH',
//                                     style: TextStyle(
//                                       color: Colors.white.withValues(
//                                         alpha: 0.7,
//                                       ),
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 12,
//                                       letterSpacing: 0.5,
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Divider(
//                                     color: Colors.white.withValues(alpha: 0.3),
//                                     thickness: 1,
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 28),

//                             // Social login buttons
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 _buildIconOnlyButton(
//                                   icon: Icons.phone_android,
//                                   onPressed: _navigateToPhoneAuth,
//                                 ),
//                                 const SizedBox(width: 20),
//                                 _buildIconOnlyButton(
//                                   icon: Icons.g_mobiledata,
//                                   onPressed: _handleGoogleSignIn,
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 40),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
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

// ----------------------------------Statless---------------------
// =====================================================================
// SIGNUP SCREEN - Pure Riverpod (No StatefulWidget)
// File: lib/features/auth/presentation/screens/signup_screen.dart
// =====================================================================
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../providers/signup_screen_providers.dart';
// import '../providers/auth_provider.dart';

// class SignupScreen extends ConsumerWidget {
//   const SignupScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Get controllers from provider
//     final controllers = ref.watch(signupTextControllersProvider);
//     final formKey = ref.watch(signupFormKeyProvider);

//     // Get password visibility states
//     final obscurePassword = ref.watch(signupPasswordVisibilityProvider);
//     final obscureConfirmPassword = ref.watch(
//       signupConfirmPasswordVisibilityProvider,
//     );

//     // Get auth state
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
//           // Background Image
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
//           SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.only(
//                 left: 24,
//                 right: 24,
//                 top: MediaQuery.of(context).padding.top + 24,
//                 bottom: MediaQuery.of(context).padding.bottom + 24,
//               ),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 60),

//                   // Title (removed animations for pure Riverpod)
//                   Column(
//                     children: [
//                       const Text(
//                         'Create Account',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Sign up to get started',
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.white.withValues(alpha: 0.9),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 50),

//                   // Form
//                   Form(
//                     key: formKey,
//                     child: Column(
//                       children: [
//                         // Name field
//                         _buildInputField(
//                           controller: controllers.name,
//                           label: 'Full Name',
//                           hint: 'Enter your name',
//                           icon: Icons.person_outline,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your name';
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 18),

//                         // Email field
//                         _buildInputField(
//                           controller: controllers.email,
//                           label: 'Email Address',
//                           hint: 'Enter your email',
//                           icon: Icons.email_outlined,
//                           keyboardType: TextInputType.emailAddress,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your email';
//                             }
//                             final emailRegex = RegExp(
//                               r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                             );
//                             if (!emailRegex.hasMatch(value)) {
//                               return 'Please enter a valid email';
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 18),

//                         // Password field
//                         _buildInputField(
//                           controller: controllers.password,
//                           label: 'Password',
//                           hint: 'Enter your password',
//                           icon: Icons.lock_outline,
//                           obscureText: obscurePassword,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter a password';
//                             }
//                             if (value.length < 6) {
//                               return 'Password must be at least 6 characters';
//                             }
//                             return null;
//                           },
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               obscurePassword
//                                   ? Icons.visibility_off_outlined
//                                   : Icons.visibility_outlined,
//                               color: Colors.white70,
//                               size: 22,
//                             ),
//                             onPressed: () {
//                               ref
//                                       .read(
//                                         signupPasswordVisibilityProvider
//                                             .notifier,
//                                       )
//                                       .state =
//                                   !obscurePassword;
//                             },
//                           ),
//                         ),

//                         const SizedBox(height: 18),

//                         // Confirm Password field
//                         _buildInputField(
//                           controller: controllers.confirmPassword,
//                           label: 'Confirm Password',
//                           hint: 'Re-enter your password',
//                           icon: Icons.lock_outline,
//                           obscureText: obscureConfirmPassword,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please confirm your password';
//                             }
//                             if (value != controllers.password.text) {
//                               return 'Passwords do not match';
//                             }
//                             return null;
//                           },
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               obscureConfirmPassword
//                                   ? Icons.visibility_off_outlined
//                                   : Icons.visibility_outlined,
//                               color: Colors.white70,
//                               size: 22,
//                             ),
//                             onPressed: () {
//                               ref
//                                       .read(
//                                         signupConfirmPasswordVisibilityProvider
//                                             .notifier,
//                                       )
//                                       .state =
//                                   !obscureConfirmPassword;
//                             },
//                           ),
//                         ),

//                         const SizedBox(height: 28),

//                         // Sign Up Button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 56,
//                           child: ElevatedButton(
//                             onPressed: authState.isLoading
//                                 ? null
//                                 : () async {
//                                     if (formKey.currentState!.validate()) {
//                                       await ref
//                                           .read(authControllerProvider.notifier)
//                                           .signUpWithEmail(
//                                             email: controllers.email.text
//                                                 .trim(),
//                                             password: controllers.password.text
//                                                 .trim(),
//                                             name: controllers.name.text.trim(),
//                                           );
//                                     }
//                                   },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.transparent,
//                               shadowColor: Colors.transparent,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               padding: EdgeInsets.zero,
//                             ),
//                             child: Ink(
//                               decoration: BoxDecoration(
//                                 gradient: const LinearGradient(
//                                   colors: [
//                                     Color(0xFF2C5F7C),
//                                     Color(0xFF4ECDC4),
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(16),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: const Color(
//                                       0xFF2C5F7C,
//                                     ).withValues(alpha: 0.4),
//                                     blurRadius: 20,
//                                     offset: const Offset(0, 8),
//                                   ),
//                                 ],
//                               ),
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 child: authState.isLoading
//                                     ? SizedBox(
//                                         width: 24,
//                                         height: 24,
//                                         child: CircularProgressIndicator(
//                                           valueColor:
//                                               AlwaysStoppedAnimation<Color>(
//                                                 Colors.white,
//                                               ),
//                                           strokeWidth: 2.5,
//                                         ),
//                                       )
//                                     : const Text(
//                                         'Sign Up',
//                                         style: TextStyle(
//                                           fontSize: 17,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                           letterSpacing: 0.5,
//                                         ),
//                                       ),
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 28),

//                         // Sign in link
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Already have an account? ',
//                               style: TextStyle(
//                                 color: Colors.white.withValues(alpha: 0.8),
//                                 fontSize: 14,
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () => context.go('/login'),
//                               child: const Text(
//                                 'Sign In',
//                                 style: TextStyle(
//                                   color: Color(0xFF4ECDC4),
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 32),

//                         // Divider
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Divider(
//                                 color: Colors.white.withValues(alpha: 0.3),
//                                 thickness: 1,
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                               ),
//                               child: Text(
//                                 'OR CONTINUE WITH',
//                                 style: TextStyle(
//                                   color: Colors.white.withValues(alpha: 0.7),
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 12,
//                                   letterSpacing: 0.5,
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Divider(
//                                 color: Colors.white.withValues(alpha: 0.3),
//                                 thickness: 1,
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 28),

//                         // Social login buttons
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             _buildIconOnlyButton(
//                               icon: Icons.phone_android,
//                               onPressed: () => context.push('/phone-auth'),
//                             ),
//                             const SizedBox(width: 20),
//                             _buildIconOnlyButton(
//                               icon: Icons.g_mobiledata,
//                               onPressed: () {
//                                 ref
//                                     .read(authControllerProvider.notifier)
//                                     .signInWithGoogle();
//                               },
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 40),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
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
// import '../providers/signup_screen_providers.dart';
// import '../providers/auth_provider.dart';

// class SignupScreen extends ConsumerWidget {
//   const SignupScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Get controllers from provider
//     final controllers = ref.watch(signupTextControllersProvider);
//     final formKey = ref.watch(signupFormKeyProvider);

//     // Get password visibility states
//     final obscurePassword = ref.watch(signupPasswordVisibilityProvider);
//     final obscureConfirmPassword = ref.watch(
//       signupConfirmPasswordVisibilityProvider,
//     );

//     // Get auth state
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
//           // Background Image
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
//           SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.only(
//                 left: 24,
//                 right: 24,
//                 top: MediaQuery.of(context).padding.top + 24,
//                 bottom: MediaQuery.of(context).padding.bottom + 24,
//               ),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 60),

//                   // Title (ANIMATED)
//                   Column(
//                         children: [
//                           const Text(
//                             'Create Account',
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Sign up to get started',
//                             style: TextStyle(
//                               fontSize: 15,
//                               color: Colors.white.withValues(alpha: 0.9),
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       )
//                       .animate()
//                       .fadeIn(duration: 600.ms, curve: Curves.easeOut)
//                       .slideY(begin: 0.2, end: 0, duration: 800.ms),

//                   const SizedBox(height: 50),

//                   // Form (ANIMATED)
//                   Form(
//                         key: formKey,
//                         child: Column(
//                           children: [
//                             // Name field
//                             _buildInputField(
//                               controller: controllers.name,
//                               label: 'Full Name',
//                               hint: 'Enter your name',
//                               icon: Icons.person_outline,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your name';
//                                 }
//                                 return null;
//                               },
//                             ),

//                             const SizedBox(height: 18),

//                             // Email field
//                             _buildInputField(
//                               controller: controllers.email,
//                               label: 'Email Address',
//                               hint: 'Enter your email',
//                               icon: Icons.email_outlined,
//                               keyboardType: TextInputType.emailAddress,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your email';
//                                 }
//                                 final emailRegex = RegExp(
//                                   r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                                 );
//                                 if (!emailRegex.hasMatch(value)) {
//                                   return 'Please enter a valid email';
//                                 }
//                                 return null;
//                               },
//                             ),

//                             const SizedBox(height: 18),

//                             // Password field
//                             _buildInputField(
//                               controller: controllers.password,
//                               label: 'Password',
//                               hint: 'Enter your password',
//                               icon: Icons.lock_outline,
//                               obscureText: obscurePassword,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter a password';
//                                 }
//                                 if (value.length < 6) {
//                                   return 'Password must be at least 6 characters';
//                                 }
//                                 return null;
//                               },
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   obscurePassword
//                                       ? Icons.visibility_off_outlined
//                                       : Icons.visibility_outlined,
//                                   color: Colors.white70,
//                                   size: 22,
//                                 ),
//                                 onPressed: () {
//                                   ref
//                                           .read(
//                                             signupPasswordVisibilityProvider
//                                                 .notifier,
//                                           )
//                                           .state =
//                                       !obscurePassword;
//                                 },
//                               ),
//                             ),

//                             const SizedBox(height: 18),

//                             // Confirm Password field
//                             _buildInputField(
//                               controller: controllers.confirmPassword,
//                               label: 'Confirm Password',
//                               hint: 'Re-enter your password',
//                               icon: Icons.lock_outline,
//                               obscureText: obscureConfirmPassword,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please confirm your password';
//                                 }
//                                 if (value != controllers.password.text) {
//                                   return 'Passwords do not match';
//                                 }
//                                 return null;
//                               },
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   obscureConfirmPassword
//                                       ? Icons.visibility_off_outlined
//                                       : Icons.visibility_outlined,
//                                   color: Colors.white70,
//                                   size: 22,
//                                 ),
//                                 onPressed: () {
//                                   ref
//                                           .read(
//                                             signupConfirmPasswordVisibilityProvider
//                                                 .notifier,
//                                           )
//                                           .state =
//                                       !obscureConfirmPassword;
//                                 },
//                               ),
//                             ),

//                             const SizedBox(height: 28),

//                             // Sign Up Button
//                             SizedBox(
//                               width: double.infinity,
//                               height: 56,
//                               child: ElevatedButton(
//                                 onPressed: authState.isLoading
//                                     ? null
//                                     : () async {
//                                         if (formKey.currentState!.validate()) {
//                                           await ref
//                                               .read(
//                                                 authControllerProvider.notifier,
//                                               )
//                                               .signUpWithEmail(
//                                                 email: controllers.email.text
//                                                     .trim(),
//                                                 password: controllers
//                                                     .password
//                                                     .text
//                                                     .trim(),
//                                                 name: controllers.name.text
//                                                     .trim(),
//                                               );
//                                         }
//                                       },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.transparent,
//                                   shadowColor: Colors.transparent,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   padding: EdgeInsets.zero,
//                                 ),
//                                 child: Ink(
//                                   decoration: BoxDecoration(
//                                     gradient: const LinearGradient(
//                                       colors: [
//                                         Color(0xFF2C5F7C),
//                                         Color(0xFF4ECDC4),
//                                       ],
//                                     ),
//                                     borderRadius: BorderRadius.circular(16),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: const Color(
//                                           0xFF2C5F7C,
//                                         ).withValues(alpha: 0.4),
//                                         blurRadius: 20,
//                                         offset: const Offset(0, 8),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     child: authState.isLoading
//                                         ? SizedBox(
//                                             width: 24,
//                                             height: 24,
//                                             child: CircularProgressIndicator(
//                                               valueColor:
//                                                   AlwaysStoppedAnimation<Color>(
//                                                     Colors.white,
//                                                   ),
//                                               strokeWidth: 2.5,
//                                             ),
//                                           )
//                                         : const Text(
//                                             'Sign Up',
//                                             style: TextStyle(
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             const SizedBox(height: 28),

//                             // Sign in link
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'Already have an account? ',
//                                   style: TextStyle(
//                                     color: Colors.white.withValues(alpha: 0.8),
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () => context.go('/login'),
//                                   child: const Text(
//                                     'Sign In',
//                                     style: TextStyle(
//                                       color: Color(0xFF4ECDC4),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 32),

//                             // Divider
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Divider(
//                                     color: Colors.white.withValues(alpha: 0.3),
//                                     thickness: 1,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                   ),
//                                   child: Text(
//                                     'OR CONTINUE WITH',
//                                     style: TextStyle(
//                                       color: Colors.white.withValues(
//                                         alpha: 0.7,
//                                       ),
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 12,
//                                       letterSpacing: 0.5,
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Divider(
//                                     color: Colors.white.withValues(alpha: 0.3),
//                                     thickness: 1,
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 28),

//                             // Social login buttons (ANIMATED)
//                             Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     _buildIconOnlyButton(
//                                       icon: Icons.phone_android,
//                                       onPressed: () =>
//                                           context.push('/phone-auth'),
//                                     ),
//                                     const SizedBox(width: 20),
//                                     _buildIconOnlyButton(
//                                       icon: Icons.g_mobiledata,
//                                       onPressed: () {
//                                         ref
//                                             .read(
//                                               authControllerProvider.notifier,
//                                             )
//                                             .signInWithGoogle();
//                                       },
//                                     ),
//                                   ],
//                                 )
//                                 .animate(delay: 600.ms)
//                                 .fadeIn(duration: 600.ms)
//                                 .scale(
//                                   begin: const Offset(0.8, 0.8),
//                                   duration: 600.ms,
//                                 ),

//                             const SizedBox(height: 40),
//                           ],
//                         ),
//                       )
//                       .animate(delay: 300.ms)
//                       .fadeIn(duration: 600.ms, curve: Curves.easeOut)
//                       .slideY(begin: 0.3, end: 0, duration: 800.ms),
//                 ],
//               ),
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

// -------------------------With const Color-----------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/signup_screen_providers.dart';
import '../providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get controllers from provider
    final controllers = ref.watch(signupTextControllersProvider);
    final formKey = ref.watch(signupFormKeyProvider);

    // Get password visibility states
    final obscurePassword = ref.watch(signupPasswordVisibilityProvider);
    final obscureConfirmPassword = ref.watch(
      signupConfirmPasswordVisibilityProvider,
    );

    // Get auth state
    final authState = ref.watch(authControllerProvider);

    // Listen for errors
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
          // Background Image
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
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: MediaQuery.of(context).padding.top + 24,
                bottom: MediaQuery.of(context).padding.bottom + 24,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // Title (ANIMATED)
                  Column(
                        children: [
                          const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign up to get started',
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
                            // Name field
                            _buildInputField(
                              controller: controllers.name,
                              label: 'Full Name',
                              hint: 'Enter your name',
                              icon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            // Email field
                            _buildInputField(
                              controller: controllers.email,
                              label: 'Email Address',
                              hint: 'Enter your email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
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
                                            signupPasswordVisibilityProvider
                                                .notifier,
                                          )
                                          .state =
                                      !obscurePassword;
                                },
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Confirm Password field
                            _buildInputField(
                              controller: controllers.confirmPassword,
                              label: 'Confirm Password',
                              hint: 'Re-enter your password',
                              icon: Icons.lock_outline,
                              obscureText: obscureConfirmPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != controllers.password.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureConfirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.iconSecondary,
                                  size: 22,
                                ),
                                onPressed: () {
                                  ref
                                          .read(
                                            signupConfirmPasswordVisibilityProvider
                                                .notifier,
                                          )
                                          .state =
                                      !obscureConfirmPassword;
                                },
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Sign Up Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: authState.isLoading
                                    ? null
                                    : () async {
                                        if (formKey.currentState!.validate()) {
                                          await ref
                                              .read(
                                                authControllerProvider.notifier,
                                              )
                                              .signUpWithEmail(
                                                email: controllers.email.text
                                                    .trim(),
                                                password: controllers
                                                    .password
                                                    .text
                                                    .trim(),
                                                name: controllers.name.text
                                                    .trim(),
                                              );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.transparent,
                                  shadowColor: AppColors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.shadowPrimary,
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
                                                  AlwaysStoppedAnimation<Color>(
                                                    AppColors.textPrimary,
                                                  ),
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                        : const Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Sign in link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    color: AppColors.textTertiary,
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => context.go('/login'),
                                  child: const Text(
                                    'Sign In',
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                              authControllerProvider.notifier,
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

                            const SizedBox(height: 40),
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
