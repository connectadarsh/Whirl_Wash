// ------------------------------------------------New--------------------------------------

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
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

// class CompleteProfileScreen extends ConsumerStatefulWidget {
//   final VoidCallback onComplete;

//   const CompleteProfileScreen({super.key, required this.onComplete});

//   @override
//   ConsumerState<CompleteProfileScreen> createState() =>
//       _CompleteProfileScreenState();
// }

// class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen>
//     with TickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();

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

//     // Pre-fill from Firebase Auth
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       _nameController.text = user.displayName ?? '';
//       _phoneController.text = user.phoneNumber ?? '';
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

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

//   Future<void> _pickImage() async {
//     // For now, just show dialog
//     // Add image_picker package to actually pick images
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF1F2937),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text(
//           'Choose Photo',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF2C5F7C), Color(0xFF4ECDC4)],
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.camera_alt, color: Colors.white),
//               ),
//               title: const Text(
//                 'Camera',
//                 style: TextStyle(color: Colors.white),
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
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF2C5F7C), Color(0xFF4ECDC4)],
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.photo_library, color: Colors.white),
//               ),
//               title: const Text(
//                 'Gallery',
//                 style: TextStyle(color: Colors.white),
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

//   Future<void> _handleComplete() async {
//     final profileState = ref.read(profileCompletionProvider);

//     if (_formKey.currentState!.validate()) {
//       final success = await ref
//           .read(profileCompletionProvider.notifier)
//           .completeProfile(
//             name: _nameController.text.trim(),
//             phone: _phoneController.text.trim(),
//             gender: profileState.selectedGender,
//           );

//       if (success && mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Profile completed successfully!'),
//             backgroundColor: const Color(0xFF4ECDC4),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//         widget.onComplete();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final profileState = ref.watch(profileCompletionProvider);

//     // Listen for errors
//     ref.listen(profileCompletionProvider, (previous, next) {
//       if (next.error != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(next.error!),
//             backgroundColor: Colors.red[400],
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
//       backgroundColor: Colors.black,
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       body: Stack(
//         children: [
//           // Background Image
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     const Color(0xFF2C5F7C).withValues(alpha: 0.5),
//                     Colors.black,
//                   ],
//                 ),
//               ),
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
//                   const SizedBox(height: 40),

//                   // Title Section
//                   FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: Column(
//                       children: [
//                         const Text(
//                           'Complete Your Profile',
//                           style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Add your details to personalize experience',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.white.withValues(alpha: 0.9),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 40),

//                   // Profile Picture Section
//                   SlideTransition(
//                     position: _slideAnimation,
//                     child: FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: Column(
//                         children: [
//                           GestureDetector(
//                             onTap: _pickImage,
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   width: 120,
//                                   height: 120,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     gradient: profileState.profileImage == null
//                                         ? const LinearGradient(
//                                             colors: [
//                                               Color(0xFF2C5F7C),
//                                               Color(0xFF4ECDC4),
//                                             ],
//                                           )
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
//                                         color: const Color(
//                                           0xFF4ECDC4,
//                                         ).withValues(alpha: 0.4),
//                                         blurRadius: 30,
//                                         offset: const Offset(0, 10),
//                                       ),
//                                     ],
//                                   ),
//                                   child: profileState.profileImage == null
//                                       ? const Icon(
//                                           Icons.person,
//                                           size: 60,
//                                           color: Colors.white,
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
//                                       gradient: const LinearGradient(
//                                         colors: [
//                                           Color(0xFF4ECDC4),
//                                           Color(0xFF44A08D),
//                                         ],
//                                       ),
//                                       shape: BoxShape.circle,
//                                       border: Border.all(
//                                         color: Colors.black.withValues(
//                                           alpha: 0.3,
//                                         ),
//                                         width: 3,
//                                       ),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black.withValues(
//                                             alpha: 0.3,
//                                           ),
//                                           blurRadius: 8,
//                                           offset: const Offset(0, 4),
//                                         ),
//                                       ],
//                                     ),
//                                     child: const Icon(
//                                       Icons.camera_alt,
//                                       color: Colors.white,
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
//                               color: Colors.white.withValues(alpha: 0.7),
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 40),

