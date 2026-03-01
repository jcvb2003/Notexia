import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/factories/canvas_element_factory.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';

void main() {
  const origin = Offset(42, 84);

  group('CanvasElementFactory.create', () {
    test('creates shape with provided style attributes', () {
      final element = CanvasElementFactory.create(
        type: CanvasElementType.rectangle,
        id: 'rect-1',
        position: origin,
        strokeColor: Colors.blue,
        fillColor: Colors.green,
        strokeWidth: 3,
        strokeStyle: StrokeStyle.dotted,
        fillType: FillType.hachure,
        opacity: 0.5,
        roughness: 1.2,
      ) as RectangleElement;

      expect(element.id, 'rect-1');
      expect(element.x, origin.dx);
      expect(element.y, origin.dy);
      expect(element.strokeColor, Colors.blue);
      expect(element.fillColor, Colors.green);
      expect(element.strokeWidth, 3);
      expect(element.strokeStyle, StrokeStyle.dotted);
      expect(element.fillType, FillType.hachure);
      expect(element.opacity, 0.5);
      expect(element.roughness, 1.2);
      expect(element.width, 0);
      expect(element.height, 0);
    });

    test('creates text with default text dimensions', () {
      final element = CanvasElementFactory.create(
        type: CanvasElementType.text,
        id: 'text-1',
        position: origin,
      ) as TextElement;

      expect(element.x, origin.dx);
      expect(element.y, origin.dy);
      expect(element.width, 100);
      expect(element.height, 30);
      expect(element.text, '');
    });

    test('creates line-based tools with seed point at origin', () {
      final line = CanvasElementFactory.create(
        type: CanvasElementType.line,
        id: 'line-1',
        position: origin,
      ) as LineElement;
      final arrow = CanvasElementFactory.create(
        type: CanvasElementType.arrow,
        id: 'arrow-1',
        position: origin,
      ) as ArrowElement;
      final freeDraw = CanvasElementFactory.create(
        type: CanvasElementType.freeDraw,
        id: 'draw-1',
        position: origin,
      ) as FreeDrawElement;

      expect(line.points, const [Offset.zero]);
      expect(arrow.points, const [Offset.zero]);
      expect(freeDraw.points, const [Offset.zero]);
    });

    test('returns null for non-creatable tools', () {
      expect(
        CanvasElementFactory.create(
          type: CanvasElementType.selection,
          id: 'x',
          position: origin,
        ),
        isNull,
      );
      expect(
        CanvasElementFactory.create(
          type: CanvasElementType.navigation,
          id: 'x',
          position: origin,
        ),
        isNull,
      );
      expect(
        CanvasElementFactory.create(
          type: CanvasElementType.eraser,
          id: 'x',
          position: origin,
        ),
        isNull,
      );
      expect(
        CanvasElementFactory.create(
          type: CanvasElementType.image,
          id: 'x',
          position: origin,
        ),
        isNull,
      );
    });
  });
}
