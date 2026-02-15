import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

/// Decorações e containers reutilizáveis do design system Notexia.

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

  const FloatingCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 12,
    this.backgroundColor = AppColors.background,
    this.shadowBlur = 10,
    this.shadowOffset = const Offset(0, 4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.1),
            blurRadius: shadowBlur,
            offset: shadowOffset,
          ),
        ],
      ),
      child: child,
    );
  }
}
