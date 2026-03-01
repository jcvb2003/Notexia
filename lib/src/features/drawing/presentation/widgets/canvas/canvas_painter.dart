import 'package:flutter/material.dart';

import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/background_grid_painter.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/elements_painter.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/overlays_painter.dart';

class PainterCtx {
  final List<CanvasElement> elements;
  final Set<String> selectedElementIds;
  final double zoomLevel;
  final Offset panOffset;
  final Rect? selectionBox;
  final String? hoveredElementId;
  final String? editingElementId;
  final List<Offset> eraserTrail;
  final bool isEraserActive;
  final List<SnapGuide> snapGuides;
  final CanvasElement? activeDrawingElement;
  final bool renderOnlySelected;
  final bool excludeSelected;

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
    this.renderOnlySelected = false,
    this.excludeSelected = false,
  });
}

class StaticCanvasPainter extends CustomPainter {
  final List<CanvasElement> elements;
  final Set<String> selectedElementIds;
  final double zoomLevel;
  final Offset panOffset;
  final String? editingElementId;

  StaticCanvasPainter({
    required this.elements,
    required this.selectedElementIds,
    required this.zoomLevel,
    required this.panOffset,
    this.editingElementId,
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
      selectionBox: null,
      hoveredElementId: null,
      editingElementId: editingElementId,
      eraserTrail: const [],
      isEraserActive: false,
      snapGuides: const [],
      activeDrawingElement: null,
      excludeSelected: true,
    );

    BackgroundGridPainter.drawBackground(ctx, canvas, size);
    BackgroundGridPainter.drawGrid(ctx, canvas, size);
    ElementsPainter.renderElements(ctx, canvas, size);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant StaticCanvasPainter oldDelegate) {
    return oldDelegate.elements != elements ||
        oldDelegate.selectedElementIds != selectedElementIds ||
        oldDelegate.zoomLevel != zoomLevel ||
        oldDelegate.panOffset != panOffset ||
        oldDelegate.editingElementId != editingElementId;
  }
}

class DynamicCanvasPainter extends CustomPainter {
  final List<CanvasElement> elements;
  final Set<String> selectedElementIds;
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
      renderOnlySelected: true,
    );

    ElementsPainter.renderElements(ctx, canvas, size);

    if (ctx.activeDrawingElement != null) {
      ElementsPainter.renderSingleElement(
          ctx, canvas, ctx.activeDrawingElement!);
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
        oldDelegate.elements != elements;
  }
}
