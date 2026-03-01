import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';
import 'package:notexia/src/features/drawing/domain/services/canvas_manipulation_service.dart';
import 'package:notexia/src/features/drawing/domain/services/geometry_service.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';

void main() {
  final transformation = TransformationService();
  final manipulation = CanvasManipulationService(transformation);

  bool isFiniteAndNotNaN(double v) => v.isFinite && !v.isNaN;

  test('randomized operations preserve geometric invariants', () {
    final rand = math.Random(42);
    var elements = List<CanvasElement>.generate(
      20,
      (i) => RectangleElement(
        id: 'r$i',
        x: rand.nextDouble() * 500,
        y: rand.nextDouble() * 500,
        width: rand.nextDouble() * 120 + 5,
        height: rand.nextDouble() * 120 + 5,
        strokeColor: Colors.black,
        updatedAt: DateTime(2026, 1, 1),
      ),
    );

    for (int step = 0; step < 400; step++) {
      final selected =
          elements.where((_) => rand.nextBool()).map((e) => e.id).toSet();
      final op = rand.nextInt(5);

      switch (op) {
        case 0:
          elements = manipulation.moveElements(
            elements,
            selected,
            Offset(rand.nextDouble() * 20 - 10, rand.nextDouble() * 20 - 10),
          );
          break;
        case 1:
          elements = manipulation.updateElementsProperties(
            elements,
            selected,
            ElementStylePatch(
              strokeWidth: rand.nextDouble() * 10 + 1,
              opacity: rand.nextDouble(),
              roughness: rand.nextDouble() * 5,
              strokeStyle:
                  StrokeStyle.values[rand.nextInt(StrokeStyle.values.length)],
            ),
          );
          break;
        case 2:
          elements = elements
              .map((e) => selected.contains(e.id)
                  ? transformation.rotateElement(
                      e,
                      rand.nextDouble() * math.pi * 2 - math.pi,
                    )
                  : e)
              .toList();
          break;
        case 3:
          elements = elements
              .map((e) => selected.contains(e.id)
                  ? transformation.resizeAndPlace(
                      e,
                      Rect.fromLTWH(
                        e.x + rand.nextDouble() * 10 - 5,
                        e.y + rand.nextDouble() * 10 - 5,
                        rand.nextDouble() * 200,
                        rand.nextDouble() * 200,
                      ),
                    )
                  : e)
              .toList();
          break;
        case 4:
          elements = manipulation.deleteElements(elements, selected);
          break;
      }

      for (final e in elements) {
        expect(isFiniteAndNotNaN(e.x), isTrue,
            reason: 'x invalid at step $step id=${e.id}');
        expect(isFiniteAndNotNaN(e.y), isTrue,
            reason: 'y invalid at step $step id=${e.id}');
        expect(isFiniteAndNotNaN(e.width), isTrue,
            reason: 'w invalid at step $step id=${e.id}');
        expect(isFiniteAndNotNaN(e.height), isTrue,
            reason: 'h invalid at step $step id=${e.id}');
        expect(isFiniteAndNotNaN(e.angle), isTrue,
            reason: 'angle invalid at step $step id=${e.id}');
        expect(e.width >= 0, isTrue,
            reason: 'negative width at step $step id=${e.id}');
        expect(e.height >= 0, isTrue,
            reason: 'negative height at step $step id=${e.id}');
        expect(e.opacity >= 0 && e.opacity <= 1, isTrue,
            reason: 'opacity out of range at step $step id=${e.id}');
      }
    }
  });

  test('randomized line endpoint updates keep normalized finite geometry', () {
    final rand = math.Random(99);
    CanvasElement line = LineElement(
      id: 'line',
      x: 100,
      y: 100,
      width: 100,
      height: 0,
      strokeColor: Colors.black,
      updatedAt: DateTime(2026, 1, 1),
      points: const [Offset(0, 0), Offset(100, 0)],
    );

    for (int i = 0; i < 300; i++) {
      line = transformation.updateLineOrArrowEndpoint(
        element: line,
        isStart: rand.nextBool(),
        worldPoint: Offset(
          rand.nextDouble() * 800 - 200,
          rand.nextDouble() * 800 - 200,
        ),
        snapAngle: rand.nextBool(),
      );

      final l = line as LineElement;
      expect(l.points.length, 2);
      expect(isFiniteAndNotNaN(l.x), isTrue);
      expect(isFiniteAndNotNaN(l.y), isTrue);
      expect(isFiniteAndNotNaN(l.width), isTrue);
      expect(isFiniteAndNotNaN(l.height), isTrue);
      expect(l.width >= 0, isTrue);
      expect(l.height >= 0, isTrue);
    }
  });

  test('randomized geometry hit-tests do not throw on mixed elements', () {
    final rand = math.Random(7);
    final elements = <CanvasElement>[
      RectangleElement(
        id: 'r',
        x: 50,
        y: 60,
        width: 120,
        height: 80,
        angle: 0.4,
        strokeColor: Colors.black,
        updatedAt: DateTime(2026, 1, 1),
      ),
      EllipseElement(
        id: 'e',
        x: 300,
        y: 200,
        width: 90,
        height: 60,
        strokeColor: Colors.black,
        updatedAt: DateTime(2026, 1, 1),
      ),
      TriangleElement(
        id: 't',
        x: 180,
        y: 100,
        width: 70,
        height: 70,
        strokeColor: Colors.black,
        updatedAt: DateTime(2026, 1, 1),
      ),
      ArrowElement(
        id: 'a',
        x: 400,
        y: 300,
        width: 120,
        height: 40,
        strokeColor: Colors.black,
        updatedAt: DateTime(2026, 1, 1),
        points: const [Offset(0, 0), Offset(120, 40)],
      ),
    ];

    for (int i = 0; i < 1000; i++) {
      final p =
          Offset(rand.nextDouble() * 800 - 200, rand.nextDouble() * 800 - 200);
      for (final e in elements) {
        final hit = GeometryService.containsPoint(e, p);
        expect(hit == true || hit == false, isTrue);
      }
    }
  });
}
