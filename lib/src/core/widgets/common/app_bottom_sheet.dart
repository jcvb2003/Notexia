import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

/// A standardized bottom sheet for the application.
///
/// Provides a consistent look and feel with a drag handle and optional title.
class AppBottomSheet extends StatelessWidget {
  final Widget? title;
  final Widget child;
  final List<Widget>? actions;
  final bool showDragHandle;
  final EdgeInsets? padding;
  final TextAlign? titleAlign;

  const AppBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.actions,
    this.showDragHandle = true,
    this.padding,
    this.titleAlign,
  });

  /// Static method to show the bottom sheet.
  static Future<T?> show<T>(
    BuildContext context, {
    Widget? title,
    required Widget child,
    List<Widget>? actions,
    bool showDragHandle = true,
    bool isScrollControlled = true,
    EdgeInsets? padding,
    TextAlign? titleAlign,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      barrierColor: AppColors.textMuted.withValues(alpha: 0.4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => AppBottomSheet(
        title: title,
        actions: actions,
        showDragHandle: showDragHandle,
        padding: padding,
        titleAlign: titleAlign,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showDragHandle) ...[
              const SizedBox(height: 8),
              Center(
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.titleLarge!,
                        textAlign: titleAlign,
                        child: title!,
                      ),
                    ),
                    if (actions != null) ...actions!,
                  ],
                ),
              ),
            ],
            Flexible(
              child: SingleChildScrollView(
                padding: padding ?? const EdgeInsets.fromLTRB(24, 12, 24, 32),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
