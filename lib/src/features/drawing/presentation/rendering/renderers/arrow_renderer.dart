import 'dart:ui';
import 'dart:math' as math;
import 'package:notexia/src/core/canvas/rendering/painters/dashed_painter.dart';
import 'package:notexia/src/core/canvas/rendering/painters/rough_painter.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/arrow_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/element_renderer.dart';

class ArrowRenderer implements ElementRenderer<ArrowElement> {
  @override
  void render(Canvas canvas, ArrowElement element) {
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

    final direction = p2 - p1;
    if (direction.distance == 0) return;

    final angle = direction.direction;
    const arrowSize = 15.0;
    const arrowAngle = 0.5;

    final headP1 = Offset(
      p2.dx - arrowSize * math.cos(angle - arrowAngle),
      p2.dy - arrowSize * math.sin(angle - arrowAngle),
    );
    final headP2 = Offset(
      p2.dx - arrowSize * math.cos(angle + arrowAngle),
      p2.dy - arrowSize * math.sin(angle + arrowAngle),
    );

    if (element.roughness > 0) {
      RoughPainter.drawRoughLine(
        canvas,
        headP1,
        p2,
        paint,
        element.roughness,
        element.opacity,
        seed: element.id.hashCode + 1,
      );
      RoughPainter.drawRoughLine(
        canvas,
        headP2,
        p2,
        paint,
        element.roughness,
        element.opacity,
        seed: element.id.hashCode + 2,
      );
    } else {
      canvas.drawLine(headP1, p2, paint);
      canvas.drawLine(headP2, p2, paint);
    }
  }
}
