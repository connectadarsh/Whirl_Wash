// // -------------------------------------------With Const Color---------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:whirl_wash/features/auth/presentation/providers/complete_profile_screen_providers.dart';
// import '../../../../core/constants/app_colors.dart';
// import 'dart:io';

// // Profile completion state
// class ProfileCompletionState {
//   final bool isLoading;
//   final String? error;
//   final String? selectedGender;
//   final File? profileImage;

//   ProfileCompletionState({
//     this.isLoading = false,
//     this.error,
//     this.selectedGender,
//     this.profileImage,
//   });

//   ProfileCompletionState copyWith({
//     bool? isLoading,
//     String? error,
//     String? selectedGender,
//     File? profileImage,
//   }) {
//     return ProfileCompletionState(
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//       selectedGender: selectedGender ?? this.selectedGender,
//       profileImage: profileImage ?? this.profileImage,
//     );
//   }
// }

// // Profile completion notifier
// class ProfileCompletionNotifier extends Notifier<ProfileCompletionState> {
//   @override
//   ProfileCompletionState build() {
//     return ProfileCompletionState();
//   }

//   void setGender(String gender) {
//     state = state.copyWith(selectedGender: gender);
//   }

//   void setProfileImage(File? image) {
//     state = state.copyWith(profileImage: image);
//   }

//   Future<bool> completeProfile({
//     required String name,
//     required String phone,
//     required String? gender,
//   }) async {
//     if (gender == null) {
//       state = state.copyWith(error: 'Please select your gender');
//       return false;
//     }

//     state = state.copyWith(isLoading: true, error: null);

//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) throw 'User not found';

//       // Update display name in Firebase Auth
//       await user.updateDisplayName(name);

//       // Save to Firestore
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//         'name': name,
//         'phone': phone,
//         'gender': gender,
//         'profileComplete': true,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true));

//       state = state.copyWith(isLoading: false);
//       return true;
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: 'Error: ${e.toString()}');
//       return false;
//     }
//   }

//   void clearError() {
//     state = state.copyWith(error: null);
//   }
// }

// final profileCompletionProvider =
//     NotifierProvider<ProfileCompletionNotifier, ProfileCompletionState>(() {
//       return ProfileCompletionNotifier();
//     });

// // =====================================================================
// // PURE RIVERPOD COMPLETE PROFILE SCREEN (ConsumerWidget)
// // =====================================================================

// class CompleteProfileScreen extends ConsumerWidget {
//   const CompleteProfileScreen({super.key});

//   String? _validateName(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your name';
//     }
//     if (value.length < 2) {
//       return 'Name must be at least 2 characters';
//     }
//     return null;
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

