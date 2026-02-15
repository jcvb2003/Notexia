import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

/// Seção de tons (5 variações de luminosidade).
/// Exibe os 5 tons da família de cores selecionada.
class TonesSection extends StatelessWidget {
  final List<Color> tones;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const TonesSection({
    super.key,
    required this.tones,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: tones.asMap().entries.map((entry) {
            final index = entry.key;
            final color = entry.value;
            final isSelected = color == selectedColor;

            return Padding(
              padding: EdgeInsets.only(right: index < tones.length - 1 ? 6 : 0),
              child: _ToneSwatch(
                color: color,
                isSelected: isSelected,
                onTap: () => onColorSelected(color),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'claro',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textMuted.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(width: 80),
            Text(
              'escuro',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textMuted.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ToneSwatch extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToneSwatch({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: isSelected ? 2.5 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: isSelected ? 6 : 2,
              spreadRadius: isSelected ? 1 : 0,
            ),
          ],
        ),
      ),
    );
  }
}
