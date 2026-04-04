import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';
import 'package:whirl_wash/features/auth/presentation/providers/profile%20completion_provider.dart';

class ProfileAvatarPicker extends ConsumerWidget {
  const ProfileAvatarPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileImage = ref.watch(profileCompletionProvider).profileImage;

    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: profileImage == null
                      ? AppColors.primaryGradient
                      : null,
                  image: profileImage != null
                      ? DecorationImage(
                          image: FileImage(profileImage),
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
                child: profileImage == null
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
                    border: Border.all(color: AppColors.borderSubtle, width: 3),
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
    );
  }
}
