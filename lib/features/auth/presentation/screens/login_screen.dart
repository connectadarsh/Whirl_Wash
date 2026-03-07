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
                                          // onPressed: () {
                                          //   ScaffoldMessenger.of(
                                          //     context,
                                          //   ).showSnackBar(
                                          //     const SnackBar(
                                          //       content: Text(
                                          //         'Feature coming soon',
                                          //       ),
                                          //     ),
                                          //   );

                                          // },
                                          onPressed: () =>
                                              context.push('/forgot-password'),
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
