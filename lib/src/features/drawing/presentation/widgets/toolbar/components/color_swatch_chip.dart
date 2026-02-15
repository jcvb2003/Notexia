import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

class ColorSwatchChip extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final Widget? child;

  const ColorSwatchChip({
    super.key,
    required this.color,
    this.borderColor = AppColors.border,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}
