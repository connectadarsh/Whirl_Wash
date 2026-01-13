// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/auth_provider.dart';
// import 'package:go_router/go_router.dart'; // ← Add this import

// class PhoneAuthScreen extends ConsumerStatefulWidget {
//   const PhoneAuthScreen({super.key});

//   @override
//   ConsumerState<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
// }

// class _PhoneAuthScreenState extends ConsumerState<PhoneAuthScreen>
//     with TickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _phoneController = TextEditingController();
//   final _otpController = TextEditingController();
//   final _nameController = TextEditingController();

//   bool _otpSent = false;

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
//     _phoneController.dispose();
//     _otpController.dispose();
//     _nameController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   String? _validatePhone(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your phone number';
//     }
//     if (value.length < 10) {
//       return 'Please enter a valid phone number';
//     }
//     return null;
//   }

//   void _sendOTP() {
//     if (_formKey.currentState!.validate()) {
//       String phoneNumber = _phoneController.text.trim();

//       // Add country code if not present
//       if (!phoneNumber.startsWith('+')) {
//         phoneNumber = '+91$phoneNumber'; // Default to India
//       }

//       ref.read(authControllerProvider.notifier).sendOTP(phoneNumber);
//     }
//   }

//   void _verifyOTP() {
//     if (_otpController.text.length == 6) {
//       ref
//           .read(authControllerProvider.notifier)
//           .verifyOTP(
//             otp: _otpController.text,
//             name: _nameController.text.trim().isNotEmpty
//                 ? _nameController.text.trim()
//                 : null,
//           );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Please enter a valid 6-digit OTP'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authControllerProvider);

//     // Listen for state changes
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

//       if (next.verificationId != null && !_otpSent) {
//         setState(() {
//           _otpSent = true;
//         });
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
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         // leading: IconButton(
//         //   icon: const Icon(Icons.arrow_back, color: Colors.white),
//         //   onPressed: () => Navigator.pop(context),
//         // ),
//       ),
//       body: Stack(
//         children: [
//           // Background Image (same as signup)
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

//           // Dark Overlay (same as signup)
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
//                                   Text(
//                                     _otpSent ? 'Verify OTP' : 'Phone Login',
//                                     style: const TextStyle(
//                                       fontSize: 28,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     _otpSent
//                                         ? 'Enter the 6-digit code sent to\n${_phoneController.text}'
//                                         : 'Sign in with your phone number',
//                                     textAlign: TextAlign.center,
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
//                                       if (!_otpSent) ...[
//                                         // Phone number field
//                                         _buildInputField(
//                                           controller: _phoneController,
//                                           label: 'Phone Number',
//                                           hint: '10 digit mobile number',
//                                           icon: Icons.phone,
//                                           keyboardType: TextInputType.phone,
//                                           validator: _validatePhone,
//                                         ),

//                                         const SizedBox(height: 30),

