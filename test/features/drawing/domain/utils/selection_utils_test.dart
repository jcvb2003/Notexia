import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/utils/selection_utils.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

void main() {
  group('SelectionUtils', () {
    test('isLineElementType returns true for line and arrow', () {
      expect(SelectionUtils.isLineElementType(CanvasElementType.line), isTrue);
      expect(SelectionUtils.isLineElementType(CanvasElementType.arrow), isTrue);
      expect(
        SelectionUtils.isLineElementType(CanvasElementType.rectangle),
        isFalse,
      );
    });

    test('isResizableElementType returns true for shapes and text/image', () {
      expect(
        SelectionUtils.isResizableElementType(CanvasElementType.rectangle),
        isTrue,
      );
      expect(
        SelectionUtils.isResizableElementType(CanvasElementType.ellipse),
        isTrue,
      );
      expect(
        SelectionUtils.isResizableElementType(CanvasElementType.diamond),
        isTrue,
      );
      expect(
        SelectionUtils.isResizableElementType(CanvasElementType.triangle),
        isTrue,
      );
      expect(
        SelectionUtils.isResizableElementType(CanvasElementType.text),
        isTrue,
      );
      expect(
        SelectionUtils.isResizableElementType(CanvasElementType.image),
        isTrue,
      );
      expect(
        SelectionUtils.isResizableElementType(CanvasElementType.line),
        isFalse,
      );
      expect(
        SelectionUtils.isResizableElementType(CanvasElementType.arrow),
        isFalse,
      );
      expect(
        SelectionUtils.isResizableElementType(CanvasElementType.freeDraw),
        isFalse,
      );
    });

    test('lineEndpoints for LineElement returns absolute endpoints', () {
      final line = LineElement(
        id: 'l1',
        x: 10,
        y: 20,
        width: 100,
        height: 0,
        strokeColor: const Color(0xff000000),
        updatedAt: DateTime.now(),
        points: const [Offset(0, 0), Offset(100, 0)],
      );
      final endpoints = SelectionUtils.lineEndpoints(line)!;
      expect(endpoints.$1, const Offset(10, 20));
      expect(endpoints.$2, const Offset(110, 20));
    });

    test('lineEndpoints for ArrowElement returns absolute endpoints', () {
      final arr = ArrowElement(
        id: 'a1',
        x: 5,
        y: 6,
        width: 100,
        height: 0,
        strokeColor: const Color(0xff000000),
        updatedAt: DateTime.now(),
        points: const [Offset(0, 0), Offset(20, 10)],
      );
      final endpoints = SelectionUtils.lineEndpoints(arr)!;
      expect(endpoints.$1, const Offset(5, 6));
      expect(endpoints.$2, const Offset(25, 16));
    });

    test(
      'computeRotateHandleCenter returns topCenter adjusted by offset/zoom',
      () {
        const rect = Rect.fromLTWH(0, 0, 100, 100);
        final center = SelectionUtils.computeRotateHandleCenter(
          rect,
          2.0,
          rotateOffset: 24.0,
        );
        // topCenter is (50, 0); adjusted dy is -24/2 = -12
        expect(center, const Offset(50, -12));
      },
    );
  });
}
