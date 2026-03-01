import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';

void main() {
  final now = DateTime(2026, 1, 1);
  late TransformationService service;

  setUp(() {
    service = TransformationService();
  });

  test('moveElement updates position and increments version', () {
    final element = RectangleElement(
      id: 'r1',
      x: 10,
      y: 20,
      width: 30,
      height: 40,
      version: 2,
      strokeColor: Colors.black,
      updatedAt: now,
    );

    final moved = service.moveElement(element, 5, -7);

    expect(moved.x, 15);
    expect(moved.y, 13);
    expect(moved.version, 3);
    expect(moved.updatedAt.isAfter(now) || moved.updatedAt == now, isTrue);
  });

  test('resizeElement clamps width/height to minimum 1.0', () {
    final element = RectangleElement(
      id: 'r1',
      x: 0,
      y: 0,
      width: 30,
      height: 40,
      strokeColor: Colors.black,
      updatedAt: now,
    );

    final resized = service.resizeElement(element, 0.1, -50);

    expect(resized.width, 1.0);
    expect(resized.height, 1.0);
  });

  test('rotateElement updates angle and increments version', () {
    final element = RectangleElement(
      id: 'r1',
      x: 0,
      y: 0,
      width: 30,
      height: 40,
      version: 4,
      strokeColor: Colors.black,
      updatedAt: now,
    );

    final rotated = service.rotateElement(element, 1.5);

    expect(rotated.angle, 1.5);
    expect(rotated.version, 5);
    expect(rotated.updatedAt.isAfter(now) || rotated.updatedAt == now, isTrue);
  });

  test('updateLineOrArrowEndpoint returns same element for non-line element', () {
    final rect = RectangleElement(
      id: 'r1',
      x: 0,
      y: 0,
      width: 10,
      height: 10,
      strokeColor: Colors.black,
      updatedAt: now,
    );

    final result = service.updateLineOrArrowEndpoint(
      element: rect,
      isStart: true,
      worldPoint: const Offset(5, 5),
      snapAngle: true,
    );

    expect(result, same(rect));
  });
}
