import 'dart:math' as math;
import 'dart:ui';

class RoughPainter {
  static void drawRoughLine(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Paint paint,
    double roughness,
    double opacity, {
    int? seed,
  }) {
    if (roughness == 0) {
      canvas.drawLine(p1, p2, paint);
      return;
    }

    final random = math.Random(seed ?? (p1.hashCode ^ p2.hashCode));
    final distance = (p2 - p1).distance;

    Path generatePath(double r) {
      final path = Path();

      // Magnitude of wobble based on roughness and distance
      // We dampen the distance factor to avoid excessive wobble on long lines
      final distFactor = math.pow(distance, 0.65);
      final magnitude = r * distFactor * 0.015;

      // Jitter endpoints slightly
      final endPointJitter = r * 2.0;

      final start = p1 +
          Offset(
            (random.nextDouble() - 0.5) * endPointJitter,
            (random.nextDouble() - 0.5) * endPointJitter,
          );
      final end = p2 +
          Offset(
            (random.nextDouble() - 0.5) * endPointJitter,
            (random.nextDouble() - 0.5) * endPointJitter,
          );

      path.moveTo(start.dx, start.dy);

      // Use Cubic Bezier for smooth irregular curve
      final dx = end.dx - start.dx;
      final dy = end.dy - start.dy;

      // Control points roughly at 1/3 and 2/3 of the way
      // Deviated by random magnitude perpendicular-ish
      final c1x =
          start.dx + dx / 3 + (random.nextDouble() - 0.5) * magnitude * 2;
      final c1y =
          start.dy + dy / 3 + (random.nextDouble() - 0.5) * magnitude * 2;

      final c2x =
          start.dx + 2 * dx / 3 + (random.nextDouble() - 0.5) * magnitude * 2;
      final c2y =
          start.dy + 2 * dy / 3 + (random.nextDouble() - 0.5) * magnitude * 2;

      path.cubicTo(c1x, c1y, c2x, c2y, end.dx, end.dy);
      return path;
    }

    canvas.drawPath(generatePath(roughness), paint);

    // Double stroke for roughness >= 1 (Simulates Artist/Cartoonist style)
    if (roughness >= 1.0) {
      canvas.drawPath(generatePath(roughness), paint);
    }
  }

  static void drawRoughRect(
    Canvas canvas,
    Rect rect,
    Paint paint,
    double roughness,
    double opacity, {
    int? seed,
  }) {
    if (roughness == 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        paint,
      );
      return;
    }

    final p1 = rect.topLeft;
    final p2 = rect.topRight;
    final p3 = rect.bottomRight;
    final p4 = rect.bottomLeft;

    final baseSeed = seed ?? rect.hashCode;

    drawRoughLine(canvas, p1, p2, paint, roughness, opacity, seed: baseSeed);
    drawRoughLine(
      canvas,
      p2,
      p3,
      paint,
      roughness,
      opacity,
      seed: baseSeed + 1,
    );
    drawRoughLine(
      canvas,
      p3,
      p4,
      paint,
      roughness,
      opacity,
      seed: baseSeed + 2,
    );
    drawRoughLine(
      canvas,
      p4,
      p1,
      paint,
      roughness,
      opacity,
      seed: baseSeed + 3,
    );
  }

  static void drawRoughEllipse(
    Canvas canvas,
    Rect rect,
    Paint paint,
    double roughness,
    double opacity, {
    int? seed,
  }) {
    if (roughness == 0) {
      canvas.drawOval(rect, paint);
      return;
    }

    final random = math.Random(seed ?? rect.hashCode);

    Path generatePath(double r) {
      final path = Path();
      final center = rect.center;
      final rx = rect.width / 2;
      final ry = rect.height / 2;

      // Use 16 points for approximation
      final steps = 16;
      final angleStep = 2 * math.pi / steps;
      final startAngle = random.nextDouble() * 2 * math.pi;

      final points = <Offset>[];

      // Magnitude of wobble relative to size
      final magnitude = math.min(rx, ry) * 0.1 * r * 0.5;

      for (int i = 0; i < steps; i++) {
        final angle = startAngle + i * angleStep;

        // Jitter radius
        final currRx = rx + (random.nextDouble() - 0.5) * magnitude * 2;
        final currRy = ry + (random.nextDouble() - 0.5) * magnitude * 2;

        final x = center.dx + currRx * math.cos(angle);
        final y = center.dy + currRy * math.sin(angle);
        points.add(Offset(x, y));
      }

      if (points.isNotEmpty) {
        // Smooth curve using midpoints
        final p0 = points.last;
        final p1 = points.first;
        final mid = (p0 + p1) / 2;
        path.moveTo(mid.dx, mid.dy);

        for (int i = 0; i < points.length; i++) {
          final curr = points[i];
          final next = points[(i + 1) % points.length];
          final nextMid = (curr + next) / 2;

          path.quadraticBezierTo(curr.dx, curr.dy, nextMid.dx, nextMid.dy);
        }
      }

      return path;
    }

    canvas.drawPath(generatePath(roughness), paint);

    if (roughness >= 1.0) {
      canvas.drawPath(generatePath(roughness), paint);
    }
  }

  static void drawRoughDiamond(
    Canvas canvas,
    Rect rect,
    Paint paint,
    double roughness,
    double opacity, {
    int? seed,
  }) {
    if (roughness <= 0.01) {
      final path = Path()
        ..moveTo(rect.center.dx, rect.top)
        ..lineTo(rect.right, rect.center.dy)
        ..lineTo(rect.center.dx, rect.bottom)
        ..lineTo(rect.left, rect.center.dy)
        ..close();
      canvas.drawPath(path, paint);
      return;
    }

    final p1 = Offset(rect.center.dx, rect.top);
    final p2 = Offset(rect.right, rect.center.dy);
    final p3 = Offset(rect.center.dx, rect.bottom);
    final p4 = Offset(rect.left, rect.center.dy);

    final baseSeed = seed ?? rect.hashCode;

    drawRoughLine(canvas, p1, p2, paint, roughness, opacity, seed: baseSeed);
    drawRoughLine(
      canvas,
      p2,
      p3,
      paint,
      roughness,
      opacity,
      seed: baseSeed + 1,
    );
    drawRoughLine(
      canvas,
      p3,
      p4,
      paint,
      roughness,
      opacity,
      seed: baseSeed + 2,
    );
    drawRoughLine(
      canvas,
      p4,
      p1,
      paint,
      roughness,
      opacity,
      seed: baseSeed + 3,
    );
  }
}
