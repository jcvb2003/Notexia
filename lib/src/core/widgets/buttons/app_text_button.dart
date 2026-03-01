import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

class AppTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isDestructive;
  final EdgeInsetsGeometry? padding;

  const AppTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isDestructive = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor =
        isDestructive ? AppColors.danger : AppColors.primary;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor,
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppSizes.iconMedium),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
