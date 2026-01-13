import 'package:flutter/material.dart';

/// App-wide color constants for WhirlWash
///
/// Usage: AppColors.primary, AppColors.glassBackground, etc.
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ============================================================
  // BRAND COLORS
  // ============================================================

  /// Primary brand color - Dark teal
  static const Color primary = Color(0xFF2C5F7C);

  /// Secondary brand color - Light teal
  static const Color secondary = Color(0xFF4ECDC4);

  /// Accent color - Green teal
  static const Color accent = Color(0xFF44A08D);

  // ============================================================
  // GLASS MORPHISM COLORS
  // ============================================================

  /// Glass background - Semi-transparent white
  static final Color glassBackground = Colors.white.withValues(alpha: 0.15);

  /// Glass border - Very transparent white
  static final Color glassBorder = Colors.white.withValues(alpha: 0.2);

  /// Glass light - Even more transparent (for lighter glass effects)
  static final Color glassLight = Colors.white.withValues(alpha: 0.12);

  /// Glass subtle - Minimal transparency (for very subtle effects)
  static final Color glassSubtle = Colors.white.withValues(alpha: 0.1);

  // ============================================================
  // OVERLAY COLORS (Dark backgrounds)
  // ============================================================

  /// Dark overlay - Top
  static final Color overlayDark1 = Colors.black.withValues(alpha: 0.72);

  /// Dark overlay - Bottom (slightly darker)
  static final Color overlayDark2 = Colors.black.withValues(alpha: 0.82);

  // ============================================================
  // TEXT COLORS
  // ============================================================

  /// Primary text - Pure white
  static const Color textPrimary = Colors.white;

  /// Secondary text - Slightly transparent white
  static final Color textSecondary = Colors.white.withValues(alpha: 0.9);

  /// Tertiary text - More transparent white
  static final Color textTertiary = Colors.white.withValues(alpha: 0.8);

  /// Hint text - Very transparent white
  static final Color textHint = Colors.white.withValues(alpha: 0.5);

  /// Disabled text - Subtle white
  static final Color textDisabled = Colors.white.withValues(alpha: 0.7);

  // ============================================================
  // DIVIDER COLORS
  // ============================================================

  /// Divider - Semi-transparent white
  static final Color divider = Colors.white.withValues(alpha: 0.3);

  // ============================================================
  // ICON COLORS
  // ============================================================

  /// Icon primary - Slightly transparent white
  static final Color iconPrimary = Colors.white.withValues(alpha: 0.8);

  /// Icon secondary - More transparent white
  static const Color iconSecondary = Colors.white70;

  // ============================================================
  // SHADOW COLORS
  // ============================================================

  /// Shadow - For glass effects
  static final Color shadowGlass = Colors.black.withValues(alpha: 0.1);

  /// Shadow - For buttons
  static final Color shadowButton = Colors.black.withValues(alpha: 0.15);

  /// Shadow - Primary button glow
  static final Color shadowPrimary = primary.withValues(alpha: 0.4);

  /// Shadow - Secondary button glow
  static final Color shadowSecondary = secondary.withValues(alpha: 0.4);

  // ============================================================
  // INTERACTION COLORS
  // ============================================================

  /// Splash color - For ripple effects
  static final Color splash = Colors.white.withValues(alpha: 0.2);

  /// Focused border - For input fields
  static final Color focusedBorder = Colors.white.withValues(alpha: 0.4);

  /// Border subtle - For containers
  static final Color borderSubtle = Colors.black.withValues(alpha: 0.3);

  // ============================================================
  // STATUS COLORS
  // ============================================================

  /// Error color
  static final Color error = Colors.red[300]!;

  /// Error dark
  static const Color errorDark = Colors.red;

  /// Success color
  static const Color success = secondary; // Using secondary teal

  // ============================================================
  // BACKGROUND COLORS
  // ============================================================

  /// Background - Pure black
  static const Color background = Colors.black;

  /// Transparent
  static const Color transparent = Colors.transparent;

  // ============================================================
  // GRADIENTS (Static helpers)
  // ============================================================

  /// Primary gradient (used for buttons, backgrounds)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
  );

  /// Primary gradient (left to right)
  static const LinearGradient primaryGradientHorizontal = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, secondary],
  );

  /// Background gradient (for fallback)
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  /// Overlay gradient (dark, top to bottom)
  static LinearGradient overlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [overlayDark1, overlayDark2],
  );

  /// Button gradient (profile picture, special buttons)
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [secondary, accent],
  );

  // ============================================================
  // HELPER METHODS
  // ============================================================

  /// Get color with custom alpha
  static Color withAlpha(Color color, double alpha) {
    return color.withValues(alpha: alpha);
  }
}
