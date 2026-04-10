import 'package:flutter/material.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';

class ServiceInfoBanner extends StatelessWidget {
  final String message;
  final Color? color;
  final IconData? icon;

  const ServiceInfoBanner({
    super.key,
    required this.message,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bannerColor = color ?? AppColors.secondary;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bannerColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bannerColor.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            icon ?? Icons.info_outline_rounded,
            size: 16,
            color: bannerColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: bannerColor.withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
