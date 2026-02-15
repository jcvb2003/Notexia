import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/background_grid_painter.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/elements_painter.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/overlays_painter.dart';

class PainterCtx {
  final List<CanvasElement> elements;
  final List<String> selectedElementIds;
  final double zoomLevel;
  final Offset panOffset;
  final Rect? selectionBox;
  final String? hoveredElementId;
  final String? editingElementId;
  final List<Offset> eraserTrail;
  final bool isEraserActive;
  final List<SnapGuide> snapGuides;
  final CanvasElement? activeDrawingElement;

  const PainterCtx({
    required this.elements,
    required this.selectedElementIds,
    required this.zoomLevel,
    required this.panOffset,
    required this.selectionBox,
    required this.hoveredElementId,
    required this.editingElementId,
    required this.eraserTrail,
    required this.isEraserActive,
    required this.snapGuides,
    this.activeDrawingElement,
  });
}

class StaticCanvasPainter extends CustomPainter {
  final List<CanvasElement> elements;
  final double zoomLevel;
  final Offset panOffset;
  final String? editingElementId;

  StaticCanvasPainter({
    required this.elements,
    required this.zoomLevel,
    required this.panOffset,
    this.editingElementId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(panOffset.dx, panOffset.dy);
    canvas.scale(zoomLevel);

    // Context minimal for static rendering
    final ctx = PainterCtx(
      elements: elements,
      selectedElementIds: const [],
      zoomLevel: zoomLevel,
      panOffset: panOffset,
      selectionBox: null,
      hoveredElementId: null,
      editingElementId: editingElementId,
      eraserTrail: const [],
      isEraserActive: false,
      snapGuides: const [],
      activeDrawingElement: null,
    );

    BackgroundGridPainter.drawBackground(ctx, canvas, size);
    BackgroundGridPainter.drawGrid(ctx, canvas, size);
    ElementsPainter.renderElements(ctx, canvas, size);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant StaticCanvasPainter oldDelegate) {
    return oldDelegate.elements != elements ||
        oldDelegate.zoomLevel != zoomLevel ||
        oldDelegate.panOffset != panOffset ||
        oldDelegate.editingElementId != editingElementId;
  }
}

class DynamicCanvasPainter extends CustomPainter {
  final List<CanvasElement> elements;
  final List<String> selectedElementIds;
  final double zoomLevel;
  final Offset panOffset;
  final Rect? selectionBox;
  final String? hoveredElementId;
  final List<Offset> eraserTrail;
  final bool isEraserActive;
  final List<SnapGuide> snapGuides;
  final CanvasElement? activeDrawingElement;

  DynamicCanvasPainter({
    required this.elements,
    required this.selectedElementIds,
    required this.zoomLevel,
    required this.panOffset,
    required this.selectionBox,
    required this.hoveredElementId,
    required this.eraserTrail,
    required this.isEraserActive,
    required this.snapGuides,
    this.activeDrawingElement,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(panOffset.dx, panOffset.dy);
    canvas.scale(zoomLevel);

    final ctx = PainterCtx(
      elements: elements,
      selectedElementIds: selectedElementIds,
      zoomLevel: zoomLevel,
      panOffset: panOffset,
      selectionBox: selectionBox,
      hoveredElementId: hoveredElementId,
      editingElementId: null,
      eraserTrail: eraserTrail,
      isEraserActive: isEraserActive,
      snapGuides: snapGuides,
      activeDrawingElement: activeDrawingElement,
    );

    // Render active drawing element first (or last depending on layer preference, usually on top)
    if (activeDrawingElement != null) {
      ElementsPainter.renderSingleElement(ctx, canvas, activeDrawingElement!);
    }

    OverlaysPainter.drawSelectionBox(ctx, canvas);
    OverlaysPainter.drawHover(ctx, canvas);
    OverlaysPainter.drawSelection(ctx, canvas);
    OverlaysPainter.drawEraserTrail(ctx, canvas);
    OverlaysPainter.drawSnapGuides(ctx, canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DynamicCanvasPainter oldDelegate) {
    // Zoom and Pan affect positions, so we must repaint overlays if they change
    if (oldDelegate.zoomLevel != zoomLevel ||
        oldDelegate.panOffset != panOffset) {
      return true;
    }

    return oldDelegate.selectedElementIds != selectedElementIds ||
        oldDelegate.selectionBox != selectionBox ||
        oldDelegate.hoveredElementId != hoveredElementId ||
        oldDelegate.eraserTrail != eraserTrail ||
        oldDelegate.isEraserActive != isEraserActive ||
        oldDelegate.snapGuides != snapGuides ||
        oldDelegate.activeDrawingElement != activeDrawingElement ||
        // Elements change might affect selection handles position
        oldDelegate.elements != elements;
  }
}

// Deprecated: Kept for backward compatibility if needed, but ideally should be removed
// or refactored to use the new painters.
// For now, removing the old CanvasPainter class completely to force usage of new ones.
