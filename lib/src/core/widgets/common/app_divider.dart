import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

/// Divisor padronizado para layouts e toolbars.
class AppDivider extends StatelessWidget {
  final double? height;
  final double? width;
  final double horizontalPadding;
  final double verticalPadding;
  final Color? color;

  const AppDivider({
    super.key,
    this.height,
    this.width = 1.0,
    this.horizontalPadding = 0.0,
    this.verticalPadding = 0.0,
    this.color,
  });

  /// Variante específica para toolbars.
  const AppDivider.toolbar({
    super.key,
    this.horizontalPadding = AppSpacing.sm,
  })  : height = 24,
        width = 1,
        verticalPadding = 0.0,
        color = AppColors.border;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Container(
        height: height,
        width: width,
        color: color ?? AppColors.border,
      ),
    );
  }
}
