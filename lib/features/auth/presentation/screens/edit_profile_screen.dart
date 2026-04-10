import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'package:whirl_wash/features/auth/presentation/providers/edit_profile_providers.dart';
import 'package:whirl_wash/features/auth/presentation/providers/profile_completion_provider.dart';
import 'package:whirl_wash/features/auth/presentation/widgets/address_section.dart';
import 'package:whirl_wash/features/auth/presentation/widgets/gender_selector.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  SnackBar _errorSnackBar(String message) => SnackBar(
    content: Text(message),
    backgroundColor: AppColors.error,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    duration: const Duration(seconds: 3),
  );

  Future<void> _handleSave(
    BuildContext context,
    WidgetRef ref,
    ProfileCompletionState profileState,
  ) async {
    final controllersAsync = ref.read(editProfileTextControllersProvider);
    final controllers = controllersAsync.value;
    if (controllers == null) return;

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
    if (address.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_errorSnackBar('Please select your delivery address'));
      return;
    }
    if (houseName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_errorSnackBar('Please enter your house name / flat no'));
      return;
    }

    final location = ref.read(editProfileLocationStateProvider);

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
          content: const Text('Profile updated successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllersAsync = ref.watch(editProfileTextControllersProvider);
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: controllersAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.secondary),
        ),
        error: (e, _) => Center(
          child: Text(
            'Failed to load profile',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          ),
        ),
        data: (controllers) => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: MediaQuery.of(context).padding.top + 80,
              bottom: MediaQuery.of(context).padding.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Name ──────────────────────────────────────────
                _InputField(
                  controller: controllers.name,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 18),

                // ── Phone ─────────────────────────────────────────
                _InputField(
                  controller: controllers.phone,
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),

                // ── Gender ────────────────────────────────────────
                const GenderSelector(),
                const SizedBox(height: 24),

                // ── Address ───────────────────────────────────────
                AddressSection(
                  controllers: controllers,
                  locationProvider: editProfileLocationStateProvider,
                ),
                const SizedBox(height: 32),

                // ── Save Button ───────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: profileState.isLoading
                        ? null
                        : () => _handleSave(context, ref, profileState),
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
                        child: profileState.isLoading
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
                                'Save Changes',
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
          ),
        ),
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
