import 'package:flutter/material.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';

class OrderAddressCard extends StatelessWidget {
  final String? houseName;
  final String? address;
  final bool isLoading;

  const OrderAddressCard({
    super.key,
    this.houseName,
    this.address,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.location_on_rounded,
              color: AppColors.secondary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: isLoading
                ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.secondary,
                    ),
                  )
                : address == null
                ? Text(
                    'No address saved. Please complete your profile.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red.withValues(alpha: 0.8),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (houseName != null && houseName!.isNotEmpty) ...[
                        Text(
                          houseName!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                      ],
                      Text(
                        address!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.55),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
