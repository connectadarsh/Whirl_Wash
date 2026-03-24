import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class ServiceCircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool active;
  final bool filled;

  const ServiceCircleBtn({
    super.key,
    required this.icon,
    required this.onTap,
    required this.active,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: filled
              ? AppColors.secondary.withValues(alpha: active ? 0.2 : 0.08)
              : Colors.white.withValues(alpha: active ? 0.1 : 0.05),
          shape: BoxShape.circle,
          border: Border.all(
            color: filled
                ? AppColors.secondary.withValues(alpha: active ? 0.5 : 0.15)
                : Colors.white.withValues(alpha: active ? 0.2 : 0.08),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: filled
              ? AppColors.secondary.withValues(alpha: active ? 1.0 : 0.3)
              : Colors.white.withValues(alpha: active ? 0.8 : 0.25),
        ),
      ),
    );
  }
}
