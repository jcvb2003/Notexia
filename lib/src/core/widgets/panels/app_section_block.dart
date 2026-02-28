import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

class AppSectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.style,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: style ?? context.typography.labelMedium,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class AppSectionBlock extends StatelessWidget {
  final String? title;
  final Widget? headerTrailing;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final TextStyle? headerStyle;
  final EdgeInsetsGeometry? headerPadding;

  const AppSectionBlock({
    super.key,
    this.title,
    this.headerTrailing,
    required this.child,
    this.padding,
    this.headerStyle,
    this.headerPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            AppSectionHeader(
              title: title!,
              trailing: headerTrailing,
              style: headerStyle,
              padding: headerPadding,
            ),
          child,
        ],
      ),
    );
  }
}