//                   // Form
//                   SlideTransition(
//                     position: _slideAnimation,
//                     child: FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Name field
//                             _buildInputField(
//                               controller: _nameController,
//                               label: 'Full Name',
//                               hint: 'Enter your full name',
//                               icon: Icons.person_outline,
//                               validator: _validateName,
//                             ),

//                             const SizedBox(height: 18),

//                             // Phone field
//                             _buildInputField(
//                               controller: _phoneController,
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
//                                 color: Colors.white.withValues(alpha: 0.9),
//                                 letterSpacing: 0.3,
//                               ),
//                             ),
//                             const SizedBox(height: 12),

//                             // Gender Radio Buttons
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withValues(alpha: 0.12),
//                                 borderRadius: BorderRadius.circular(14),
//                                 border: Border.all(
//                                   color: Colors.white.withValues(alpha: 0.2),
//                                   width: 1,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withValues(alpha: 0.1),
//                                     blurRadius: 10,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: Column(
//                                 children: [
//                                   _buildGenderOption('Male', Icons.male),
//                                   Divider(
//                                     height: 1,
//                                     color: Colors.white.withValues(alpha: 0.1),
//                                   ),
//                                   _buildGenderOption('Female', Icons.female),
//                                   Divider(
//                                     height: 1,
//                                     color: Colors.white.withValues(alpha: 0.1),
//                                   ),
//                                   _buildGenderOption(
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
//                                     : _handleComplete,
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
//                                     child: profileState.isLoading
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
//                                             'Complete Profile',
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

//                             const SizedBox(height: 32),
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

//   Widget _buildGenderOption(String gender, IconData icon) {
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
//                 gradient: isSelected
//                     ? const LinearGradient(
//                         colors: [Color(0xFF2C5F7C), Color(0xFF4ECDC4)],
//                       )
//                     : null,
//                 color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 icon,
//                 color: isSelected
//                     ? Colors.white
//                     : Colors.white.withValues(alpha: 0.7),
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
//                       ? Colors.white
//                       : Colors.white.withValues(alpha: 0.8),
//                 ),
//               ),
//             ),
//             Container(
//               width: 22,
//               height: 22,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: isSelected
//                       ? const Color(0xFF4ECDC4)
//                       : Colors.white.withValues(alpha: 0.3),
//                   width: 2,
//                 ),
//                 color: isSelected
//                     ? const Color(0xFF4ECDC4)
//                     : Colors.transparent,
//               ),
//               child: isSelected
//                   ? const Icon(Icons.check, size: 14, color: Colors.white)
//                   : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ---------------------------------------Stateless Call back---------------------------

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:whirl_wash/features/auth/presentation/providers/complete_profile_screen_providers.dart';
// import 'dart:io';

// // Profile completion state (keeping your existing state)
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

// // Profile completion notifier (keeping your existing notifier)
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
// // ANIMATION CONTROLLER PROVIDER (For fade/slide animations)
// // =====================================================================

// class CompleteProfileAnimations {
//   final AnimationController controller;
//   final Animation<double> fadeAnimation;
//   final Animation<Offset> slideAnimation;

//   CompleteProfileAnimations({
//     required this.controller,
//     required this.fadeAnimation,
//     required this.slideAnimation,
//   });

//   void dispose() {
//     controller.dispose();
//   }
// }

// // =====================================================================
// // PURE RIVERPOD COMPLETE PROFILE SCREEN (ConsumerWidget)
// // =====================================================================

// class CompleteProfileScreen extends ConsumerWidget {
//   final VoidCallback onComplete;

