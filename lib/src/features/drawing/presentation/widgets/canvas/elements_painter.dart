import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_painter.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/renderer_provider.dart';

class ElementsPainter {
  static void renderElements(PainterCtx ctx, Canvas canvas, Size size) {
    final visibleRect = Rect.fromLTWH(
      -ctx.panOffset.dx / ctx.zoomLevel,
      -ctx.panOffset.dy / ctx.zoomLevel,
      size.width / ctx.zoomLevel,
      size.height / ctx.zoomLevel,
    );

    final cullingRect = visibleRect.inflate(100);
    final elementsToRender = ctx.elements;

    for (final element in elementsToRender) {
      if (ctx.editingElementId == element.id) continue;

      final isSelected = ctx.selectedElementIds.contains(element.id);
      if (ctx.excludeSelected && isSelected) continue;
      if (ctx.renderOnlySelected && !isSelected) continue;

      final elementBounds = _getRotatedBounds(element);
      if (!cullingRect.overlaps(elementBounds)) {
        continue;
      }

      renderSingleElement(ctx, canvas, element);
    }
  }

  static void renderSingleElement(
    PainterCtx ctx,
    Canvas canvas,
    CanvasElement element,
  ) {
    canvas.save();
    if (element.angle != 0) {
      final centerX = element.x + element.width / 2;
      final centerY = element.y + element.height / 2;
      canvas.translate(centerX, centerY);
      canvas.rotate(element.angle);
      canvas.translate(-centerX, -centerY);
    }

    final renderer = RendererProvider.getRenderer(element);
    renderer.render(canvas, element);

    canvas.restore();
  }

  static Rect _getRotatedBounds(CanvasElement element) {
    if (element.angle == 0) return element.bounds;

    final cx = element.x + element.width / 2;
    final cy = element.y + element.height / 2;

    return _computeRotatedRect(element.bounds, element.angle, Offset(cx, cy));
  }

  static Rect _computeRotatedRect(Rect bounds, double angle, Offset center) {
    final matrix = vector.Matrix4.identity()
      ..translateByVector3(vector.Vector3(center.dx, center.dy, 0.0))
      ..rotateZ(angle)
      ..translateByVector3(vector.Vector3(-center.dx, -center.dy, 0.0));

    // Transform 4 corners
    final p1 = matrix.transform3(vector.Vector3(bounds.left, bounds.top, 0));
    final p2 = matrix.transform3(vector.Vector3(bounds.right, bounds.top, 0));
    final p3 =
        matrix.transform3(vector.Vector3(bounds.right, bounds.bottom, 0));
    final p4 = matrix.transform3(vector.Vector3(bounds.left, bounds.bottom, 0));

    final xs = [p1.x, p2.x, p3.x, p4.x];
    final ys = [p1.y, p2.y, p3.y, p4.y];

    xs.sort();
    ys.sort();

    return Rect.fromLTRB(xs.first, ys.first, xs.last, ys.last);
  }
}
