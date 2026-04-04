import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'package:whirl_wash/features/auth/presentation/providers/profile%20completion_provider.dart';

class GenderSelector extends ConsumerWidget {
  const GenderSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Container(
          decoration: BoxDecoration(
            color: AppColors.glassLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          child: Column(
            children: [
              _GenderOption(gender: 'Male', icon: Icons.male),
              Divider(height: 1, color: AppColors.glassSubtle),
              _GenderOption(gender: 'Female', icon: Icons.female),
              Divider(height: 1, color: AppColors.glassSubtle),
              _GenderOption(gender: 'Other', icon: Icons.transgender),
            ],
          ),
        ),
      ],
    );
  }
}

class _GenderOption extends ConsumerWidget {
  final String gender;
  final IconData icon;

  const _GenderOption({required this.gender, required this.icon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected =
        ref.watch(profileCompletionProvider).selectedGender == gender;

    return InkWell(
      onTap: () =>
          ref.read(profileCompletionProvider.notifier).setGender(gender),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
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