//   const CompleteProfileScreen({super.key, required this.onComplete});

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
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF2C5F7C), Color(0xFF4ECDC4)],
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.camera_alt, color: Colors.white),
//               ),
//               title: const Text(
//                 'Camera',
//                 style: TextStyle(color: Colors.white),
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
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF2C5F7C), Color(0xFF4ECDC4)],
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.photo_library, color: Colors.white),
//               ),
//               title: const Text(
//                 'Gallery',
//                 style: TextStyle(color: Colors.white),
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
//             backgroundColor: const Color(0xFF4ECDC4),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//         onComplete();
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
//             backgroundColor: Colors.red[400],
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
//       backgroundColor: Colors.black,
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       body: Stack(
//         children: [
//           // Background Image
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     const Color(0xFF2C5F7C).withValues(alpha: 0.5),
//                     Colors.black,
//                   ],
//                 ),
//               ),
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
//                   const SizedBox(height: 40),

//                   // Title Section (removed animations for pure Riverpod)
//                   Column(
//                     children: [
//                       const Text(
//                         'Complete Your Profile',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Add your details to personalize experience',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.white.withValues(alpha: 0.9),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 40),

//                   // Profile Picture Section
//                   Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () => _pickImage(context),
//                         child: Stack(
//                           children: [
//                             Container(
//                               width: 120,
//                               height: 120,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 gradient: profileState.profileImage == null
//                                     ? const LinearGradient(
//                                         colors: [
//                                           Color(0xFF2C5F7C),
//                                           Color(0xFF4ECDC4),
//                                         ],
//                                       )
//                                     : null,
//                                 image: profileState.profileImage != null
//                                     ? DecorationImage(
//                                         image: FileImage(
//                                           profileState.profileImage!,
//                                         ),
//                                         fit: BoxFit.cover,
//                                       )
//                                     : null,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: const Color(
//                                       0xFF4ECDC4,
//                                     ).withValues(alpha: 0.4),
//                                     blurRadius: 30,
//                                     offset: const Offset(0, 10),
//                                   ),
//                                 ],
//                               ),
//                               child: profileState.profileImage == null
//                                   ? const Icon(
//                                       Icons.person,
//                                       size: 60,
//                                       color: Colors.white,
//                                     )
//                                   : null,
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               right: 0,
//                               child: Container(
//                                 width: 40,
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                   gradient: const LinearGradient(
//                                     colors: [
//                                       Color(0xFF4ECDC4),
//                                       Color(0xFF44A08D),
//                                     ],
//                                   ),
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: Colors.black.withValues(alpha: 0.3),
//                                     width: 3,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withValues(
//                                         alpha: 0.3,
//                                       ),
//                                       blurRadius: 8,
//                                       offset: const Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: const Icon(
//                                   Icons.camera_alt,
//                                   color: Colors.white,
//                                   size: 20,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         'Add Profile Picture',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.white.withValues(alpha: 0.7),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 40),

//                   // Form
//                   Form(
//                     key: formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Name field
//                         _buildInputField(
//                           controller: controllers.name,
//                           label: 'Full Name',
//                           hint: 'Enter your full name',
//                           icon: Icons.person_outline,
//                           validator: _validateName,
//                         ),

//                         const SizedBox(height: 18),

//                         // Phone field
//                         _buildInputField(
//                           controller: controllers.phone,
//                           label: 'Phone Number',
//                           hint: 'Enter your phone number',
//                           icon: Icons.phone_outlined,
//                           keyboardType: TextInputType.phone,
//                           validator: _validatePhone,
//                         ),

//                         const SizedBox(height: 24),

//                         // Gender Section
//                         Text(
//                           'Gender',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white.withValues(alpha: 0.9),
//                             letterSpacing: 0.3,
//                           ),
//                         ),
//                         const SizedBox(height: 12),

//                         // Gender Radio Buttons
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white.withValues(alpha: 0.12),
//                             borderRadius: BorderRadius.circular(14),
//                             border: Border.all(
//                               color: Colors.white.withValues(alpha: 0.2),
//                               width: 1,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withValues(alpha: 0.1),
//                                 blurRadius: 10,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               _buildGenderOption(ref, 'Male', Icons.male),
//                               Divider(
//                                 height: 1,
//                                 color: Colors.white.withValues(alpha: 0.1),
//                               ),
//                               _buildGenderOption(ref, 'Female', Icons.female),
//                               Divider(
//                                 height: 1,
//                                 color: Colors.white.withValues(alpha: 0.1),
//                               ),
//                               _buildGenderOption(
//                                 ref,
//                                 'Other',
//                                 Icons.transgender,
//                               ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 32),

//                         // Complete Profile Button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 56,
//                           child: ElevatedButton(
//                             onPressed: profileState.isLoading
//                                 ? null
//                                 : () => _handleComplete(
//                                     context,
//                                     ref,
//                                     profileState,
//                                     formKey,
//                                     controllers.name,
//                                     controllers.phone,
//                                   ),
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
//                                 child: profileState.isLoading
//                                     ? const SizedBox(
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
//                                         'Complete Profile',
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

//                         const SizedBox(height: 32),
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
//                 gradient: isSelected
//                     ? const LinearGradient(
//                         colors: [Color(0xFF2C5F7C), Color(0xFF4ECDC4)],
//                       )
//                     : null,
//                 color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 icon,
//                 color: isSelected
//                     ? Colors.white
//                     : Colors.white.withValues(alpha: 0.7),
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
//                       ? Colors.white
//                       : Colors.white.withValues(alpha: 0.8),
//                 ),
//               ),
//             ),
//             Container(
//               width: 22,
//               height: 22,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: isSelected
//                       ? const Color(0xFF4ECDC4)
//                       : Colors.white.withValues(alpha: 0.3),
//                   width: 2,
//                 ),
//                 color: isSelected
//                     ? const Color(0xFF4ECDC4)
//                     : Colors.transparent,
//               ),
//               child: isSelected
//                   ? const Icon(Icons.check, size: 14, color: Colors.white)
//                   : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// --------------------------------------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:go_router/go_router.dart';
// import 'package:whirl_wash/features/auth/presentation/providers/complete_profile_screen_providers.dart';
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
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF2C5F7C), Color(0xFF4ECDC4)],
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.camera_alt, color: Colors.white),
//               ),
//               title: const Text(
//                 'Camera',
//                 style: TextStyle(color: Colors.white),
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
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF2C5F7C), Color(0xFF4ECDC4)],
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.photo_library, color: Colors.white),
//               ),
//               title: const Text(
//                 'Gallery',
//                 style: TextStyle(color: Colors.white),
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
//             backgroundColor: const Color(0xFF4ECDC4),
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
//             backgroundColor: Colors.red[400],
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
//       backgroundColor: Colors.black,
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
//                   const SizedBox(height: 40),

