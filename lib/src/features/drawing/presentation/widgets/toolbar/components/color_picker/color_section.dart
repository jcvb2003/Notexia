import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/open_color_palette.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

/// Seção de cores base (13 famílias + neutras).
/// Exibe um grid com a cor central de cada família.
class ColorSection extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final bool allowTransparent;

  const ColorSection({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.allowTransparent = false,
  });

  @override
  Widget build(BuildContext context) {
    // Cores base: tom médio (índice 2) de cada família
    final baseColors = OpenColorPalette.baseColors;

    // Cores neutras
    final neutralColors = [
      OpenColorPalette.black,
      OpenColorPalette.white,
      if (allowTransparent) OpenColorPalette.transparent,
    ];

    final allColors = [...baseColors, ...neutralColors];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: allColors.map((color) {
        final isSelected = color == selectedColor ||
            (OpenColorPalette.getTonesForColor(
                  selectedColor,
                )?.contains(color) ??
                false) ||
            (OpenColorPalette.getTonesForColor(
                  color,
                )?.contains(selectedColor) ??
                false);
        final isTransparent = color == OpenColorPalette.transparent;

        return _ColorSwatch(
          color: color,
          isSelected: isSelected,
          isTransparent: isTransparent,
          onTap: () => onColorSelected(color),
        );
      }).toList(),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final bool isTransparent;
  final VoidCallback onTap;

  const _ColorSwatch({
    required this.color,
    required this.isSelected,
    required this.isTransparent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isTransparent ? null : color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (color == OpenColorPalette.white || isTransparent)
                    ? AppColors.border
                    : Colors.transparent,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: isTransparent
            ? const Center(
                child: Icon(
                  LucideIcons.ban,
                  size: 16,
                  color: AppColors.textMuted,
                ),
              )
            : null,
      ),
    );
  }
}
