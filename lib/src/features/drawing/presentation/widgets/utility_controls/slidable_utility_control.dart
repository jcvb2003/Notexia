import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/buttons/app_icon_button.dart';
import 'package:notexia/src/core/widgets/common/floating_card.dart';

class SlidableUtilityControl extends StatelessWidget {
  final bool isZoomMode;
  final double zoomLevel;
  final VoidCallback onToggle;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onUndo;
  final VoidCallback onRedo;

  const SlidableUtilityControl({
    super.key,
    required this.isZoomMode,
    required this.zoomLevel,
    required this.onToggle,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onUndo,
    required this.onRedo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null &&
                details.primaryVelocity!.abs() > 300) {
              onToggle();
            }
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.2, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: isZoomMode
                ? KeyedSubtree(
                    key: const ValueKey('zoom'),
                    child: _ZoomControls(
                      zoomLevel: zoomLevel,
                      onZoomIn: onZoomIn,
                      onZoomOut: onZoomOut,
                    ),
                  )
                : KeyedSubtree(
                    key: const ValueKey('history'),
                    child: _UndoRedoControls(onUndo: onUndo, onRedo: onRedo),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PageIndicator(isActive: isZoomMode),
            const SizedBox(width: 4),
            _PageIndicator(isActive: !isZoomMode),
          ],
        ),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final bool isActive;
  const _PageIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.primary : AppColors.border,
      ),
    );
  }
}

class _ZoomControls extends StatelessWidget {
  final double zoomLevel;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const _ZoomControls({
    required this.zoomLevel,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingCard(
      shadowBlur: 4,
      shadowOffset: const Offset(0, 2),
      child: SizedBox(
        height: 32,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIconButton(
              icon: LucideIcons.minus,
              tooltip: 'Diminuir Zoom',
              onTap: onZoomOut,
              size: 32,
            ),
            const SizedBox(width: 8),
            Text(
              '${(zoomLevel * 100).round()}%',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(width: 8),
            AppIconButton(
              icon: LucideIcons.plus,
              tooltip: 'Aumentar Zoom',
              onTap: onZoomIn,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}

class _UndoRedoControls extends StatelessWidget {
  final VoidCallback onUndo;
  final VoidCallback onRedo;

  const _UndoRedoControls({required this.onUndo, required this.onRedo});

  @override
  Widget build(BuildContext context) {
    return FloatingCard(
      shadowBlur: 4,
      shadowOffset: const Offset(0, 2),
      child: SizedBox(
        height: 32,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIconButton(
              icon: LucideIcons.undo2,
              tooltip: 'Desfazer',
              onTap: onUndo,
              size: 32,
            ),
            AppIconButton(
              icon: LucideIcons.redo2,
              tooltip: 'Refazer',
              onTap: onRedo,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
