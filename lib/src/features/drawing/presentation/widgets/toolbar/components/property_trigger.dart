import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/components/color_swatch_chip.dart';

class PropertyTrigger extends StatelessWidget {
  final String label;
  final Color color;
  final bool isNone;
  final VoidCallback onTap;

  const PropertyTrigger({
    super.key,
    required this.label,
    required this.color,
    this.isNone = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          boxShadow: AppShadows.subtle,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorSwatchChip(
              color: color,
              borderColor: AppColors.border,
              child: isNone
                  ? const Center(
                      child: Icon(
                        LucideIcons.ban,
                        size: 10,
                        color: AppColors.textMuted,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.labelMedium),
            const Icon(
              LucideIcons.chevronDown,
              size: 14,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
