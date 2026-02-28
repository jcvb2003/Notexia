import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/common/floating_card.dart';

class BaseToolbar extends StatelessWidget {
  final Widget? leading;
  final Widget? center;
  final List<Widget>? actions;
  final String? title;
  final bool highlighted;
  final Color? backgroundColor;

  const BaseToolbar({
    super.key,
    this.leading,
    this.center,
    this.title,
    this.actions,
    this.highlighted = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingCard(
      backgroundColor: backgroundColor ??
          (highlighted
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.1)
              : AppColors.background),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            if (title != null ||
                center != null ||
                (actions != null && actions!.isNotEmpty))
              const SizedBox(width: 8),
          ],
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(title!, style: theme.textTheme.titleMedium),
            ),
          if (center != null) center!,
          if (actions != null && actions!.isNotEmpty) ...[
            if (leading != null || title != null || center != null)
              const ToolbarDivider(),
            ...actions!,
          ],
        ],
      ),
    );
  }
}

class ToolbarDivider extends StatelessWidget {
  final double horizontalPadding;

  const ToolbarDivider({super.key, this.horizontalPadding = 8});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(height: 24, width: 1, color: AppColors.border),
    );
  }
}
