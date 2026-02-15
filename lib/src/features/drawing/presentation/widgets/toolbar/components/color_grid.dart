import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/components/color_swatch_chip.dart';

class ColorGrid extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onSelected;
  final bool allowTransparent;

  const ColorGrid({
    super.key,
    required this.selectedColor,
    required this.onSelected,
    this.allowTransparent = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      ...AppColors.palette,
      if (allowTransparent) AppColors.transparent,
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.map((color) {
        final isSelected = color == selectedColor;
        return GestureDetector(
          onTap: () => onSelected(color),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.transparent,
                width: 2,
              ),
            ),
            child: ColorSwatchChip(
              color: color,
              borderColor: color == AppColors.transparent
                  ? AppColors.border
                  : AppColors.transparent,
              child: color == AppColors.transparent
                  ? const Center(
                      child: Icon(
                        LucideIcons.ban,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                    )
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
