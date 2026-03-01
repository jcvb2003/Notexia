import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/handlers/selection_hit_tester.dart';

void main() {
  final now = DateTime(2026, 1, 1);

  group('SelectionHitTester.hitTestHandle', () {
    test('returns lineStart for line endpoint hit', () {
      final line = LineElement(
        id: 'l1',
        x: 100,
        y: 100,
        width: 50,
        height: 0,
        strokeColor: Colors.black,
        updatedAt: now,
        points: const [Offset(0, 0), Offset(50, 0)],
      );
      final state = _state();

      final handle = SelectionHitTester.hitTestHandle(
        const Offset(100, 100),
        state,
        line,
      );

      expect(handle, SelectionHandle.lineStart);
    });

    test('returns rotate handle when pointer is near rotate hotspot', () {
      final rect = RectangleElement(
        id: 'r1',
        x: 100,
        y: 100,
        width: 80,
        height: 40,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      final state = _state();
      final inflated = rect.bounds.inflate(6 / state.zoomLevel);
      final rotateCenter = Offset(
        inflated.topCenter.dx,
        inflated.topCenter.dy - 24 / state.zoomLevel,
      );

      final handle = SelectionHitTester.hitTestHandle(
        rotateCenter,
        state,
        rect,
      );

      expect(handle, SelectionHandle.rotate);
    });

    test('returns null for non-resizable non-line tools', () {
      final element = FreeDrawElement(
        id: 'fd-1',
        x: 0,
        y: 0,
        width: 10,
        height: 10,
        strokeColor: Colors.black,
        updatedAt: now,
        points: const [Offset.zero, Offset(10, 10)],
      );
      final handle = SelectionHitTester.hitTestHandle(
        const Offset(0, 0),
        _state(),
        element,
      );
      expect(handle, isNull);
    });
  });
}

CanvasState _state() {
  final now = DateTime(2026, 1, 1);
  return CanvasState(
    document: DrawingDocument(
      id: 'doc-1',
      title: 'Doc',
      elements: const [],
      createdAt: now,
      updatedAt: now,
    ),
  );
}
