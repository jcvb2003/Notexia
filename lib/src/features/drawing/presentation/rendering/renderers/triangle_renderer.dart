import 'dart:ui';
import 'package:notexia/src/core/canvas/rendering/painters/dashed_painter.dart';
import 'package:notexia/src/core/canvas/rendering/painters/rough_painter.dart';
import 'package:notexia/src/core/canvas/rendering/painters/hachure_painter.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/triangle_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/element_renderer.dart';

class TriangleRenderer implements ElementRenderer<TriangleElement> {
  @override
  void render(Canvas canvas, TriangleElement element) {
    final p1 = Offset(element.x + element.width / 2, element.y);
    final p2 = Offset(element.x + element.width, element.y + element.height);
    final p3 = Offset(element.x, element.y + element.height);
    final rect =
        Rect.fromLTWH(element.x, element.y, element.width, element.height);
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();

    if (element.fillType != FillType.transparent && element.fillColor != null) {
      if (element.fillType == FillType.solid) {
        final fillPaint = Paint()
          ..color = element.fillColor!.withValues(alpha: element.opacity)
          ..style = PaintingStyle.fill;
        canvas.drawPath(path, fillPaint);
      } else {
        HachurePainter.drawHachurePath(
          canvas,
          path,
          rect,
          element.fillColor!,
          element.opacity,
          element.strokeWidth,
          crossHatch: element.fillType == FillType.crossHatch,
        );
      }
    }

    final strokePaint = Paint()
      ..color = element.strokeColor.withValues(alpha: element.opacity)
      ..strokeWidth = element.strokeWidth
      ..style = PaintingStyle.stroke;

    if (element.strokeStyle == StrokeStyle.dashed) {
      DashedPainter.drawDashedPath(canvas, path, strokePaint);
    } else if (element.strokeStyle == StrokeStyle.dotted) {
      DashedPainter.drawDottedPath(canvas, path, strokePaint);
    } else {
      if (element.roughness <= 0.01) {
        canvas.drawPath(path, strokePaint);
        return;
      }

      RoughPainter.drawRoughLine(
        canvas,
        p1,
        p2,
        strokePaint,
        element.roughness,
        element.opacity,
        seed: element.id.hashCode,
      );
      RoughPainter.drawRoughLine(
        canvas,
        p2,
        p3,
        strokePaint,
        element.roughness,
        element.opacity,
        seed: element.id.hashCode + 1,
      );
      RoughPainter.drawRoughLine(
        canvas,
        p3,
        p1,
        strokePaint,
        element.roughness,
        element.opacity,
        seed: element.id.hashCode + 2,
      );
    }
  }
}
