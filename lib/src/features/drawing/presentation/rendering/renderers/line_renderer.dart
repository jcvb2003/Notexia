import 'dart:ui';
import 'package:notexia/src/core/canvas/rendering/painters/dashed_painter.dart';
import 'package:notexia/src/core/canvas/rendering/painters/rough_painter.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/line_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/element_renderer.dart';

class LineRenderer implements ElementRenderer<LineElement> {
  @override
  void render(Canvas canvas, LineElement element) {
    if (element.points.length < 2) return;

    final paint = Paint()
      ..color = element.strokeColor.withValues(alpha: element.opacity)
      ..strokeWidth = element.strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final p1 = Offset(
        element.x + element.points[0].dx, element.y + element.points[0].dy);
    final p2 = Offset(
        element.x + element.points[1].dx, element.y + element.points[1].dy);

    if (element.strokeStyle == StrokeStyle.dashed) {
      DashedPainter.drawDashedLine(canvas, p1, p2, paint);
    } else if (element.strokeStyle == StrokeStyle.dotted) {
      DashedPainter.drawDottedLine(canvas, p1, p2, paint);
    } else {
      RoughPainter.drawRoughLine(
        canvas,
        p1,
        p2,
        paint,
        element.roughness,
        element.opacity,
        seed: element.id.hashCode,
      );
    }
  }
}