//   Future<void> _pickImage(BuildContext context) async {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF1F2937),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text(
//           'Choose Photo',
//           style: TextStyle(
//             color: AppColors.textPrimary,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   gradient: AppColors.primaryGradient,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(
//                   Icons.camera_alt,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//               title: const Text(
//                 'Camera',
//                 style: TextStyle(color: AppColors.textPrimary),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 // TODO: Implement camera
//               },
//             ),
//             ListTile(
//               leading: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   gradient: AppColors.primaryGradient,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(
//                   Icons.photo_library,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//               title: const Text(
//                 'Gallery',
//                 style: TextStyle(color: AppColors.textPrimary),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 // TODO: Implement gallery
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _handleComplete(
//     BuildContext context,
//     WidgetRef ref,
//     ProfileCompletionState profileState,
//     GlobalKey<FormState> formKey,
//     TextEditingController nameController,
//     TextEditingController phoneController,
//   ) async {
//     if (formKey.currentState!.validate()) {
//       final success = await ref
//           .read(profileCompletionProvider.notifier)
//           .completeProfile(
//             name: nameController.text.trim(),
//             phone: phoneController.text.trim(),
//             gender: profileState.selectedGender,
//           );

//       if (success && context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Profile completed successfully!'),
//             backgroundColor: AppColors.success,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );

//         // ✅ Navigate to home using Go Router
//         context.go('/home');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Get controllers from provider
//     final controllers = ref.watch(completeProfileTextControllersProvider);
//     final formKey = ref.watch(completeProfileFormKeyProvider);

//     // Get profile state
//     final profileState = ref.watch(profileCompletionProvider);

//     // Listen for errors
//     ref.listen(profileCompletionProvider, (previous, next) {
//       if (next.error != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(next.error!),
//             backgroundColor: AppColors.error,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//         ref.read(profileCompletionProvider.notifier).clearError();
//       }
//     });

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       body: Stack(
//         children: [
//           // Background Image (same as Login/Signup/PhoneAuth)
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/bg_signin.png',
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   decoration: const BoxDecoration(
//                     gradient: AppColors.backgroundGradient,
//                   ),
//                 );
//               },
//             ),
//           ),

//           // Dark Overlay
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(gradient: AppColors.overlayGradient),
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
//                   const SizedBox(height: 40),

//                   // Title Section (ANIMATED)
//                   Column(
//                         children: [
//                           const Text(
//                             'Complete Your Profile',
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Add your details to personalize experience',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 15,
//                               color: AppColors.textSecondary,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       )
//                       .animate()
//                       .fadeIn(duration: 600.ms, curve: Curves.easeOut)
//                       .slideY(begin: 0.2, end: 0, duration: 800.ms),

//                   const SizedBox(height: 40),

//                   // Profile Picture Section (ANIMATED)
//                   Column(
//                         children: [
//                           GestureDetector(
//                             onTap: () => _pickImage(context),
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   width: 120,
//                                   height: 120,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     gradient: profileState.profileImage == null
//                                         ? AppColors.primaryGradient
//                                         : null,
//                                     image: profileState.profileImage != null
//                                         ? DecorationImage(
//                                             image: FileImage(
//                                               profileState.profileImage!,
//                                             ),
//                                             fit: BoxFit.cover,
//                                           )
//                                         : null,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: AppColors.shadowSecondary,
//                                         blurRadius: 30,
//                                         offset: const Offset(0, 10),
//                                       ),
//                                     ],
//                                   ),
//                                   child: profileState.profileImage == null
//                                       ? const Icon(
//                                           Icons.person,
//                                           size: 60,
//                                           color: AppColors.textPrimary,
//                                         )
//                                       : null,
//                                 ),
//                                 Positioned(
//                                   bottom: 0,
//                                   right: 0,
//                                   child: Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       gradient: AppColors.buttonGradient,
//                                       shape: BoxShape.circle,
//                                       border: Border.all(
//                                         color: AppColors.borderSubtle,
//                                         width: 3,
//                                       ),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: AppColors.borderSubtle,
//                                           blurRadius: 8,
//                                           offset: const Offset(0, 4),
//                                         ),
//                                       ],
//                                     ),
//                                     child: const Icon(
//                                       Icons.camera_alt,
//                                       color: AppColors.textPrimary,
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             'Add Profile Picture',
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: AppColors.textDisabled,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       )
//                       .animate(delay: 200.ms)
//                       .fadeIn(duration: 600.ms)
//                       .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),

//                   const SizedBox(height: 40),

//                   // Form (ANIMATED)
//                   Form(
//                         key: formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Name field
//                             _buildInputField(
//                               controller: controllers.name,
//                               label: 'Full Name',
//                               hint: 'Enter your full name',
//                               icon: Icons.person_outline,
//                               validator: _validateName,
//                             ),

//                             const SizedBox(height: 18),

//                             // Phone field
//                             _buildInputField(
//                               controller: controllers.phone,
//                               label: 'Phone Number',
//                               hint: 'Enter your phone number',
//                               icon: Icons.phone_outlined,
//                               keyboardType: TextInputType.phone,
//                               validator: _validatePhone,
//                             ),

//                             const SizedBox(height: 24),

//                             // Gender Section
//                             Text(
//                               'Gender',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColors.textSecondary,
//                                 letterSpacing: 0.3,
//                               ),
//                             ),
//                             const SizedBox(height: 12),

//                             // Gender Radio Buttons
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: AppColors.glassLight,
//                                 borderRadius: BorderRadius.circular(14),
//                                 border: Border.all(
//                                   color: AppColors.glassBorder,
//                                   width: 1,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: AppColors.shadowGlass,
//                                     blurRadius: 10,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: Column(
//                                 children: [
//                                   _buildGenderOption(ref, 'Male', Icons.male),
//                                   Divider(
//                                     height: 1,
//                                     color: AppColors.glassSubtle,
//                                   ),
//                                   _buildGenderOption(
//                                     ref,
//                                     'Female',
//                                     Icons.female,
//                                   ),
//                                   Divider(
//                                     height: 1,
//                                     color: AppColors.glassSubtle,
//                                   ),
//                                   _buildGenderOption(
//                                     ref,
//                                     'Other',
//                                     Icons.transgender,
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             const SizedBox(height: 32),

//                             // Complete Profile Button
//                             SizedBox(
//                               width: double.infinity,
//                               height: 56,
//                               child: ElevatedButton(
//                                 onPressed: profileState.isLoading
//                                     ? null
//                                     : () => _handleComplete(
//                                         context,
//                                         ref,
//                                         profileState,
//                                         formKey,
//                                         controllers.name,
//                                         controllers.phone,
//                                       ),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: AppColors.transparent,
//                                   shadowColor: AppColors.transparent,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   padding: EdgeInsets.zero,
//                                 ),
//                                 child: Ink(
//                                   decoration: BoxDecoration(
//                                     gradient: AppColors.primaryGradient,
//                                     borderRadius: BorderRadius.circular(16),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: AppColors.shadowPrimary,
//                                         blurRadius: 20,
//                                         offset: const Offset(0, 8),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     child: profileState.isLoading
//                                         ? SizedBox(
//                                             width: 24,
//                                             height: 24,
//                                             child: CircularProgressIndicator(
//                                               valueColor:
//                                                   AlwaysStoppedAnimation<Color>(
//                                                     AppColors.textPrimary,
//                                                   ),
//                                               strokeWidth: 2.5,
//                                             ),
//                                           )
//                                         : const Text(
//                                             'Complete Profile',
//                                             style: TextStyle(
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.bold,
//                                               color: AppColors.textPrimary,
//                                               letterSpacing: 0.5,
//                                             ),
//                                           ),
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             const SizedBox(height: 32),
//                           ],
//                         ),
//                       )
//                       .animate(delay: 400.ms)
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
//     String? Function(String?)? validator,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: AppColors.textSecondary,
//             letterSpacing: 0.3,
//           ),
//         ),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(
//             color: AppColors.glassBackground,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: AppColors.glassBorder, width: 1),
//             boxShadow: [
//               BoxShadow(
//                 color: AppColors.shadowGlass,
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: TextFormField(
//             controller: controller,
//             keyboardType: keyboardType,
//             validator: validator,
//             style: const TextStyle(
//               fontSize: 15,
//               color: AppColors.textPrimary,
//               fontWeight: FontWeight.w500,
//             ),
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: TextStyle(
//                 color: AppColors.textHint,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//               ),
//               prefixIcon: Icon(icon, color: AppColors.iconPrimary, size: 22),
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
//                   color: AppColors.focusedBorder,
//                   width: 2,
//                 ),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(color: AppColors.error, width: 1.5),
//               ),
//               focusedErrorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(
//                   color: AppColors.errorDark,
//                   width: 2,
//                 ),
//               ),
//               filled: false,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//               errorStyle: const TextStyle(
//                 color: AppColors.textPrimary,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildGenderOption(WidgetRef ref, String gender, IconData icon) {
//     final profileState = ref.watch(profileCompletionProvider);
//     final isSelected = profileState.selectedGender == gender;

//     return InkWell(
//       onTap: () {
//         ref.read(profileCompletionProvider.notifier).setGender(gender);
//       },
//       borderRadius: BorderRadius.circular(14),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 gradient: isSelected ? AppColors.primaryGradient : null,
//                 color: isSelected ? null : AppColors.glassSubtle,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 icon,
//                 color: isSelected
//                     ? AppColors.textPrimary
//                     : AppColors.textDisabled,
//                 size: 22,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 gender,
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                   color: isSelected
//                       ? AppColors.textPrimary
//                       : AppColors.textTertiary,
//                 ),
//               ),
//             ),
//             Container(
//               width: 22,
//               height: 22,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: isSelected ? AppColors.secondary : AppColors.divider,
//                   width: 2,
//                 ),
//                 color: isSelected ? AppColors.secondary : AppColors.transparent,
//               ),
//               child: isSelected
//                   ? const Icon(
//                       Icons.check,
//                       size: 14,
//                       color: AppColors.textPrimary,
//                     )
//                   : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// --------------------------------------Gmap-------------------------------------------

// import 'dart:convert';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:io';

// import 'package:whirl_wash/features/auth/presentation/providers/complete_profile_screen_providers.dart';
// import '../../../../core/constants/app_colors.dart';

// // =====================================================================
// // PROFILE COMPLETION STATE
// // =====================================================================

// class ProfileCompletionState {
//   final bool isLoading;
//   final String? error;
//   final String? selectedGender;
//   final File? profileImage;

//   ProfileCompletionState({
//     this.isLoading = false,
//     this.error,
//     this.selectedGender,
//     this.profileImage,
//   });

//   ProfileCompletionState copyWith({
//     bool? isLoading,
//     String? error,
//     String? selectedGender,
//     File? profileImage,
//   }) {
//     return ProfileCompletionState(
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//       selectedGender: selectedGender ?? this.selectedGender,
//       profileImage: profileImage ?? this.profileImage,
//     );
//   }
// }

// // =====================================================================
// // PROFILE COMPLETION NOTIFIER
// // =====================================================================

// class ProfileCompletionNotifier extends Notifier<ProfileCompletionState> {
//   @override
//   ProfileCompletionState build() => ProfileCompletionState();

//   void setGender(String gender) =>
//       state = state.copyWith(selectedGender: gender);

//   void setProfileImage(File? image) =>
//       state = state.copyWith(profileImage: image);

//   Future<bool> completeProfile({
//     required String name,
//     required String phone,
//     required String? gender,
//     required String houseName,
//     required String address,
//     required double? latitude,
//     required double? longitude,
//   }) async {
//     state = state.copyWith(isLoading: true, error: null);

//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) throw 'User not found';

//       await user.updateDisplayName(name);

//       await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//         'name': name,
//         'phone': phone,
//         'gender': gender,
//         'houseName': houseName,
//         'address': address,
//         'latitude': latitude,
//         'longitude': longitude,
//         'profileComplete': true,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true));

//       state = state.copyWith(isLoading: false);
//       return true;
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: 'Error: ${e.toString()}');
//       return false;
//     }
//   }

//   void clearError() => state = state.copyWith(error: null);
// }

// final profileCompletionProvider =
//     NotifierProvider<ProfileCompletionNotifier, ProfileCompletionState>(
//       ProfileCompletionNotifier.new,
//     );

// // =====================================================================
// // COMPLETE PROFILE SCREEN
// // =====================================================================

// class CompleteProfileScreen extends ConsumerWidget {
//   const CompleteProfileScreen({super.key});

//   SnackBar _errorSnackBar(String message) {
//     return SnackBar(
//       content: Text(message),
//       backgroundColor: AppColors.error,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       duration: const Duration(seconds: 3),
//     );
//   }

//   Future<void> _handleComplete(
//     BuildContext context,
//     WidgetRef ref,
//     ProfileCompletionState profileState,
//     TextEditingController nameController,
//     TextEditingController phoneController,
//     TextEditingController houseNameController,
//     TextEditingController addressController,
//   ) async {
//     if (nameController.text.trim().isEmpty ||
//         nameController.text.trim().length < 2) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(_errorSnackBar('Please enter a valid full name'));
//       return;
//     }

//     if (phoneController.text.trim().isEmpty ||
//         phoneController.text.trim().length < 10) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(_errorSnackBar('Please enter a valid phone number'));
//       return;
//     }

//     if (profileState.selectedGender == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(_errorSnackBar('Please select your gender'));
//       return;
//     }

//     if (addressController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         _errorSnackBar('Please search and select your delivery address'),
//       );
//       return;
//     }

//     if (houseNameController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(_errorSnackBar('Please enter your house name / flat no'));
//       return;
//     }

//     final location = ref.read(completeProfileLocationProvider);

//     final success = await ref
//         .read(profileCompletionProvider.notifier)
//         .completeProfile(
//           name: nameController.text.trim(),
//           phone: phoneController.text.trim(),
//           gender: profileState.selectedGender,
//           houseName: houseNameController.text.trim(),
//           address: addressController.text.trim(),
//           latitude: location?.latitude,
//           longitude: location?.longitude,
//         );

//     if (success && context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Profile completed successfully!'),
//           backgroundColor: AppColors.success,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       );
//       context.go('/home');
//     }
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final controllers = ref.watch(completeProfileTextControllersProvider);
//     final profileState = ref.watch(profileCompletionProvider);

//     ref.listen(profileCompletionProvider, (previous, next) {
//       if (next.error != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(next.error!),
//             backgroundColor: AppColors.error,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//         ref.read(profileCompletionProvider.notifier).clearError();
//       }
//     });

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/bg_signin.png',
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Container(
//                 decoration: const BoxDecoration(
//                   gradient: AppColors.backgroundGradient,
//                 ),
//               ),
//             ),
//           ),
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(gradient: AppColors.overlayGradient),
//             ),
//           ),
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
//                   const SizedBox(height: 40),

//                   // Title
//                   Column(
//                         children: [
//                           const Text(
//                             'Complete Your Profile',
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Add your details to personalize experience',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 15,
//                               color: AppColors.textSecondary,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       )
//                       .animate()
//                       .fadeIn(duration: 600.ms, curve: Curves.easeOut)
//                       .slideY(begin: 0.2, end: 0, duration: 800.ms),

//                   const SizedBox(height: 40),

//                   // Profile Picture
//                   Column(
//                         children: [
//                           GestureDetector(
//                             onTap: () {},
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   width: 120,
//                                   height: 120,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     gradient: profileState.profileImage == null
//                                         ? AppColors.primaryGradient
//                                         : null,
//                                     image: profileState.profileImage != null
//                                         ? DecorationImage(
//                                             image: FileImage(
//                                               profileState.profileImage!,
//                                             ),
//                                             fit: BoxFit.cover,
//                                           )
//                                         : null,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: AppColors.shadowSecondary,
//                                         blurRadius: 30,
//                                         offset: const Offset(0, 10),
//                                       ),
//                                     ],
//                                   ),
//                                   child: profileState.profileImage == null
//                                       ? const Icon(
//                                           Icons.person,
//                                           size: 60,
//                                           color: AppColors.textPrimary,
//                                         )
//                                       : null,
//                                 ),
//                                 Positioned(
//                                   bottom: 0,
//                                   right: 0,
//                                   child: Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       gradient: AppColors.buttonGradient,
//                                       shape: BoxShape.circle,
//                                       border: Border.all(
//                                         color: AppColors.borderSubtle,
//                                         width: 3,
//                                       ),
//                                     ),
//                                     child: const Icon(
//                                       Icons.camera_alt,
//                                       color: AppColors.textPrimary,
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             'Add Profile Picture',
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: AppColors.textDisabled,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       )
//                       .animate(delay: 200.ms)
//                       .fadeIn(duration: 600.ms)
//                       .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),

//                   const SizedBox(height: 40),

//                   Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildInputField(
//                             controller: controllers.name,
//                             label: 'Full Name',
//                             hint: 'Enter your full name',
//                             icon: Icons.person_outline,
//                           ),

//                           const SizedBox(height: 18),

//                           _buildInputField(
//                             controller: controllers.phone,
//                             label: 'Phone Number',
//                             hint: 'Enter your phone number',
//                             icon: Icons.phone_outlined,
//                             keyboardType: TextInputType.phone,
//                           ),

//                           const SizedBox(height: 24),

//                           // Gender
//                           Text(
//                             'Gender',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.textSecondary,
//                               letterSpacing: 0.3,
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           Container(
//                             decoration: BoxDecoration(
//                               color: AppColors.glassLight,
//                               borderRadius: BorderRadius.circular(14),
//                               border: Border.all(
//                                 color: AppColors.glassBorder,
//                                 width: 1,
//                               ),
//                             ),
//                             child: Column(
//                               children: [
//                                 _buildGenderOption(ref, 'Male', Icons.male),
//                                 Divider(
//                                   height: 1,
//                                   color: AppColors.glassSubtle,
//                                 ),
//                                 _buildGenderOption(ref, 'Female', Icons.female),
//                                 Divider(
//                                   height: 1,
//                                   color: AppColors.glassSubtle,
//                                 ),
//                                 _buildGenderOption(
//                                   ref,
//                                   'Other',
//                                   Icons.transgender,
//                                 ),
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 24),

//                           // Address Section
//                           _AddressSection(controllers: controllers),

//                           const SizedBox(height: 32),

//                           // Complete Profile Button
//                           SizedBox(
//                             width: double.infinity,
//                             height: 56,
//                             child: ElevatedButton(
//                               onPressed: profileState.isLoading
//                                   ? null
//                                   : () => _handleComplete(
//                                       context,
//                                       ref,
//                                       profileState,
//                                       controllers.name,
//                                       controllers.phone,
//                                       controllers.houseName,
//                                       controllers.address,
//                                     ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.transparent,
//                                 shadowColor: AppColors.transparent,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                                 padding: EdgeInsets.zero,
//                               ),
//                               child: Ink(
//                                 decoration: BoxDecoration(
//                                   gradient: AppColors.primaryGradient,
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                                 child: Container(
//                                   alignment: Alignment.center,
//                                   child: profileState.isLoading
//                                       ? const SizedBox(
//                                           width: 24,
//                                           height: 24,
//                                           child: CircularProgressIndicator(
//                                             valueColor:
//                                                 AlwaysStoppedAnimation<Color>(
//                                                   AppColors.textPrimary,
//                                                 ),
//                                             strokeWidth: 2.5,
//                                           ),
//                                         )
//                                       : const Text(
//                                           'Complete Profile',
//                                           style: TextStyle(
//                                             fontSize: 17,
//                                             fontWeight: FontWeight.bold,
//                                             color: AppColors.textPrimary,
//                                             letterSpacing: 0.5,
//                                           ),
//                                         ),
//                                 ),
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 32),
//                         ],
//                       )
//                       .animate(delay: 400.ms)
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
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: AppColors.textSecondary,
//             letterSpacing: 0.3,
//           ),
//         ),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(
//             color: AppColors.glassBackground,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: AppColors.glassBorder, width: 1),
//           ),
//           child: TextField(
//             controller: controller,
//             keyboardType: keyboardType,
//             style: const TextStyle(
//               fontSize: 15,
//               color: AppColors.textPrimary,
//               fontWeight: FontWeight.w500,
//             ),
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: TextStyle(
//                 color: AppColors.textHint,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//               ),
//               prefixIcon: Icon(icon, color: AppColors.iconPrimary, size: 22),
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
//                   color: AppColors.focusedBorder,
//                   width: 2,
//                 ),
//               ),
//               filled: false,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildGenderOption(WidgetRef ref, String gender, IconData icon) {
//     final profileState = ref.watch(profileCompletionProvider);
//     final isSelected = profileState.selectedGender == gender;

//     return InkWell(
//       onTap: () =>
//           ref.read(profileCompletionProvider.notifier).setGender(gender),
//       borderRadius: BorderRadius.circular(14),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 gradient: isSelected ? AppColors.primaryGradient : null,
//                 color: isSelected ? null : AppColors.glassSubtle,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 icon,
//                 color: isSelected
//                     ? AppColors.textPrimary
//                     : AppColors.textDisabled,
//                 size: 22,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 gender,
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                   color: isSelected
//                       ? AppColors.textPrimary
//                       : AppColors.textTertiary,
//                 ),
//               ),
//             ),
//             Container(
//               width: 22,
//               height: 22,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: isSelected ? AppColors.secondary : AppColors.divider,
//                   width: 2,
//                 ),
//                 color: isSelected ? AppColors.secondary : AppColors.transparent,
//               ),
//               child: isSelected
//                   ? const Icon(
//                       Icons.check,
//                       size: 14,
//                       color: AppColors.textPrimary,
//                     )
//                   : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // =====================================================================
// // ADDRESS SECTION WIDGET
// // =====================================================================

// class _AddressSection extends ConsumerStatefulWidget {
//   final CompleteProfileTextControllers controllers;

//   const _AddressSection({required this.controllers});

//   @override
//   ConsumerState<_AddressSection> createState() => _AddressSectionState();
// }

// class _AddressSectionState extends ConsumerState<_AddressSection> {
//   GoogleMapController? _mapController;
//   final FocusNode _addressFocusNode = FocusNode();
//   Timer? _debounce;
//   List<Map<String, dynamic>> _suggestions = [];
//   bool _showSuggestions = false;
//   bool _isSearching = false;
//   bool _isSelectingSuggestion = false; // ← NEW

//   static const LatLng _defaultLocation = LatLng(11.2588, 75.7804);

//   @override
//   void initState() {
//     super.initState();
//     widget.controllers.address.addListener(_onAddressChanged);
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     _addressFocusNode.dispose();
//     widget.controllers.address.removeListener(_onAddressChanged);
//     _mapController?.dispose();
//     super.dispose();
//   }

//   // ── LISTENER ───────────────────────────────────────────────────────
//   void _onAddressChanged() {
//     if (_isSelectingSuggestion)
//       return; // ← NEW: skip when we set text programmatically

//     final text = widget.controllers.address.text;
//     if (text.trim().isEmpty) {
//       setState(() {
//         _suggestions = [];
//         _showSuggestions = false;
//       });
//       return;
//     }
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       _fetchSuggestions(text);
//     });
//   }

//   // ── FETCH SUGGESTIONS ──────────────────────────────────────────────
//   Future<void> _fetchSuggestions(String input) async {
//     if (input.trim().length < 3) return;

//     setState(() => _isSearching = true);

//     try {
//       final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
//       final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json'
//         '?input=${Uri.encodeComponent(input)}'
//         '&components=country:in'
//         '&key=$apiKey',
//       );

//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 'OK') {
//           final predictions = (data['predictions'] as List).map((p) {
//             return {
//               'description': p['description'] as String,
//               'placeId': p['place_id'] as String,
//             };
//           }).toList();

//           setState(() {
//             _suggestions = predictions;
//             _showSuggestions = predictions.isNotEmpty;
//           });
//         } else {
//           setState(() {
//             _suggestions = [];
//             _showSuggestions = false;
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint('Places API error: $e');
//     } finally {
//       setState(() => _isSearching = false);
//     }
//   }

//   // ── SELECT SUGGESTION ──────────────────────────────────────────────
//   Future<void> _selectSuggestion(Map<String, dynamic> suggestion) async {
//     final description = suggestion['description'] as String;
//     final placeId = suggestion['placeId'] as String;

//     // Block listener before setting text
//     _isSelectingSuggestion = true;
//     _debounce?.cancel();

//     // Fill address field
//     widget.controllers.address.text = description;
//     widget.controllers.address.selection = TextSelection.fromPosition(
//       TextPosition(offset: description.length),
//     );

//     // Hide suggestions
//     setState(() {
//       _suggestions = [];
//       _showSuggestions = false;
//     });

//     // Dismiss keyboard
//     _addressFocusNode.unfocus();

//     // Re-enable listener after a short delay
//     Future.delayed(const Duration(milliseconds: 100), () {
//       _isSelectingSuggestion = false;
//     });

//     // Fetch lat/lng from place details
//     try {
//       final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
//       final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/place/details/json'
//         '?place_id=$placeId'
//         '&fields=geometry'
//         '&key=$apiKey',
//       );

//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 'OK') {
//           final loc = data['result']['geometry']['location'];
//           final lat = (loc['lat'] as num).toDouble();
//           final lng = (loc['lng'] as num).toDouble();
//           final latLng = LatLng(lat, lng);

//           ref.read(completeProfileLocationProvider.notifier).state = latLng;
//           _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
//         }
//       }
//     } catch (e) {
//       debugPrint('Place details error: $e');
//     }
//   }

//   // ── CURRENT LOCATION ───────────────────────────────────────────────
//   Future<void> _useCurrentLocation() async {
//     try {
//       final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) return;

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) return;
//       }
//       if (permission == LocationPermission.deniedForever) return;

//       final position = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//         ),
//       );

//       final latLng = LatLng(position.latitude, position.longitude);

//       final placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         final p = placemarks.first;
//         final address = [
//           p.subLocality,
//           p.locality,
//           p.administrativeArea,
//           p.postalCode,
//         ].where((e) => e != null && e.isNotEmpty).join(', ');
//         widget.controllers.address.text = address;
//       }

//       ref.read(completeProfileLocationProvider.notifier).state = latLng;
//       _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
//     } catch (e) {
//       debugPrint('Current location error: $e');
//     }
//   }

//   // ── MAP TAP ────────────────────────────────────────────────────────
//   Future<void> _onMapTap(LatLng latLng) async {
//     ref.read(completeProfileLocationProvider.notifier).state = latLng;

//     try {
//       final placemarks = await placemarkFromCoordinates(
//         latLng.latitude,
//         latLng.longitude,
//       );
//       if (placemarks.isNotEmpty) {
//         final p = placemarks.first;
//         final address = [
//           p.subLocality,
//           p.locality,
//           p.administrativeArea,
//           p.postalCode,
//         ].where((e) => e != null && e.isNotEmpty).join(', ');
//         widget.controllers.address.text = address;
//       }
//     } catch (e) {
//       debugPrint('Reverse geocode error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final location = ref.watch(completeProfileLocationProvider);
//     final pinLocation = location ?? _defaultLocation;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Section header
//         Row(
//           children: [
//             Icon(
//               Icons.location_on_rounded,
//               color: AppColors.secondary,
//               size: 18,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               'Delivery Address',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textSecondary,
//                 letterSpacing: 0.3,
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 12),

//         // ── Search Field ───────────────────────────────────────────
//         Container(
//           decoration: BoxDecoration(
//             color: AppColors.glassBackground,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: AppColors.glassBorder, width: 1),
//           ),
//           child: TextField(
//             controller: widget.controllers.address,
//             focusNode: _addressFocusNode,
//             keyboardType: TextInputType.streetAddress,
//             textInputAction: TextInputAction.search,
//             style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
//             decoration: InputDecoration(
//               hintText: 'Search area / street...',
//               hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13),
//               prefixIcon: Icon(
//                 Icons.search_rounded,
//                 color: AppColors.iconPrimary,
//                 size: 20,
//               ),
//               suffixIcon: _isSearching
//                   ? Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: SizedBox(
//                         width: 16,
//                         height: 16,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: AppColors.secondary,
//                         ),
//                       ),
//                     )
//                   : widget.controllers.address.text.isNotEmpty
//                   ? IconButton(
//                       icon: Icon(
//                         Icons.clear,
//                         color: AppColors.textDisabled,
//                         size: 18,
//                       ),
//                       onPressed: () {
//                         widget.controllers.address.clear();
//                         setState(() {
//                           _suggestions = [];
//                           _showSuggestions = false;
//                         });
//                       },
//                     )
//                   : null,
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
//                   color: AppColors.focusedBorder,
//                   width: 2,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 14,
//               ),
//             ),
//           ),
//         ),

//         // ── Suggestions Dropdown ───────────────────────────────────
//         if (_showSuggestions && _suggestions.isNotEmpty)
//           Container(
//             margin: const EdgeInsets.only(top: 4),
//             decoration: BoxDecoration(
//               color: const Color(0xFF1A1A1A),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: _suggestions.asMap().entries.map((entry) {
//                 final index = entry.key;
//                 final suggestion = entry.value;
//                 final isLast = index == _suggestions.length - 1;
//                 return Column(
//                   children: [
//                     InkWell(
//                       onTap: () => _selectSuggestion(suggestion),
//                       borderRadius: BorderRadius.circular(12),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 12,
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.location_on_outlined,
//                               color: AppColors.secondary,
//                               size: 16,
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Text(
//                                 suggestion['description'] as String,
//                                 style: const TextStyle(
//                                   fontSize: 13,
//                                   color: AppColors.textPrimary,
//                                 ),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     if (!isLast)
//                       Divider(
//                         height: 1,
//                         color: Colors.white.withValues(alpha: 0.06),
//                         indent: 16,
//                         endIndent: 16,
//                       ),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),

//         const SizedBox(height: 12),

//         // ── Google Map ─────────────────────────────────────────────
//         ClipRRect(
//           borderRadius: BorderRadius.circular(14),
//           child: SizedBox(
//             height: 200,
//             child: GoogleMap(
//               initialCameraPosition: const CameraPosition(
//                 target: _defaultLocation,
//                 zoom: 14,
//               ),
//               onMapCreated: (controller) => _mapController = controller,
//               onTap: _onMapTap,
//               markers: {
//                 Marker(
//                   markerId: const MarkerId('selected'),
//                   position: pinLocation,
//                   draggable: true,
//                   onDragEnd: _onMapTap,
//                 ),
//               },
//               myLocationButtonEnabled: false,
//               zoomControlsEnabled: false,
//               mapToolbarEnabled: false,
//             ),
//           ),
//         ),

//         const SizedBox(height: 10),

//         // ── Use Current Location ───────────────────────────────────
//         GestureDetector(
//           onTap: _useCurrentLocation,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             decoration: BoxDecoration(
//               color: AppColors.secondary.withValues(alpha: 0.1),
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 color: AppColors.secondary.withValues(alpha: 0.3),
//               ),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.my_location_rounded,
//                   color: AppColors.secondary,
//                   size: 16,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Use My Current Location',
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: AppColors.secondary,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         const SizedBox(height: 16),

//         // ── House Name Field ───────────────────────────────────────
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'House Name / Flat No',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textSecondary,
//                 letterSpacing: 0.3,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Container(
//               decoration: BoxDecoration(
//                 color: AppColors.glassBackground,
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: AppColors.glassBorder, width: 1),
//               ),
//               child: TextField(
//                 controller: widget.controllers.houseName,
//                 keyboardType: TextInputType.text,
//                 textInputAction: TextInputAction.done,
//                 style: const TextStyle(
//                   color: AppColors.textPrimary,
//                   fontSize: 14,
//                 ),
//                 decoration: InputDecoration(
//                   hintText: 'e.g. Mango Villa, 2nd floor',
//                   hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13),
//                   prefixIcon: Icon(
//                     Icons.home_outlined,
//                     color: AppColors.iconPrimary,
//                     size: 20,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide: BorderSide.none,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide: BorderSide.none,
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide: BorderSide(
//                       color: AppColors.focusedBorder,
//                       width: 2,
//                     ),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// --------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'package:whirl_wash/features/auth/presentation/providers/complete_profile_screen_providers.dart';
import 'package:whirl_wash/features/auth/presentation/providers/profile%20completion_provider.dart';
import 'package:whirl_wash/features/auth/presentation/widgets/address_selection.dart';
import 'package:whirl_wash/features/auth/presentation/widgets/profile_avatar_picker.dart';
import 'package:whirl_wash/features/auth/presentation/widgets/gender_selector.dart';

class CompleteProfileScreen extends ConsumerWidget {
  const CompleteProfileScreen({super.key});

  SnackBar _errorSnackBar(String message) => SnackBar(
    content: Text(message),
    backgroundColor: AppColors.error,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    duration: const Duration(seconds: 3),
  );

  Future<void> _handleComplete(
    BuildContext context,
    WidgetRef ref,
    ProfileCompletionState profileState,
    CompleteProfileTextControllers controllers,
  ) async {
    final name = controllers.name.text.trim();
    final phone = controllers.phone.text.trim();
    final address = controllers.address.text.trim();
    final houseName = controllers.houseName.text.trim();

    if (name.isEmpty || name.length < 2) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_errorSnackBar('Please enter a valid full name'));
      return;
    }
    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_errorSnackBar('Please enter a valid phone number'));
      return;
    }
    if (profileState.selectedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_errorSnackBar('Please select your gender'));
      return;
    }
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        _errorSnackBar('Please search and select your delivery address'),
      );
      return;
    }
    if (houseName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_errorSnackBar('Please enter your house name / flat no'));
      return;
    }

    final location = ref.read(completeProfileLocationProvider);

    final success = await ref
        .read(profileCompletionProvider.notifier)
        .completeProfile(
          name: name,
          phone: phone,
          gender: profileState.selectedGender,
          houseName: houseName,
          address: address,
          latitude: location?.latitude,
          longitude: location?.longitude,
        );

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile completed successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllers = ref.watch(completeProfileTextControllersProvider);
    final profileState = ref.watch(profileCompletionProvider);

    ref.listen(profileCompletionProvider, (_, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        ref.read(profileCompletionProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          // ── Background ──────────────────────────────────────────
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_signin.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.backgroundGradient,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(gradient: AppColors.overlayGradient),
            ),
          ),

          // ── Content ─────────────────────────────────────────────
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
                  const SizedBox(height: 40),

                  // Title
                  Column(
                        children: [
                          const Text(
                            'Complete Your Profile',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your details to personalize experience',
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

                  const SizedBox(height: 40),

                  // Avatar
                  const ProfileAvatarPicker()
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 600.ms)
                      .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),

                  const SizedBox(height: 40),

                  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          _InputField(
                            controller: controllers.name,
                            label: 'Full Name',
                            hint: 'Enter your full name',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 18),

                          // Phone
                          _InputField(
                            controller: controllers.phone,
                            label: 'Phone Number',
                            hint: 'Enter your phone number',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 24),

                          // Gender
                          const GenderSelector(),
                          const SizedBox(height: 24),

                          // Address
                          AddressSection(controllers: controllers),
                          const SizedBox(height: 32),

                          // Submit Button
                          _SubmitButton(
                            isLoading: profileState.isLoading,
                            onTap: () => _handleComplete(
                              context,
                              ref,
                              profileState,
                              controllers,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      )
                      .animate(delay: 400.ms)
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
}

// =====================================================================
// INPUT FIELD
// =====================================================================

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
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
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
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
              filled: false,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// SUBMIT BUTTON
// =====================================================================

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _SubmitButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
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
          ),
          child: Container(
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.textPrimary,
                      ),
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'Complete Profile',
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
    );
  }
}
