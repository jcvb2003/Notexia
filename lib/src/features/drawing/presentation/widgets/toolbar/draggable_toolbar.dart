import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/main_toolbar.dart';

/// Widget que permite arrastar a toolbar para o topo ou para baixo.
class DraggableToolbar extends StatefulWidget {
  final bool isToolbarAtTop;
  final double? toolbarTop;
  final double? toolbarBottom;
  final bool isMobile;
  final bool isCompact;
  final Function(bool) onPositionChanged;

  const DraggableToolbar({
    super.key,
    required this.isToolbarAtTop,
    required this.toolbarTop,
    required this.toolbarBottom,
    required this.isMobile,
    required this.isCompact,
    required this.onPositionChanged,
  });

  @override
  State<DraggableToolbar> createState() => _DraggableToolbarState();
}

class _DraggableToolbarState extends State<DraggableToolbar> {
  double? _dragStartY;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    // Se for mobile, fica fixa (sem deslize vertical) e o conteúdo deve manter altura estática
    final content = Center(
      child: widget.isMobile
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MainToolbar(isCompact: widget.isCompact),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const ClampingScrollPhysics(),
              child: MainToolbar(isCompact: widget.isCompact),
            ),
    );

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      bottom: widget.toolbarBottom,
      top: widget.toolbarTop,
      left: 0,
      right: 0,
      child: SafeArea(
        top: widget.isToolbarAtTop,
        bottom: !widget.isToolbarAtTop,
        child: Listener(
          onPointerDown: (details) {
            _dragStartY = details.position.dy;
            _isDragging = true;
          },
          onPointerMove: (details) {
            if (!_isDragging || _dragStartY == null) return;

            final currentY = details.position.dy;
            final deltaY = currentY - _dragStartY!;

            // Threshold de 30px para detecção mais sensível
            if (deltaY < -30 && !widget.isToolbarAtTop) {
              widget.onPositionChanged(true);
              _isDragging = false;
            } else if (deltaY > 30 && widget.isToolbarAtTop) {
              widget.onPositionChanged(false);
              _isDragging = false;
            }
          },
          onPointerUp: (_) {
            _isDragging = false;
            _dragStartY = null;
          },
          onPointerCancel: (_) {
            _isDragging = false;
            _dragStartY = null;
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: content,
          ),
        ),
      ),
    );
  }
}
