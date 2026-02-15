import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

void showModularSheet(
  BuildContext context, {
  required String title,
  required Widget child,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.background,
    elevation: 0,
    barrierColor: AppColors.textMuted.withValues(alpha: 0.4),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    ),
  );
}
