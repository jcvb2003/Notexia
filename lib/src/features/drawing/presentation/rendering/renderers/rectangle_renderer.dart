import 'dart:ui';
import 'package:notexia/src/core/canvas/rendering/painters/dashed_painter.dart';
import 'package:notexia/src/core/canvas/rendering/painters/rough_painter.dart';
import 'package:notexia/src/core/canvas/rendering/painters/hachure_painter.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/element_renderer.dart';

class RectangleRenderer implements ElementRenderer<RectangleElement> {
  @override
  void render(Canvas canvas, RectangleElement element) {
    final rect =
        Rect.fromLTWH(element.x, element.y, element.width, element.height);

    if (element.fillType != FillType.transparent && element.fillColor != null) {
      if (element.fillType == FillType.solid) {
        final fillPaint = Paint()
          ..color = element.fillColor!.withValues(alpha: element.opacity)
          ..style = PaintingStyle.fill;
        canvas.drawRect(rect, fillPaint);
      } else {
        HachurePainter.drawHachure(
          canvas,
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
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (element.strokeStyle == StrokeStyle.dashed) {
      DashedPainter.drawDashedRRect(canvas, rect, strokePaint);
    } else if (element.strokeStyle == StrokeStyle.dotted) {
      final p1 = rect.topLeft;
      final p2 = rect.topRight;
      final p3 = rect.bottomRight;
      final p4 = rect.bottomLeft;
      DashedPainter.drawDottedLine(canvas, p1, p2, strokePaint);
      DashedPainter.drawDottedLine(canvas, p2, p3, strokePaint);
      DashedPainter.drawDottedLine(canvas, p3, p4, strokePaint);
      DashedPainter.drawDottedLine(canvas, p4, p1, strokePaint);
    } else {
      RoughPainter.drawRoughRect(
        canvas,
        rect,
        strokePaint,
        element.roughness,
        element.opacity,
        seed: element.id.hashCode,
      );
    }
  }
}