//                   // Title Section
//                   Column(
//                     children: [
//                       const Text(
//                         'Complete Your Profile',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Add your details to personalize experience',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.white.withValues(alpha: 0.9),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 40),

//                   // Profile Picture Section
//                   Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () => _pickImage(context),
//                         child: Stack(
//                           children: [
//                             Container(
//                               width: 120,
//                               height: 120,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 gradient: profileState.profileImage == null
//                                     ? const LinearGradient(
//                                         colors: [
//                                           Color(0xFF2C5F7C),
//                                           Color(0xFF4ECDC4),
//                                         ],
//                                       )
//                                     : null,
//                                 image: profileState.profileImage != null
//                                     ? DecorationImage(
//                                         image: FileImage(
//                                           profileState.profileImage!,
//                                         ),
//                                         fit: BoxFit.cover,
//                                       )
//                                     : null,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: const Color(
//                                       0xFF4ECDC4,
//                                     ).withValues(alpha: 0.4),
//                                     blurRadius: 30,
//                                     offset: const Offset(0, 10),
//                                   ),
//                                 ],
//                               ),
//                               child: profileState.profileImage == null
//                                   ? const Icon(
//                                       Icons.person,
//                                       size: 60,
//                                       color: Colors.white,
//                                     )
//                                   : null,
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               right: 0,
//                               child: Container(
//                                 width: 40,
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                   gradient: const LinearGradient(
//                                     colors: [
//                                       Color(0xFF4ECDC4),
//                                       Color(0xFF44A08D),
//                                     ],
//                                   ),
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: Colors.black.withValues(alpha: 0.3),
//                                     width: 3,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withValues(
//                                         alpha: 0.3,
//                                       ),
//                                       blurRadius: 8,
//                                       offset: const Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: const Icon(
//                                   Icons.camera_alt,
//                                   color: Colors.white,
//                                   size: 20,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         'Add Profile Picture',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.white.withValues(alpha: 0.7),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 40),

//                   // Form
//                   Form(
//                     key: formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Name field
//                         _buildInputField(
//                           controller: controllers.name,
//                           label: 'Full Name',
//                           hint: 'Enter your full name',
//                           icon: Icons.person_outline,
//                           validator: _validateName,
//                         ),

//                         const SizedBox(height: 18),

//                         // Phone field
//                         _buildInputField(
//                           controller: controllers.phone,
//                           label: 'Phone Number',
//                           hint: 'Enter your phone number',
//                           icon: Icons.phone_outlined,
//                           keyboardType: TextInputType.phone,
//                           validator: _validatePhone,
//                         ),

//                         const SizedBox(height: 24),

//                         // Gender Section
//                         Text(
//                           'Gender',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white.withValues(alpha: 0.9),
//                             letterSpacing: 0.3,
//                           ),
//                         ),
//                         const SizedBox(height: 12),

//                         // Gender Radio Buttons
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white.withValues(alpha: 0.12),
//                             borderRadius: BorderRadius.circular(14),
//                             border: Border.all(
//                               color: Colors.white.withValues(alpha: 0.2),
//                               width: 1,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withValues(alpha: 0.1),
//                                 blurRadius: 10,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               _buildGenderOption(ref, 'Male', Icons.male),
//                               Divider(
//                                 height: 1,
//                                 color: Colors.white.withValues(alpha: 0.1),
//                               ),
//                               _buildGenderOption(ref, 'Female', Icons.female),
//                               Divider(
//                                 height: 1,
//                                 color: Colors.white.withValues(alpha: 0.1),
//                               ),
//                               _buildGenderOption(
//                                 ref,
//                                 'Other',
//                                 Icons.transgender,
//                               ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 32),

//                         // Complete Profile Button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 56,
//                           child: ElevatedButton(
//                             onPressed: profileState.isLoading
//                                 ? null
//                                 : () => _handleComplete(
//                                     context,
//                                     ref,
//                                     profileState,
//                                     formKey,
//                                     controllers.name,
//                                     controllers.phone,
//                                   ),
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
//                                 child: profileState.isLoading
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
//                                         'Complete Profile',
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

//                         const SizedBox(height: 32),
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
//                 gradient: isSelected
//                     ? const LinearGradient(
//                         colors: [Color(0xFF2C5F7C), Color(0xFF4ECDC4)],
//                       )
//                     : null,
//                 color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 icon,
//                 color: isSelected
//                     ? Colors.white
//                     : Colors.white.withValues(alpha: 0.7),
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
//                       ? Colors.white
//                       : Colors.white.withValues(alpha: 0.8),
//                 ),
//               ),
//             ),
//             Container(
//               width: 22,
//               height: 22,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: isSelected
//                       ? const Color(0xFF4ECDC4)
//                       : Colors.white.withValues(alpha: 0.3),
//                   width: 2,
//                 ),
//                 color: isSelected
//                     ? const Color(0xFF4ECDC4)
//                     : Colors.transparent,
//               ),
//               child: isSelected
//                   ? const Icon(Icons.check, size: 14, color: Colors.white)
//                   : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ------------------------------------------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:whirl_wash/features/auth/presentation/providers/complete_profile_screen_providers.dart';
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
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF2C5F7C), Color(0xFF4ECDC4)],
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.camera_alt, color: Colors.white),
//               ),
//               title: const Text(
//                 'Camera',
//                 style: TextStyle(color: Colors.white),
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
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF2C5F7C), Color(0xFF4ECDC4)],
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.photo_library, color: Colors.white),
//               ),
//               title: const Text(
//                 'Gallery',
//                 style: TextStyle(color: Colors.white),
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
//             backgroundColor: const Color(0xFF4ECDC4),
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
//             backgroundColor: Colors.red[400],
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
//       backgroundColor: Colors.black,
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
//                   const SizedBox(height: 40),

