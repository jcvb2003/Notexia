import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

class AppIndicator extends StatelessWidget {
  final bool isActive;
  final double size;
  final Duration duration;

  const AppIndicator({
    super.key,
    required this.isActive,
    this.size = 4,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.primary : AppColors.border,
      ),
    );
  }
}
