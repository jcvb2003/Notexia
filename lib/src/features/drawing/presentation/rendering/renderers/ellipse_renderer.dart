import 'dart:ui';
import 'package:notexia/src/core/canvas/rendering/painters/dashed_painter.dart';
import 'package:notexia/src/core/canvas/rendering/painters/rough_painter.dart';
import 'package:notexia/src/core/canvas/rendering/painters/hachure_painter.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/element_renderer.dart';

class EllipseRenderer implements ElementRenderer<EllipseElement> {
  @override
  void render(Canvas canvas, EllipseElement element) {
    final rect =
        Rect.fromLTWH(element.x, element.y, element.width, element.height);

    if (element.fillType != FillType.transparent && element.fillColor != null) {
      if (element.fillType == FillType.solid) {
        final fillPaint = Paint()
          ..color = element.fillColor!.withValues(alpha: element.opacity)
          ..style = PaintingStyle.fill;
        canvas.drawOval(rect, fillPaint);
      } else {
        final path = Path()..addOval(rect);
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
      final path = Path()..addOval(rect);
      DashedPainter.drawDashedPath(canvas, path, strokePaint);
    } else if (element.strokeStyle == StrokeStyle.dotted) {
      final path = Path()..addOval(rect);
      DashedPainter.drawDottedPath(canvas, path, strokePaint);
    } else {
      RoughPainter.drawRoughEllipse(
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
