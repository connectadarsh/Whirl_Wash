import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whirl_wash/features/home/data/models/fabric_type.dart';
import '../../../../../core/constants/app_colors.dart';

// =====================================================================
// SHOW FABRIC BOTTOM SHEET — call this from any screen
// =====================================================================

void showFabricBottomSheet({
  required BuildContext context,
  required WidgetRef ref,
  required String itemId,
  required String itemName,
  required String itemEmoji,
  required FabricType selected,
  required void Function(FabricType) onSelect,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => ServiceFabricSheet(
      itemName: itemName,
      itemEmoji: itemEmoji,
      selected: selected,
      onSelect: onSelect,
    ),
  );
}

// =====================================================================
// FABRIC SHEET — for catalogue items (shows item name/emoji in header)
// =====================================================================

class ServiceFabricSheet extends StatelessWidget {
  final String itemName;
  final String itemEmoji;
  final FabricType selected;
  final void Function(FabricType) onSelect;

  const ServiceFabricSheet({
    super.key,
    required this.itemName,
    required this.itemEmoji,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title row
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(itemEmoji, style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Select fabric type',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),
          Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
          const SizedBox(height: 8),

          // Fabric options
          ..._buildFabricOptions(context, selected, onSelect),
        ],
      ),
    );
  }
}

// =====================================================================
// CUSTOM FABRIC SHEET — for custom items (generic title)
// =====================================================================

class ServiceCustomFabricSheet extends StatelessWidget {
  final FabricType selected;
  final void Function(FabricType) onSelect;

  const ServiceCustomFabricSheet({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Select Fabric Type',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ..._buildFabricOptions(context, selected, onSelect),
        ],
      ),
    );
  }
}

// =====================================================================
// SHARED FABRIC OPTIONS BUILDER
// =====================================================================

List<Widget> _buildFabricOptions(
  BuildContext context,
  FabricType selected,
  void Function(FabricType) onSelect,
) {
  return FabricType.values.map((fabric) {
    final isSelected = selected == fabric;
    return GestureDetector(
      onTap: () {
        onSelect(fabric);
        Navigator.of(context).pop();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.secondary.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              fabric.icon,
              size: 20,
              color: isSelected
                  ? AppColors.secondary
                  : Colors.white.withValues(alpha: 0.55),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    fabric.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppColors.secondary
                          : Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  if (fabric == FabricType.dontKnow)
                    Text(
                      "We'll use standard settings",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: AppColors.secondary,
              ),
          ],
        ),
      ),
    );
  }).toList();
}
