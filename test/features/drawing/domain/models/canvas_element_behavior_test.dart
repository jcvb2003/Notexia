import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

void main() {
  final now = DateTime(2026, 1, 1);

  test('isResizable is false only for free draw', () {
    final elements = <CanvasElement>[
      RectangleElement(
        id: 'r',
        x: 0,
        y: 0,
        width: 1,
        height: 1,
        strokeColor: Colors.black,
        updatedAt: now,
      ),
      EllipseElement(
        id: 'e',
        x: 0,
        y: 0,
        width: 1,
        height: 1,
        strokeColor: Colors.black,
        updatedAt: now,
      ),
      DiamondElement(
        id: 'd',
        x: 0,
        y: 0,
        width: 1,
        height: 1,
        strokeColor: Colors.black,
        updatedAt: now,
      ),
      TriangleElement(
        id: 't',
        x: 0,
        y: 0,
        width: 1,
        height: 1,
        strokeColor: Colors.black,
        updatedAt: now,
      ),
      LineElement(
        id: 'l',
        x: 0,
        y: 0,
        width: 1,
        height: 1,
        strokeColor: Colors.black,
        updatedAt: now,
        points: const [Offset.zero, Offset(1, 1)],
      ),
      ArrowElement(
        id: 'a',
        x: 0,
        y: 0,
        width: 1,
        height: 1,
        strokeColor: Colors.black,
        updatedAt: now,
        points: const [Offset.zero, Offset(1, 1)],
      ),
      TextElement(
        id: 'txt',
        x: 0,
        y: 0,
        width: 1,
        height: 1,
        strokeColor: Colors.black,
        updatedAt: now,
        text: 'x',
      ),
      FreeDrawElement(
        id: 'fd',
        x: 0,
        y: 0,
        width: 1,
        height: 1,
        strokeColor: Colors.black,
        updatedAt: now,
        points: const [Offset.zero, Offset(1, 1)],
      ),
    ];

    final nonResizable = elements.where((e) => !e.isResizable).toList();
    expect(nonResizable.length, 1);
    expect(nonResizable.single, isA<FreeDrawElement>());
  });

  test('isLineType is true for line, arrow and free draw only', () {
    final line = LineElement(
      id: 'l',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      strokeColor: Colors.black,
      updatedAt: now,
      points: const [Offset.zero, Offset(1, 1)],
    );
    final arrow = ArrowElement(
      id: 'a',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      strokeColor: Colors.black,
      updatedAt: now,
      points: const [Offset.zero, Offset(1, 1)],
    );
    final freeDraw = FreeDrawElement(
      id: 'fd',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      strokeColor: Colors.black,
      updatedAt: now,
      points: const [Offset.zero, Offset(1, 1)],
    );
    final rectangle = RectangleElement(
      id: 'r',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      strokeColor: Colors.black,
      updatedAt: now,
    );

    expect(line.isLineType, isTrue);
    expect(arrow.isLineType, isTrue);
    expect(freeDraw.isLineType, isTrue);
    expect(rectangle.isLineType, isFalse);
  });
}