//                   // Title Section (ANIMATED)
//                   Column(
//                         children: [
//                           const Text(
//                             'Complete Your Profile',
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Add your details to personalize experience',
//                             textAlign: TextAlign.center,
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
//                                         ? const LinearGradient(
//                                             colors: [
//                                               Color(0xFF2C5F7C),
//                                               Color(0xFF4ECDC4),
//                                             ],
//                                           )
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
//                                         color: const Color(
//                                           0xFF4ECDC4,
//                                         ).withValues(alpha: 0.4),
//                                         blurRadius: 30,
//                                         offset: const Offset(0, 10),
//                                       ),
//                                     ],
//                                   ),
//                                   child: profileState.profileImage == null
//                                       ? const Icon(
//                                           Icons.person,
//                                           size: 60,
//                                           color: Colors.white,
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
//                                       gradient: const LinearGradient(
//                                         colors: [
//                                           Color(0xFF4ECDC4),
//                                           Color(0xFF44A08D),
//                                         ],
//                                       ),
//                                       shape: BoxShape.circle,
//                                       border: Border.all(
//                                         color: Colors.black.withValues(
//                                           alpha: 0.3,
//                                         ),
//                                         width: 3,
//                                       ),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black.withValues(
//                                             alpha: 0.3,
//                                           ),
//                                           blurRadius: 8,
//                                           offset: const Offset(0, 4),
//                                         ),
//                                       ],
//                                     ),
//                                     child: const Icon(
//                                       Icons.camera_alt,
//                                       color: Colors.white,
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
//                               color: Colors.white.withValues(alpha: 0.7),
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
//                                 color: Colors.white.withValues(alpha: 0.9),
//                                 letterSpacing: 0.3,
//                               ),
//                             ),
//                             const SizedBox(height: 12),

