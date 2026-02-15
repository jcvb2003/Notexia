import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/text_element.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/element_renderer.dart';

class TextRenderer implements ElementRenderer<TextElement> {
  @override
  void render(Canvas canvas, TextElement element) {
    if (element.text.isEmpty) return;

    if (element.backgroundColor != null && element.backgroundColor != Colors.transparent) {
      final paint = Paint()
        ..color = element.backgroundColor!
        ..style = PaintingStyle.fill;
      const horizontalPadding = 6.0;
      final rect = Rect.fromLTWH(
        element.x - horizontalPadding,
        element.y,
        element.width + (horizontalPadding * 2),
        element.height,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(element.backgroundRadius)),
        paint,
      );
    }

    final textSpan = TextSpan(
      text: element.text,
      style: TextStyle(
        color: element.strokeColor.withValues(alpha: element.opacity),
        fontSize: element.fontSize,
        fontFamily: element.fontFamily,
        fontWeight: element.isBold ? FontWeight.bold : FontWeight.normal,
        fontStyle: element.isItalic ? FontStyle.italic : FontStyle.normal,
        decoration: TextDecoration.combine([
          if (element.isUnderlined) TextDecoration.underline,
          if (element.isStrikethrough) TextDecoration.lineThrough,
        ]),
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: element.textAlign,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: element.width > 0 ? element.width : double.infinity);
    textPainter.paint(canvas, Offset(element.x, element.y));
  }
}