//                                         // Send OTP button
//                                         SizedBox(
//                                           width: double.infinity,
//                                           height: 56,
//                                           child: ElevatedButton(
//                                             onPressed: authState.isLoading
//                                                 ? null
//                                                 : _sendOTP,
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor:
//                                                   Colors.transparent,
//                                               shadowColor: Colors.transparent,
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(16),
//                                               ),
//                                               padding: EdgeInsets.zero,
//                                             ),
//                                             child: Ink(
//                                               decoration: BoxDecoration(
//                                                 gradient: const LinearGradient(
//                                                   colors: [
//                                                     Color(0xFF2C5F7C),
//                                                     Color(0xFF4ECDC4),
//                                                   ],
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(16),
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                     color: const Color(
//                                                       0xFF2C5F7C,
//                                                     ).withValues(alpha: 0.4),
//                                                     blurRadius: 20,
//                                                     offset: const Offset(0, 8),
//                                                   ),
//                                                 ],
//                                               ),
//                                               child: Container(
//                                                 alignment: Alignment.center,
//                                                 child: authState.isLoading
//                                                     ? const SizedBox(
//                                                         width: 24,
//                                                         height: 24,
//                                                         child: CircularProgressIndicator(
//                                                           valueColor:
//                                                               AlwaysStoppedAnimation<
//                                                                 Color
//                                                               >(Colors.white),
//                                                           strokeWidth: 2.5,
//                                                         ),
//                                                       )
//                                                     : const Text(
//                                                         'Send OTP',
//                                                         style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           color: Colors.white,
//                                                           letterSpacing: 0.5,
//                                                         ),
//                                                       ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ] else ...[
//                                         // Name field (optional)
//                                         _buildInputField(
//                                           controller: _nameController,
//                                           label: 'Name (Optional)',
//                                           hint: 'Enter your name',
//                                           icon: Icons.person_outline,
//                                         ),

//                                         const SizedBox(height: 18),

//                                         // OTP field
//                                         _buildInputField(
//                                           controller: _otpController,
//                                           label: 'OTP Code',
//                                           hint: 'Enter 6-digit code',
//                                           icon: Icons.lock_outline,
//                                           keyboardType: TextInputType.number,
//                                           maxLength: 6,
//                                         ),

//                                         const SizedBox(height: 12),

//                                         // Resend OTP
//                                         Align(
//                                           alignment: Alignment.centerRight,
//                                           child: TextButton(
//                                             onPressed: _sendOTP,
//                                             child: Text(
//                                               'Resend OTP',
//                                               style: TextStyle(
//                                                 color: Colors.white.withValues(
//                                                   alpha: 0.9,
//                                                 ),
//                                                 fontSize: 13,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                           ),
//                                         ),

//                                         const SizedBox(height: 20),

//                                         // Verify button
//                                         SizedBox(
//                                           width: double.infinity,
//                                           height: 56,
//                                           child: ElevatedButton(
//                                             onPressed: authState.isLoading
//                                                 ? null
//                                                 : _verifyOTP,
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor:
//                                                   Colors.transparent,
//                                               shadowColor: Colors.transparent,
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(16),
//                                               ),
//                                               padding: EdgeInsets.zero,
//                                             ),
//                                             child: Ink(
//                                               decoration: BoxDecoration(
//                                                 gradient: const LinearGradient(
//                                                   colors: [
//                                                     Color(0xFF2C5F7C),
//                                                     Color(0xFF4ECDC4),
//                                                   ],
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(16),
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                     color: const Color(
//                                                       0xFF2C5F7C,
//                                                     ).withValues(alpha: 0.4),
//                                                     blurRadius: 20,
//                                                     offset: const Offset(0, 8),
//                                                   ),
//                                                 ],
//                                               ),
//                                               child: Container(
//                                                 alignment: Alignment.center,
//                                                 child: authState.isLoading
//                                                     ? const SizedBox(
//                                                         width: 24,
//                                                         height: 24,
//                                                         child: CircularProgressIndicator(
//                                                           valueColor:
//                                                               AlwaysStoppedAnimation<
//                                                                 Color
//                                                               >(Colors.white),
//                                                           strokeWidth: 2.5,
//                                                         ),
//                                                       )
//                                                     : const Text(
//                                                         'Verify & Login',
//                                                         style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           color: Colors.white,
//                                                           letterSpacing: 0.5,
//                                                         ),
//                                                       ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],

//                                       const SizedBox(height: 30),

//                                       // Change number (if OTP sent)
//                                       if (_otpSent)
//                                         TextButton(
//                                           onPressed: () {
//                                             setState(() {
//                                               _otpSent = false;
//                                               _otpController.clear();
//                                             });
//                                           },
//                                           child: const Text(
//                                             'Change Phone Number',
//                                             style: TextStyle(
//                                               color: Color(0xFF4ECDC4),
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ),
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
//     String? Function(String?)? validator,
//     int? maxLength,
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
//             validator: validator,
//             maxLength: maxLength,
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
//               counterText: '',
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
// }

// -------------------------------Stateless-------------------------

// =====================================================================
// PHONE AUTH SCREEN - Pure Riverpod (No StatefulWidget)
// File: lib/features/auth/presentation/screens/phone_auth_screen.dart
// =====================================================================
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../providers/phone_auth_screen_providers.dart';
// import '../providers/auth_provider.dart';

// class PhoneAuthScreen extends ConsumerWidget {
//   const PhoneAuthScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Get controllers from provider
//     final controllers = ref.watch(phoneAuthTextControllersProvider);
//     final formKey = ref.watch(phoneAuthFormKeyProvider);

//     // Get OTP sent state (determines which screen to show)
//     final otpSent = ref.watch(phoneAuthOtpSentProvider);

//     // Get auth state
//     final authState = ref.watch(authControllerProvider);

//     // Listen for state changes
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

//       if (next.verificationId != null && !otpSent) {
//         ref.read(phoneAuthOtpSentProvider.notifier).state = true;
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
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             if (otpSent) {
//               // Go back to phone input
//               ref.read(phoneAuthOtpSentProvider.notifier).state = false;
//               controllers.otp.clear();
//             } else {
//               context.pop();
//             }
//           },
//         ),
//       ),
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
//                                 Text(
//                                   otpSent ? 'Verify OTP' : 'Phone Login',
//                                   style: const TextStyle(
//                                     fontSize: 28,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   otpSent
//                                       ? 'Enter the 6-digit code sent to\n${controllers.phone.text}'
//                                       : 'Sign in with your phone number',
//                                   textAlign: TextAlign.center,
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
//                                   if (!otpSent) ...[
//                                     // Phone number field
//                                     _buildInputField(
//                                       controller: controllers.phone,
//                                       label: 'Phone Number',
//                                       hint: '10 digit mobile number',
//                                       icon: Icons.phone,
//                                       keyboardType: TextInputType.phone,
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter your phone number';
//                                         }
//                                         if (value.length < 10) {
//                                           return 'Please enter a valid phone number';
//                                         }
//                                         return null;
//                                       },
//                                     ),

//                                     const SizedBox(height: 30),

//                                     // Send OTP button
//                                     _buildGradientButton(
//                                       text: 'Send OTP',
//                                       isLoading: authState.isLoading,
//                                       onPressed: () {
//                                         if (formKey.currentState!.validate()) {
//                                           String phoneNumber = controllers
//                                               .phone
//                                               .text
//                                               .trim();

//                                           // Add country code if not present
//                                           if (!phoneNumber.startsWith('+')) {
//                                             phoneNumber = '+91$phoneNumber';
//                                           }

//                                           ref
//                                               .read(
//                                                 authControllerProvider.notifier,
//                                               )
//                                               .sendOTP(phoneNumber);
//                                         }
//                                       },
//                                     ),
//                                   ] else ...[
//                                     // OTP field
//                                     _buildInputField(
//                                       controller: controllers.otp,
//                                       label: 'OTP Code',
//                                       hint: 'Enter 6-digit code',
//                                       icon: Icons.lock_outline,
//                                       keyboardType: TextInputType.number,
//                                       maxLength: 6,
//                                     ),

//                                     const SizedBox(height: 12),

//                                     // Resend OTP
//                                     Align(
//                                       alignment: Alignment.centerRight,
//                                       child: TextButton(
//                                         onPressed: () {
//                                           String phoneNumber = controllers
//                                               .phone
//                                               .text
//                                               .trim();
//                                           if (!phoneNumber.startsWith('+')) {
//                                             phoneNumber = '+91$phoneNumber';
//                                           }
//                                           ref
//                                               .read(
//                                                 authControllerProvider.notifier,
//                                               )
//                                               .sendOTP(phoneNumber);
//                                         },
//                                         child: Text(
//                                           'Resend OTP',
//                                           style: TextStyle(
//                                             color: Colors.white.withValues(
//                                               alpha: 0.9,
//                                             ),
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ),
//                                     ),

//                                     const SizedBox(height: 20),

//                                     // Verify button
//                                     _buildGradientButton(
//                                       text: 'Verify & Login',
//                                       isLoading: authState.isLoading,
//                                       onPressed: () {
//                                         if (controllers.otp.text.length == 6) {
//                                           ref
//                                               .read(
//                                                 authControllerProvider.notifier,
//                                               )
//                                               .verifyOTP(
//                                                 otp: controllers.otp.text,
//                                               );
//                                         } else {
//                                           ScaffoldMessenger.of(
//                                             context,
//                                           ).showSnackBar(
//                                             SnackBar(
//                                               content: const Text(
//                                                 'Please enter a valid 6-digit OTP',
//                                               ),
//                                               backgroundColor: Colors.red,
//                                               behavior:
//                                                   SnackBarBehavior.floating,
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(12),
//                                               ),
//                                             ),
//                                           );
//                                         }
//                                       },
//                                     ),
//                                   ],

//                                   const SizedBox(height: 30),

//                                   // Change number (if OTP sent)
//                                   if (otpSent)
//                                     TextButton(
//                                       onPressed: () {
//                                         ref
//                                                 .read(
//                                                   phoneAuthOtpSentProvider
//                                                       .notifier,
//                                                 )
//                                                 .state =
//                                             false;
//                                         controllers.otp.clear();
//                                       },
//                                       child: const Text(
//                                         'Change Phone Number',
//                                         style: TextStyle(
//                                           color: Color(0xFF4ECDC4),
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
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
//     String? Function(String?)? validator,
//     int? maxLength,
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
//             validator: validator,
//             maxLength: maxLength,
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
//               counterText: '',
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

//   Widget _buildGradientButton({
//     required String text,
//     required bool isLoading,
//     required VoidCallback onPressed,
//   }) {
//     return SizedBox(
//       width: double.infinity,
//       height: 56,
//       child: ElevatedButton(
//         onPressed: isLoading ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           padding: EdgeInsets.zero,
//         ),
//         child: Ink(
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFF2C5F7C), Color(0xFF4ECDC4)],
//             ),
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFF2C5F7C).withValues(alpha: 0.4),
//                 blurRadius: 20,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: Container(
//             alignment: Alignment.center,
//             child: isLoading
//                 ? SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       strokeWidth: 2.5,
//                     ),
//                   )
//                 : Text(
//                     text,
//                     style: const TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// --------------------------------With Const Colors------------------------------------------------
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/phone_auth_screen_providers.dart';
import '../providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';