//                             // Gender Radio Buttons
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withValues(alpha: 0.12),
//                                 borderRadius: BorderRadius.circular(14),
//                                 border: Border.all(
//                                   color: Colors.white.withValues(alpha: 0.2),
//                                   width: 1,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withValues(alpha: 0.1),
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
//                                     color: Colors.white.withValues(alpha: 0.1),
//                                   ),
//                                   _buildGenderOption(
//                                     ref,
//                                     'Female',
//                                     Icons.female,
//                                   ),
//                                   Divider(
//                                     height: 1,
//                                     color: Colors.white.withValues(alpha: 0.1),
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
//                                     child: profileState.isLoading
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
//                                             'Complete Profile',
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
//                 gradient: isSelected
//                     ? const LinearGradient(
//                         colors: [Color(0xFF2C5F7C), Color(0xFF4ECDC4)],
//                       )
//                     : null,
//                 color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 icon,
//                 color: isSelected
//                     ? Colors.white
//                     : Colors.white.withValues(alpha: 0.7),
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
//                       ? Colors.white
//                       : Colors.white.withValues(alpha: 0.8),
//                 ),
//               ),
//             ),
//             Container(
//               width: 22,
//               height: 22,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: isSelected
//                       ? const Color(0xFF4ECDC4)
//                       : Colors.white.withValues(alpha: 0.3),
//                   width: 2,
//                 ),
//                 color: isSelected
//                     ? const Color(0xFF4ECDC4)
//                     : Colors.transparent,
//               ),
//               child: isSelected
//                   ? const Icon(Icons.check, size: 14, color: Colors.white)
//                   : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// -------------------------------------------With Const Color---------------------------------------------
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:whirl_wash/features/auth/presentation/providers/complete_profile_screen_providers.dart';
import '../../../../core/constants/app_colors.dart';
import 'dart:io';

// Profile completion state
class ProfileCompletionState {
  final bool isLoading;
  final String? error;
  final String? selectedGender;
  final File? profileImage;

  ProfileCompletionState({
    this.isLoading = false,
    this.error,
    this.selectedGender,
    this.profileImage,
  });

