import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/buttons/app_icon_button.dart';

class HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String tooltip;
  final bool isSelected;
  final double size;

  const HeaderIconButton({
    super.key,
    required this.icon,
    this.onTap,
    required this.tooltip,
    this.isSelected = false,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected ? AppColors.gray100 : AppColors.background;
    final iconColor = isSelected ? AppColors.gray700 : AppColors.textSecondary;

    return HoverAnimatedScale(
      tooltip: tooltip,
      onTap: onTap,
      builder: (context, isHovering) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isHovering ? AppColors.gray50 : bgColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: AppShadows.subtle,
          ),
          child: Icon(icon, size: 20, color: iconColor),
        );
      },
    );
  }
}
