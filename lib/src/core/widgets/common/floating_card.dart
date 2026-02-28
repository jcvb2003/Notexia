import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

/// Decorações e containers reutilizáveis do design system Notexia.

enum FloatingCardVariant {
  elevated,
  outlined,
  subtle,
}

/// Container flutuante com sombra e bordas arredondadas.
///
/// Usado em: toolbars, menus, cards flutuantes.
class FloatingCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color backgroundColor;
  final double shadowBlur;
  final Offset shadowOffset;
  final FloatingCardVariant variant;

  const FloatingCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 12,
    this.backgroundColor = AppColors.background,
    this.shadowBlur = 10,
    this.shadowOffset = const Offset(0, 4),
    this.variant = FloatingCardVariant.elevated,
  });

  @override
  Widget build(BuildContext context) {
    Color actualBackgroundColor = backgroundColor;
    List<BoxShadow>? shadows;
    Border? border;

    switch (variant) {
      case FloatingCardVariant.elevated:
        shadows = [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.1),
            blurRadius: shadowBlur,
            offset: shadowOffset,
          ),
        ];
        break;
      case FloatingCardVariant.outlined:
        border = Border.all(color: AppColors.border, width: 1);
        break;
      case FloatingCardVariant.subtle:
        actualBackgroundColor = AppColors.surface;
        break;
    }

    return Container(
      padding: padding ?? const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: actualBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadows,
        border: border,
      ),
      child: child,
    );
  }
}