  ProfileCompletionState copyWith({
    bool? isLoading,
    String? error,
    String? selectedGender,
    File? profileImage,
  }) {
    return ProfileCompletionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedGender: selectedGender ?? this.selectedGender,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

// Profile completion notifier
class ProfileCompletionNotifier extends Notifier<ProfileCompletionState> {
  @override
  ProfileCompletionState build() {
    return ProfileCompletionState();
  }

  void setGender(String gender) {
    state = state.copyWith(selectedGender: gender);
  }

  void setProfileImage(File? image) {
    state = state.copyWith(profileImage: image);
  }

  Future<bool> completeProfile({
    required String name,
    required String phone,
    required String? gender,
  }) async {
    if (gender == null) {
      state = state.copyWith(error: 'Please select your gender');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'User not found';

      // Update display name in Firebase Auth
      await user.updateDisplayName(name);

      // Save to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'phone': phone,
        'gender': gender,
        'profileComplete': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error: ${e.toString()}');
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final profileCompletionProvider =
    NotifierProvider<ProfileCompletionNotifier, ProfileCompletionState>(() {
      return ProfileCompletionNotifier();
    });

// =====================================================================
// PURE RIVERPOD COMPLETE PROFILE SCREEN (ConsumerWidget)
// =====================================================================

class CompleteProfileScreen extends ConsumerWidget {
  const CompleteProfileScreen({super.key});

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  Future<void> _pickImage(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Choose Photo',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: AppColors.textPrimary,
                ),
              ),
              title: const Text(
                'Camera',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement camera
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.photo_library,
                  color: AppColors.textPrimary,
                ),
              ),
              title: const Text(
                'Gallery',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement gallery
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleComplete(
    BuildContext context,
    WidgetRef ref,
    ProfileCompletionState profileState,
    GlobalKey<FormState> formKey,
    TextEditingController nameController,
    TextEditingController phoneController,
  ) async {
    if (formKey.currentState!.validate()) {
      final success = await ref
          .read(profileCompletionProvider.notifier)
          .completeProfile(
            name: nameController.text.trim(),
            phone: phoneController.text.trim(),
            gender: profileState.selectedGender,
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

        // ✅ Navigate to home using Go Router
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get controllers from provider
    final controllers = ref.watch(completeProfileTextControllersProvider);
    final formKey = ref.watch(completeProfileFormKeyProvider);

    // Get profile state
    final profileState = ref.watch(profileCompletionProvider);

    // Listen for errors
    ref.listen(profileCompletionProvider, (previous, next) {
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
          // Background Image (same as Login/Signup/PhoneAuth)
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
                  const SizedBox(height: 40),

                  // Title Section (ANIMATED)
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

                  // Profile Picture Section (ANIMATED)
                  Column(
                        children: [
                          GestureDetector(
                            onTap: () => _pickImage(context),
                            child: Stack(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: profileState.profileImage == null
                                        ? AppColors.primaryGradient
                                        : null,
                                    image: profileState.profileImage != null
                                        ? DecorationImage(
                                            image: FileImage(
                                              profileState.profileImage!,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.shadowSecondary,
                                        blurRadius: 30,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: profileState.profileImage == null
                                      ? const Icon(
                                          Icons.person,
                                          size: 60,
                                          color: AppColors.textPrimary,
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.buttonGradient,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.borderSubtle,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.borderSubtle,
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: AppColors.textPrimary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Add Profile Picture',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textDisabled,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 600.ms)
                      .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),

                  const SizedBox(height: 40),

                  // Form (ANIMATED)
                  Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name field
                            _buildInputField(
                              controller: controllers.name,
                              label: 'Full Name',
                              hint: 'Enter your full name',
                              icon: Icons.person_outline,
                              validator: _validateName,
                            ),

                            const SizedBox(height: 18),

                            // Phone field
                            _buildInputField(
                              controller: controllers.phone,
                              label: 'Phone Number',
                              hint: 'Enter your phone number',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: _validatePhone,
                            ),

                            const SizedBox(height: 24),

                            // Gender Section
                            Text(
                              'Gender',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Gender Radio Buttons
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.glassLight,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: AppColors.glassBorder,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadowGlass,
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  _buildGenderOption(ref, 'Male', Icons.male),
                                  Divider(
                                    height: 1,
                                    color: AppColors.glassSubtle,
                                  ),
                                  _buildGenderOption(
                                    ref,
                                    'Female',
                                    Icons.female,
                                  ),
                                  Divider(
                                    height: 1,
                                    color: AppColors.glassSubtle,
                                  ),
                                  _buildGenderOption(
                                    ref,
                                    'Other',
                                    Icons.transgender,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Complete Profile Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: profileState.isLoading
                                    ? null
                                    : () => _handleComplete(
                                        context,
                                        ref,
                                        profileState,
                                        formKey,
                                        controllers.name,
                                        controllers.phone,
                                      ),
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
                                    child: profileState.isLoading
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
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
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

  Widget _buildGenderOption(WidgetRef ref, String gender, IconData icon) {
    final profileState = ref.watch(profileCompletionProvider);
    final isSelected = profileState.selectedGender == gender;

    return InkWell(
      onTap: () {
        ref.read(profileCompletionProvider.notifier).setGender(gender);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected ? null : AppColors.glassSubtle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textDisabled,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                gender,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textTertiary,
                ),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.secondary : AppColors.divider,
                  width: 2,
                ),
                color: isSelected ? AppColors.secondary : AppColors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: AppColors.textPrimary,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
