import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'package:whirl_wash/features/auth/data/models/user_model.dart';
import 'package:whirl_wash/features/auth/presentation/providers/auth_provider.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserData = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    AppColors.secondary.withValues(alpha: 0.25),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.06),
                    width: 1,
                  ),
                ),
              ),
              child: const FlexibleSpaceBar(
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: false,
                titlePadding: EdgeInsets.only(left: 20, bottom: 16),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // ── Header ──────────────────────────────────────
                  Center(
                    child: currentUserData.when(
                      data: (userData) => _ProfileHeader(userData: userData),
                      loading: () => const _ProfileHeaderSkeleton(),
                      error: (_, __) => _ProfileHeader(
                        userData: null,
                        fallbackName:
                            FirebaseAuth.instance.currentUser?.displayName,
                        fallbackEmail: FirebaseAuth.instance.currentUser?.email,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Delivery Address Card ────────────────────────
                  currentUserData.when(
                    data: (userData) =>
                        _DeliveryAddressCard(userData: userData),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 24),

                  // ── 2-Column Grid ────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _GridCard(
                          icon: Icons.edit_rounded,
                          label: 'Edit Profile',
                          subtitle: 'Update info',
                          onTap: () => context.pushNamed('edit-profile'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _GridCard(
                          icon: Icons.help_outline_rounded,
                          label: 'Help & Support',
                          subtitle: 'Get help',
                          onTap: () =>
                              _showComingSoon(context, 'Help & Support'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Settings Section ─────────────────────────────
                  Text(
                    'SETTINGS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.4),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Column(
                      children: [
                        _SettingsRow(
                          icon: Icons.privacy_tip_outlined,
                          iconColor: Colors.blue,
                          label: 'Privacy Policy',
                          subtitle: 'How we collect & use your data',
                          onTap: () =>
                              _showComingSoon(context, 'Privacy Policy'),
                        ),
                        _SettingsDivider(),
                        _SettingsRow(
                          icon: Icons.description_outlined,
                          iconColor: Colors.purple,
                          label: 'Terms & Conditions',
                          subtitle: 'Rules & guidelines for using the app',
                          onTap: () =>
                              _showComingSoon(context, 'Terms & Conditions'),
                        ),
                        _SettingsDivider(),
                        _SettingsRow(
                          icon: Icons.info_outline_rounded,
                          iconColor: Colors.orange,
                          label: 'About',
                          subtitle: 'Version 1.0.0 · Build info & credits',
                          onTap: () => _showComingSoon(context, 'About'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Logout Card ──────────────────────────────────
                  const _LogoutButton(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label — Coming soon'),
        backgroundColor: Colors.grey[850],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// =====================================================================
// PROFILE HEADER
// =====================================================================

class _ProfileHeader extends StatelessWidget {
  final UserModel? userData;
  final String? fallbackName;
  final String? fallbackEmail;

  const _ProfileHeader({this.userData, this.fallbackName, this.fallbackEmail});

  @override
  Widget build(BuildContext context) {
    final name = userData?.name ?? fallbackName;
    final contact = userData?.email ?? userData?.phone ?? fallbackEmail;

    final initials = (name != null && name.isNotEmpty)
        ? name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.secondary.withValues(alpha: 0.6),
                AppColors.secondary,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          name ?? 'User',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        if (contact != null) ...[
          const SizedBox(height: 4),
          Text(
            contact,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ],
    );
  }
}

// =====================================================================
// DELIVERY ADDRESS CARD
// =====================================================================

class _DeliveryAddressCard extends StatelessWidget {
  final UserModel? userData;

  const _DeliveryAddressCard({this.userData});

  @override
  Widget build(BuildContext context) {
    final houseName = userData?.houseName;
    final address = userData?.address;

    if (address == null && houseName == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.location_on_rounded,
              color: AppColors.secondary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.45),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                if (houseName != null && houseName.isNotEmpty)
                  Text(
                    houseName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                if (address != null && address.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.55),
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// 2-COLUMN GRID CARD
// =====================================================================

class _GridCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _GridCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.secondary, size: 22),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// SETTINGS ROW
// =====================================================================

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withValues(alpha: 0.25),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Colors.white.withValues(alpha: 0.06),
      indent: 68,
    );
  }
}

// =====================================================================
// LOGOUT BUTTON
// =====================================================================

class _LogoutButton extends ConsumerWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return GestureDetector(
      onTap: authState.isLoading ? null : () => _showLogoutDialog(context, ref),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.logout_rounded,
                color: Colors.red[400],
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.red[400],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'You can always log back in anytime',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.red[400]!.withValues(alpha: 0.5),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Logout',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      await ref.read(authControllerProvider.notifier).signOut();
      if (context.mounted) context.go('/login');
    }
  }
}

// =====================================================================
// SKELETON LOADER
// =====================================================================

class _ProfileHeaderSkeleton extends StatelessWidget {
  const _ProfileHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: 140,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 200,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ],
    );
  }
}
