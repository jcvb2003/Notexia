import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_entities.dart';
import 'package:notexia/src/features/drawing/domain/services/canvas_manipulation_service.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';

void main() {
  final now = DateTime.parse('2025-01-01T12:00:00Z');
  late CanvasManipulationService service;

  setUp(() {
    service = CanvasManipulationService(TransformationService());
  });

  group('moveElements', () {
    test('move only selected elements by delta', () {
      final r1 = RectangleElement(
        id: 'r1',
        x: 10,
        y: 20,
        width: 100,
        height: 50,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      final e1 = EllipseElement(
        id: 'e1',
        x: 50,
        y: 60,
        width: 80,
        height: 80,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      final t1 = TextElement(
        id: 't1',
        x: 0,
        y: 0,
        width: 100,
        height: 40,
        strokeColor: Colors.black,
        updatedAt: now,
        text: 'Hello',
      );

      final elements = [r1, e1, t1];
      final moved = service.moveElements(
          elements,
          [
            'r1',
            't1',
          ],
          const Offset(5, -3));

      final movedR1 = moved.firstWhere((e) => e.id == 'r1');
      final movedT1 = moved.firstWhere((e) => e.id == 't1');
      final unchangedE1 = moved.firstWhere((e) => e.id == 'e1');

      expect(movedR1.x, 15);
      expect(movedR1.y, 17);
      expect(movedT1.x, 5);
      expect(movedT1.y, -3);
      expect(unchangedE1.x, 50);
      expect(unchangedE1.y, 60);

      expect(movedR1.updatedAt.isAtSameMomentAs(now), isFalse);
      expect(movedT1.updatedAt.isAtSameMomentAs(now), isFalse);
      expect(unchangedE1.updatedAt.isAtSameMomentAs(now), isTrue);
    });
  });

  group('deleteElements', () {
    test('remove selected elements from list', () {
      final r1 = RectangleElement(
        id: 'r1',
        x: 0,
        y: 0,
        width: 10,
        height: 10,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      final e1 = EllipseElement(
        id: 'e1',
        x: 0,
        y: 0,
        width: 10,
        height: 10,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      final t1 = TextElement(
        id: 't1',
        x: 0,
        y: 0,
        width: 10,
        height: 10,
        strokeColor: Colors.black,
        updatedAt: now,
        text: 'X',
      );

      final elements = [r1, e1, t1];
      final remaining = service.deleteElements(elements, [
        'r1',
        't1',
      ]);

      expect(remaining.length, 1);
      expect(remaining.first.id, 'e1');
    });
  });

  group('updateElementsProperties', () {
    test('update common style properties on selected elements', () {
      final r1 = RectangleElement(
        id: 'r1',
        x: 0,
        y: 0,
        width: 10,
        height: 10,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      final e1 = EllipseElement(
        id: 'e1',
        x: 0,
        y: 0,
        width: 10,
        height: 10,
        strokeColor: Colors.black,
        updatedAt: now,
      );

      final updated = service.updateElementsProperties(
        [r1, e1],
        ['r1'],
        const ElementStylePatch(
          strokeColor: Colors.blue,
          fillColor: Colors.green,
          strokeWidth: 3.5,
          strokeStyle: StrokeStyle.dashed,
          fillType: FillType.hachure,
          opacity: 0.6,
          roughness: 1.2,
        ),
      );

      final r1u = updated.firstWhere((e) => e.id == 'r1');
      final e1u = updated.firstWhere((e) => e.id == 'e1');

      expect(r1u.strokeColor, Colors.blue);
      expect(r1u.fillColor, Colors.green);
      expect(r1u.strokeWidth, 3.5);
      expect(r1u.strokeStyle, StrokeStyle.dashed);
      expect(r1u.fillType, FillType.hachure);
      expect(r1u.opacity, 0.6);
      expect(r1u.roughness, 1.2);
      expect(r1u.updatedAt.isAtSameMomentAs(now), isFalse);

      expect(e1u.strokeColor, Colors.black);
      expect(e1u.fillColor, isNull);
      expect(e1u.updatedAt.isAtSameMomentAs(now), isTrue);
    });

    test('update text-specific properties when element is TextElement', () {
      final t1 = TextElement(
        id: 't1',
        x: 0,
        y: 0,
        width: 100,
        height: 40,
        strokeColor: Colors.black,
        updatedAt: now,
        text: 'old',
      );

      final updated = service.updateElementsProperties(
        [t1],
        ['t1'],
        const ElementStylePatch(
          text: 'new text',
          fontFamily: 'Inter',
          fontSize: 24,
          textAlign: TextAlign.center,
          backgroundColor: Colors.yellow,
          isBold: true,
          isItalic: true,
          isUnderlined: true,
          isStrikethrough: true,
        ),
      );

      final t1u = updated.first as TextElement;
      expect(t1u.text, 'new text');
      expect(t1u.fontFamily, 'Inter');
      expect(t1u.fontSize, 24);
      expect(t1u.textAlign, TextAlign.center);
      expect(t1u.backgroundColor, Colors.yellow);
      expect(t1u.isBold, isTrue);
      expect(t1u.isItalic, isTrue);
      expect(t1u.isUnderlined, isTrue);
      expect(t1u.isStrikethrough, isTrue);
      expect(t1u.updatedAt.isAtSameMomentAs(now), isFalse);
    });
  });

  group('updateDrawingElement (shapes)', () {
    test('basic rectangle from corner', () {
      final rect = RectangleElement(
        id: 'r',
        x: 0,
        y: 0,
        width: 0,
        height: 0,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      final start = const Offset(10, 10);
      final current = const Offset(110, 60);
      final updated = service.updateDrawingElement(
        rect,
        current,
        startPosition: start,
      ) as RectangleElement;

      expect(updated.x, 10);
      expect(updated.y, 10);
      expect(updated.width, 100);
      expect(updated.height, 50);
      expect(updated.version, rect.version + 1);
    });

    test('keepAspect true (square)', () {
      final rect = RectangleElement(
        id: 'r',
        x: 0,
        y: 0,
        width: 0,
        height: 0,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      final start = const Offset(10, 10);
      final current = const Offset(110, 60);
      final updated = service.updateDrawingElement(
        rect,
        current,
        startPosition: start,
        keepAspect: true,
      ) as RectangleElement;

      expect(updated.x, 10);
      expect(updated.y, 10);
      expect(updated.width, 100);
      expect(updated.height, 100);
    });

    test('createFromCenter true', () {
      final rect = RectangleElement(
        id: 'r',
        x: 0,
        y: 0,
        width: 0,
        height: 0,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      final start = const Offset(10, 10);
      final current = const Offset(110, 60);
      final updated = service.updateDrawingElement(
        rect,
        current,
        startPosition: start,
        createFromCenter: true,
      ) as RectangleElement;

      expect(updated.x, -90);
      expect(updated.y, -40);
      expect(updated.width, 200);
      expect(updated.height, 100);
    });

    test('createFromCenter + keepAspect', () {
      final rect = RectangleElement(
        id: 'r',
        x: 0,
        y: 0,
        width: 0,
        height: 0,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      final start = const Offset(10, 10);
      final current = const Offset(110, 60);
      final updated = service.updateDrawingElement(
        rect,
        current,
        startPosition: start,
        createFromCenter: true,
        keepAspect: true,
      ) as RectangleElement;

      expect(updated.x, -90);
      expect(updated.y, -90);
      expect(updated.width, 200);
      expect(updated.height, 200);
    });
  });

  group('updateDrawingElement (line/arrow/freeDraw)', () {
    test('line with snapAngle true snaps to nearest angle step', () {
      final line = LineElement(
        id: 'l1',
        x: 0,
        y: 0,
        width: 0,
        height: 0,
        strokeColor: Colors.black,
        updatedAt: now,
        points: const [Offset(0, 0)],
      );
      final start = const Offset(20, 50);
      final delta = const Offset(70, 30);
      final current = start + delta;
      final updated = service.updateDrawingElement(
        line,
        current,
        startPosition: start,
        snapAngle: true,
      ) as LineElement;

      expect(updated.x, start.dx);
      expect(updated.y, start.dy);
      expect(updated.points.length, 2);
      final p = updated.points[1];
      final length = delta.distance;
      expect(p.dx, closeTo(math.cos(math.pi / 6) * length, 0.01));
      expect(p.dy, closeTo(math.sin(math.pi / 6) * length, 0.01));
      expect(updated.width, closeTo(p.dx, 0.01));
      expect(updated.height, closeTo(p.dy, 0.01));
    });

    test('arrow updates points without snapping', () {
      final arr = ArrowElement(
        id: 'a1',
        x: 0,
        y: 0,
        width: 0,
        height: 0,
        strokeColor: Colors.black,
        updatedAt: now,
        points: const [Offset(0, 0)],
      );
      final start = const Offset(0, 0);
      final current = const Offset(30, 40);
      final updated = service.updateDrawingElement(
        arr,
        current,
        startPosition: start,
        snapAngle: false,
      ) as ArrowElement;

      expect(updated.x, 0);
      expect(updated.y, 0);
      expect(updated.points.length, 2);
      expect(updated.points[1].dx, 30);
      expect(updated.points[1].dy, 40);
      expect(updated.width, 30);
      expect(updated.height, 40);
    });

    test('freeDraw adds points and normalizes bounding box', () {
      final fd = FreeDrawElement(
        id: 'fd1',
        x: 0,
        y: 0,
        width: 0,
        height: 0,
        strokeColor: Colors.black,
        updatedAt: now,
        points: const [],
      );
      final start = const Offset(10, 10);
      final current = const Offset(40, 50);
      final updated = service.updateDrawingElement(
        fd,
        current,
        startPosition: start,
      ) as FreeDrawElement;

      expect(updated.x, 40);
      expect(updated.y, 50);
      expect(updated.width, 0);
      expect(updated.height, 0);
      expect(updated.points.length, 1);
      expect(updated.points.first, const Offset(0, 0));
    });
  });
}
