import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/widgets.dart';

/// Item de menu reutilizável para sidebars, dropdowns e menus contextuais.
class AppMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const AppMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return HoverAnimatedScale(
      tooltip: null,
      onTap: onTap,
      hoverScale: 1.02,
      isActive: isSelected,
      activeScale: 1.02,
      builder: (context, isHovering) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.background
                : (isHovering ? AppColors.background : AppColors.transparent),
            borderRadius: BorderRadius.circular(AppSizes.radiusRound),
            boxShadow: isSelected ? AppShadows.subtle : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Item de dropdown compacto para menus suspensos.
class DropdownItem extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showDivider;

  const DropdownItem({
    super.key,
    this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HoverAnimatedScale(
          tooltip: null,
          onTap: onTap,
          hoverScale: 1.01,
          builder: (context, isHovering) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isHovering ? AppColors.gray100 : AppColors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing!,
                  ],
                ],
              ),
            );
          },
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.border,
            indent: 8,
            endIndent: 8,
          ),
      ],
    );
  }
}
