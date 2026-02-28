import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

class AppMenuItem<T> extends PopupMenuItem<T> {
  AppMenuItem({
    super.key,
    required super.value,
    required String label,
    IconData? icon,
    bool isDestructive = false,
  }) : super(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          height: 40,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: AppSizes.iconMedium,
                  color:
                      isDestructive ? AppColors.danger : AppColors.iconDefault,
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                label,
                style: TextStyle(
                  color:
                      isDestructive ? AppColors.danger : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
}

class AppContextMenu<T> extends StatelessWidget {
  final Widget child;
  final List<PopupMenuEntry<T>> Function(BuildContext) itemBuilder;
  final void Function(T)? onSelected;
  final Offset offset;
  final String? tooltip;

  const AppContextMenu({
    super.key,
    required this.child,
    required this.itemBuilder,
    this.onSelected,
    this.offset = Offset.zero,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      tooltip: tooltip ?? '',
      offset: offset,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      color: AppColors.background,
      elevation: 6,
      itemBuilder: itemBuilder,
      onSelected: onSelected,
      child: child,
    );
  }
}
