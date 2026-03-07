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
