import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/utils/resize_math_utils.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

void main() {
  group('ResizeMathUtils.toLocalForElement', () {
    test('sem rotação retorna o mesmo ponto', () {
      final el = CanvasElement.rectangle(
        id: 'r1',
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        strokeColor: const Color(0xff000000),
        updatedAt: DateTime.now(),
        angle: 0,
      );
      const p = Offset(150, 50);
      final local = ResizeMathUtils.toLocalForElement(p, el);
      expect(local, p);
    });

    test('com rotação pi/2 ajusta o ponto para o frame local', () {
      final el = CanvasElement.rectangle(
        id: 'r2',
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        strokeColor: const Color(0xff000000),
        updatedAt: DateTime.now(),
        angle: math.pi / 2,
      );
      final center = el.bounds.center;
      final p = center + const Offset(100, 0);
      final local = ResizeMathUtils.toLocalForElement(p, el);
      expect(local.dx, closeTo(center.dx, 0.01));
      expect(local.dy, lessThan(center.dy));
    });
  });

  group('ResizeMathUtils.resizeFromEdge', () {
    test('left sem keepAspect altera apenas largura respeitando minSize', () {
      const start = Rect.fromLTWH(0, 0, 100, 50);
      final next = ResizeMathUtils.resizeFromEdge(
        ResizeHandleType.left,
        start,
        const Offset(10, 0),
        keepAspect: false,
        minSize: 20,
      );
      expect(next.left, 10);
      expect(next.right, 100);
      expect(next.top, 0);
      expect(next.bottom, 50);
      expect(next.width, 90);
    });

    test('left com keepAspect ajusta altura em torno do centro', () {
      const start = Rect.fromLTWH(0, 0, 100, 50);
      final next = ResizeMathUtils.resizeFromEdge(
        ResizeHandleType.right,
        start,
        const Offset(150, 0),
        keepAspect: true,
        minSize: 10,
      );
      expect(next.width, 150);
      final aspect = start.width / start.height;
      final expectedHeight = math.max(next.width / aspect, 10);
      expect(next.height, closeTo(expectedHeight, 0.01));
      final centerY = start.center.dy;
      expect(next.top, closeTo(centerY - expectedHeight / 2, 0.01));
      expect(next.bottom, closeTo(centerY + expectedHeight / 2, 0.01));
    });

    test('minSize aplicado quando width fica menor que limite', () {
      const start = Rect.fromLTWH(0, 0, 100, 50);
      final next = ResizeMathUtils.resizeFromEdge(
        ResizeHandleType.left,
        start,
        const Offset(99, 0),
        keepAspect: false,
        minSize: 20,
      );
      expect(next.width, 20);
    });
  });

  group('ResizeMathUtils.resizeFromHandle', () {
    test('topLeft sem keepAspect recalcula bounding box', () {
      const start = Rect.fromLTWH(0, 0, 100, 100);
      final next = ResizeMathUtils.resizeFromHandle(
        ResizeHandleType.topLeft,
        start,
        const Offset(-50, -50),
        keepAspect: false,
        minSize: 10,
      );
      expect(next.left, -50);
      expect(next.top, -50);
      expect(next.right, 100);
      expect(next.bottom, 100);
      expect(next.width, 150);
      expect(next.height, 150);
    });

    test('bottomRight com keepAspect preserva razão largura/altura', () {
      const start = Rect.fromLTWH(0, 0, 80, 40);
      final next = ResizeMathUtils.resizeFromHandle(
        ResizeHandleType.bottomRight,
        start,
        const Offset(140, 100),
        keepAspect: true,
        minSize: 10,
      );
      final aspect = start.width / start.height;
      expect((next.width / next.height), closeTo(aspect, 0.01));
    });
  });
}
