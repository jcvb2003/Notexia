import 'dart:math' as math;
import 'dart:ui';

class DashedPainter {
  static void drawDashedRRect(Canvas canvas, Rect rect, Paint paint) {
    const dashWidth = 5.0;
    const dashSpace = 3.0;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)));

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = math.min(dashWidth, metric.length - distance);
        canvas.drawPath(metric.extractPath(distance, distance + length), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  static void drawDashedLine(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Paint paint, {
    double dashWidth = 5.0,
    double dashSpace = 3.0,
  }) {
    final distance = (p2 - p1).distance;
    final numDashes = (distance / (dashWidth + dashSpace)).floor();

    for (int i = 0; i <= numDashes; i++) {
      final tStart = i * (dashWidth + dashSpace) / distance;
      final tEnd = math.min(
        1.0,
        (i * (dashWidth + dashSpace) + dashWidth) / distance,
      );

      if (tStart < 1.0) {
        canvas.drawLine(
          Offset.lerp(p1, p2, tStart)!,
          Offset.lerp(p1, p2, tEnd)!,
          paint,
        );
      }
    }
  }

  static void drawDottedLine(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Paint paint, {
    double dotSpacing = 8.0,
  }) {
    final distance = (p2 - p1).distance;
    final numDots = (distance / dotSpacing).floor();
    final dotPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    for (int i = 0; i <= numDots; i++) {
      final t = (numDots == 0) ? 0.0 : i / numDots;
      final point = Offset.lerp(p1, p2, t)!;
      canvas.drawCircle(point, paint.strokeWidth / 2, dotPaint);
    }
  }

  static void drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    double dashWidth = 5.0,
    double dashSpace = 3.0,
  }) {
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = math.min(dashWidth, metric.length - distance);
        canvas.drawPath(metric.extractPath(distance, distance + length), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  static void drawDottedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    double dotSpacing = 8.0,
  }) {
    final dotPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance <= metric.length) {
        final tangent = metric.getTangentForOffset(distance);
        if (tangent != null) {
          canvas.drawCircle(tangent.position, paint.strokeWidth / 2, dotPaint);
        }
        distance += dotSpacing;
      }
    }
  }
}
