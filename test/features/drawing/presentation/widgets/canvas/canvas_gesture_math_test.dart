import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/utils/resize_math_utils.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_gesture_math.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/selection_handles.dart';

void main() {
  final now = DateTime(2026, 1, 1);

  group('CanvasGestureMath.toLocalForElement', () {
    test('matches ResizeMathUtils conversion for rotated element', () {
      final element = RectangleElement(
        id: 'r1',
        x: 100,
        y: 100,
        width: 80,
        height: 40,
        angle: math.pi / 4,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      const world = Offset(120, 110);

      final localFromGesture = CanvasGestureMath.toLocalForElement(world, element);
      final localFromResize = ResizeMathUtils.toLocalForElement(world, element);

      expect(localFromGesture.dx, closeTo(localFromResize.dx, 0.0001));
      expect(localFromGesture.dy, closeTo(localFromResize.dy, 0.0001));
    });
  });

  group('CanvasGestureMath.resizeFromHandle', () {
    test('maps top-right handle to expected rect expansion', () {
      const startRect = Rect.fromLTWH(10, 10, 50, 40);
      const dragPoint = Offset(80, 0);

      final resized = CanvasGestureMath.resizeFromHandle(
        SelectionHandle.topRight,
        startRect,
        dragPoint,
        keepAspect: false,
      );

      expect(resized.left, 10);
      expect(resized.right, 80);
      expect(resized.top, 0);
      expect(resized.bottom, 50);
    });

    test('respects keepAspect when resizing from corner', () {
      const startRect = Rect.fromLTWH(0, 0, 100, 50);
      const dragPoint = Offset(180, 120);

      final resized = CanvasGestureMath.resizeFromHandle(
        SelectionHandle.bottomRight,
        startRect,
        dragPoint,
        keepAspect: true,
      );

      final ratio = resized.width / resized.height;
      expect(ratio, closeTo(2.0, 0.01));
    });
  });

  group('CanvasGestureMath.snapAngle', () {
    test('returns original angle when snapping is disabled', () {
      expect(CanvasGestureMath.snapAngle(0.73, false, 0.2), 0.73);
    });

    test('snaps angle when enabled', () {
      final snapped = CanvasGestureMath.snapAngle(0.73, true, 0.2);
      expect(snapped, 0.8);
    });
  });
}
