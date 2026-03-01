import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

/// Botão de ícone reutilizável com suporte a hover, tooltip e estados ativos.
///
/// Usado em: toolbars, headers, sidebars e controles flutuantes.
class HoverAnimatedScale extends StatefulWidget {
  final Widget Function(BuildContext context, bool isHovering) builder;
  final String? tooltip;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final bool isEnabled;
  final MouseCursor cursor;
  final double hoverScale;
  final bool isActive;
  final double activeScale;
  final Duration duration;
  final Curve curve;

  const HoverAnimatedScale({
    super.key,
    required this.builder,
    this.tooltip,
    this.onTap,
    this.onDoubleTap,
    this.isEnabled = true,
    this.cursor = SystemMouseCursors.click,
    this.hoverScale = 1.04,
    this.isActive = false,
    this.activeScale = 1.04,
    this.duration = const Duration(milliseconds: 150),
    this.curve = Curves.easeOut,
  });

  @override
  State<HoverAnimatedScale> createState() => _HoverAnimatedScaleState();
}

class _HoverAnimatedScaleState extends State<HoverAnimatedScale> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final scale = widget.isActive
        ? widget.activeScale
        : (_isHovering ? widget.hoverScale : 1.0);

    final child = AnimatedScale(
      scale: scale,
      duration: widget.duration,
      curve: widget.curve,
      child: widget.builder(context, _isHovering),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: widget.isEnabled ? widget.cursor : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.isEnabled ? widget.onTap : null,
        onDoubleTap: widget.isEnabled ? widget.onDoubleTap : null,
        child: widget.tooltip == null
            ? child
            : Tooltip(message: widget.tooltip!, child: child),
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final bool isActive;
  final bool isDisabled;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? disabledColor;
  final Color? activeBackgroundColor;
  final Color? hoverBackgroundColor;
  final Color? disabledBackgroundColor;
  final String? semanticsLabel;
  final bool isCompact;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.onDoubleTap,
    this.isActive = false,
    this.isDisabled = false,
    this.size = 32,
    this.activeColor,
    this.inactiveColor,
    this.disabledColor,
    this.activeBackgroundColor,
    this.hoverBackgroundColor,
    this.disabledBackgroundColor,
    this.semanticsLabel,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = this.activeColor ?? AppColors.iconActive;
    final inactiveColor = this.inactiveColor ?? AppColors.gray600;
    final disabledColor = this.disabledColor ?? AppColors.textMuted;
    final activeBg = activeBackgroundColor ?? AppColors.primary;
    final hoverBg = hoverBackgroundColor ?? AppColors.gray50;
    final disabledBg = disabledBackgroundColor ?? AppColors.gray100;
    final isEnabled = !isDisabled && onTap != null;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: semanticsLabel ?? tooltip,
      child: HoverAnimatedScale(
        tooltip: tooltip,
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        isEnabled: isEnabled,
        isActive: isActive,
        hoverScale: 1.05,
        activeScale: 1.05,
        builder: (context, isHovering) {
          final bgColor = isActive
              ? activeBg
              : (!isEnabled
                  ? disabledBg
                  : (isHovering ? hoverBg : AppColors.transparent));

          final iconColor = isActive
              ? activeColor
              : (!isEnabled ? disabledColor : inactiveColor);

          final resolvedSize = isCompact ? 40.0 : size;
          final iconRatio = isCompact ? 0.5 : 0.5625;

          return Container(
            width: resolvedSize,
            height: resolvedSize,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive ? AppColors.border : AppColors.transparent,
                width: 1,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: activeBg.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Icon(icon, color: iconColor, size: resolvedSize * iconRatio),
          );
        },
      ),
    );
  }
}

/// Botão de ação circular usado na sidebar e em áreas de ação rápida.
class ActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final double size;

  const ActionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: size * 0.45, color: AppColors.textPrimary),
        onPressed: onPressed ?? () {},
        tooltip: tooltip,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
