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
