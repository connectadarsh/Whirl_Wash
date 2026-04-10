import 'package:flutter/material.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';

class OrderSectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const OrderSectionLabel({
    super.key,
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color ?? AppColors.secondary, size: 16),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
