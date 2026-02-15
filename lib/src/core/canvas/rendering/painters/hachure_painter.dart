import 'dart:ui';

class HachurePainter {
  static void drawHachure(
    Canvas canvas,
    Rect rect,
    Color color,
    double opacity,
    double strokeWidth, {
    bool crossHatch = false,
  }) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity * 0.5)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const gap = 8.0;

    canvas.save();
    canvas.clipRect(rect);

    for (double i = -rect.height * 2; i < rect.width * 2; i += gap) {
      canvas.drawLine(
        Offset(rect.left + i, rect.top),
        Offset(rect.left + i + rect.height, rect.bottom),
        paint,
      );
      if (crossHatch) {
        canvas.drawLine(
          Offset(rect.left + i + rect.height, rect.top),
          Offset(rect.left + i, rect.bottom),
          paint,
        );
      }
    }

    canvas.restore();
  }

  static void drawHachurePath(
    Canvas canvas,
    Path clipPath,
    Rect bounds,
    Color color,
    double opacity,
    double strokeWidth, {
    bool crossHatch = false,
  }) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity * 0.5)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const gap = 8.0;

    canvas.save();
    canvas.clipPath(clipPath);

    for (double i = -bounds.height * 2; i < bounds.width * 2; i += gap) {
      canvas.drawLine(
        Offset(bounds.left + i, bounds.top),
        Offset(bounds.left + i + bounds.height, bounds.bottom),
        paint,
      );
      if (crossHatch) {
        canvas.drawLine(
          Offset(bounds.left + i + bounds.height, bounds.top),
          Offset(bounds.left + i, bounds.bottom),
          paint,
        );
      }
    }

    canvas.restore();
  }
}