class PhoneAuthScreen extends ConsumerWidget {
  const PhoneAuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get controllers from provider
    final controllers = ref.watch(phoneAuthTextControllersProvider);
    final formKey = ref.watch(phoneAuthFormKeyProvider);

    // Get OTP sent state (determines which screen to show)
    final otpSent = ref.watch(phoneAuthOtpSentProvider);

    // Get auth state
    final authState = ref.watch(authControllerProvider);

    // Listen for state changes
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

      if (next.verificationId != null && !otpSent) {
        ref.read(phoneAuthOtpSentProvider.notifier).state = true;
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
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            if (otpSent) {
              // Go back to phone input
              ref.read(phoneAuthOtpSentProvider.notifier).state = false;
              controllers.otp.clear();
            } else {
              context.pop();
            }
          },
        ),
      ),
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

          // Content
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
                                    Text(
                                      otpSent ? 'Verify OTP' : 'Phone Login',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      otpSent
                                          ? 'Enter the 6-digit code sent to\n${controllers.phone.text}'
                                          : 'Sign in with your phone number',
                                      textAlign: TextAlign.center,
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
                                      if (!otpSent) ...[
                                        // Phone number field
                                        _buildInputField(
                                          controller: controllers.phone,
                                          label: 'Phone Number',
                                          hint: '10 digit mobile number',
                                          icon: Icons.phone,
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your phone number';
                                            }
                                            if (value.length < 10) {
                                              return 'Please enter a valid phone number';
                                            }
                                            return null;
                                          },
                                        ),

                                        const SizedBox(height: 30),

                                        // Send OTP button
                                        _buildGradientButton(
                                          text: 'Send OTP',
                                          isLoading: authState.isLoading,
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              String phoneNumber = controllers
                                                  .phone
                                                  .text
                                                  .trim();

                                              // Add country code if not present
                                              if (!phoneNumber.startsWith(
                                                '+',
                                              )) {
                                                phoneNumber = '+91$phoneNumber';
                                              }

                                              ref
                                                  .read(
                                                    authControllerProvider
                                                        .notifier,
                                                  )
                                                  .sendOTP(phoneNumber);
                                            }
                                          },
                                        ),
                                      ] else ...[
                                        // OTP field
                                        _buildInputField(
                                          controller: controllers.otp,
                                          label: 'OTP Code',
                                          hint: 'Enter 6-digit code',
                                          icon: Icons.lock_outline,
                                          keyboardType: TextInputType.number,
                                          maxLength: 6,
                                        ),

                                        const SizedBox(height: 12),

                                        // Resend OTP
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {
                                              String phoneNumber = controllers
                                                  .phone
                                                  .text
                                                  .trim();
                                              if (!phoneNumber.startsWith(
                                                '+',
                                              )) {
                                                phoneNumber = '+91$phoneNumber';
                                              }
                                              ref
                                                  .read(
                                                    authControllerProvider
                                                        .notifier,
                                                  )
                                                  .sendOTP(phoneNumber);
                                            },
                                            child: Text(
                                              'Resend OTP',
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 20),

                                        // Verify button
                                        _buildGradientButton(
                                          text: 'Verify & Login',
                                          isLoading: authState.isLoading,
                                          onPressed: () {
                                            if (controllers.otp.text.length ==
                                                6) {
                                              ref
                                                  .read(
                                                    authControllerProvider
                                                        .notifier,
                                                  )
                                                  .verifyOTP(
                                                    otp: controllers.otp.text,
                                                  );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                    'Please enter a valid 6-digit OTP',
                                                  ),
                                                  backgroundColor:
                                                      AppColors.errorDark,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],

                                      const SizedBox(height: 30),

                                      // Change number (if OTP sent)
                                      if (otpSent)
                                        TextButton(
                                          onPressed: () {
                                            ref
                                                    .read(
                                                      phoneAuthOtpSentProvider
                                                          .notifier,
                                                    )
                                                    .state =
                                                false;
                                            controllers.otp.clear();
                                          },
                                          child: const Text(
                                            'Change Phone Number',
                                            style: TextStyle(
                                              color: AppColors.secondary,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
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
    String? Function(String?)? validator,
    int? maxLength,
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
            validator: validator,
            maxLength: maxLength,
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
              counterText: '',
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

  Widget _buildGradientButton({
    required String text,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
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
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.textPrimary,
                      ),
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
