import 'package:flutter/material.dart';
import '../../canvas/rendering/painters/dashed_painter.dart';

class LineStyleIcon extends StatelessWidget {
  final Color? color;
  final LineStyleType type;

  const LineStyleIcon.solid({super.key, this.color})
      : type = LineStyleType.solid;
  const LineStyleIcon.dashed({super.key, this.color})
      : type = LineStyleType.dashed;
  const LineStyleIcon.dotted({super.key, this.color})
      : type = LineStyleType.dotted;

  @override
  Widget build(BuildContext context) {
    final iconColor =
        color ?? Theme.of(context).iconTheme.color ?? Colors.black;

    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _LineStylePainter(
          color: iconColor,
          type: type,
        ),
      ),
    );
  }
}

enum LineStyleType { solid, dashed, dotted }

class _LineStylePainter extends CustomPainter {
  final Color color;
  final LineStyleType type;

  _LineStylePainter({required this.color, required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final y = size.height / 2;
    final startX = 2.0;
    final endX = size.width - 2.0;

    switch (type) {
      case LineStyleType.solid:
        canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);
        break;
      case LineStyleType.dashed:
        // Ajustado para ~3 traços com peso visual equilibrado
        const dashWidth = 5.0;
        const dashSpace = 2.5;
        DashedPainter.drawDashedLine(
          canvas,
          Offset(startX, y),
          Offset(endX, y),
          paint,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
        );
        break;
      case LineStyleType.dotted:
        // Pontos levemente maiores (radius 1.5) para compensar leveza visual
        final dotPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;

        final distance = endX - startX;
        const dotSpacing = 6.0;
        final numDots = (distance / dotSpacing).floor();

        for (int i = 0; i <= numDots; i++) {
          final x = startX + (i * dotSpacing);
          canvas.drawCircle(Offset(x, y), 1.5, dotPaint);
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _LineStylePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.type != type;
  }
}
