import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

class AppDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final EdgeInsets? contentPadding;
  final EdgeInsets? actionsPadding;
  final EdgeInsets? insetPadding;
  final MainAxisAlignment? actionsAlignment;
  final Color? backgroundColor;
  final ShapeBorder? shape;

  const AppDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.contentPadding,
    this.actionsPadding,
    this.insetPadding,
    this.actionsAlignment,
    this.backgroundColor,
    this.shape,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    bool useSafeArea = true,
    bool useRootNavigator = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      builder: builder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor ?? AppColors.background,
      shape:
          shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            side: const BorderSide(color: AppColors.border),
          ),
      contentPadding:
          contentPadding ??
          const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
      actionsPadding:
          actionsPadding ??
          const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
      insetPadding:
          insetPadding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
      actionsAlignment: actionsAlignment ?? MainAxisAlignment.end,
      title: title,
      content: content,
      actions: actions,
    );
  }
}
