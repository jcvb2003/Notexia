import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/eraser_delegate.dart';

void main() {
  final now = DateTime(2026, 1, 1);
  const delegate = EraserDelegate();

  group('EraserDelegate state lifecycle', () {
    test('setEraserMode updates mode', () {
      final result = delegate.setEraserMode(
        const InteractionState(),
        EraserMode.area,
      );

      expect(result.data!.eraser.mode, EraserMode.area);
    });

    test('startEraser activates eraser and seeds trail', () {
      final result =
          delegate.startEraser(const InteractionState(), const Offset(1, 2));

      expect(result.data!.eraser.isActive, isTrue);
      expect(result.data!.eraser.trail, const [Offset(1, 2)]);
    });

    test('updateEraserTrail appends points and caps to last 24 entries', () {
      InteractionState state = const InteractionState();
      for (int i = 0; i < 30; i++) {
        state = delegate
            .updateEraserTrail(state, Offset(i.toDouble(), 0))
            .data!;
      }

      expect(state.eraser.isActive, isTrue);
      expect(state.eraser.trail.length, 24);
      expect(state.eraser.trail.first, const Offset(6, 0));
      expect(state.eraser.trail.last, const Offset(29, 0));
    });

    test('endEraser clears active flag and trail', () {
      final active = delegate
          .startEraser(const InteractionState(), const Offset(3, 4))
          .data!;
      final ended = delegate.endEraser(active).data!;

      expect(ended.eraser.isActive, isFalse);
      expect(ended.eraser.trail, isEmpty);
    });
  });

  group('EraserDelegate.eraseElements', () {
    test('removes elements whose inflated bounds contain the pointer', () {
      final close = RectangleElement(
        id: 'close',
        x: 0,
        y: 0,
        width: 10,
        height: 10,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      final far = RectangleElement(
        id: 'far',
        x: 100,
        y: 100,
        width: 10,
        height: 10,
        strokeColor: Colors.black,
        updatedAt: now,
      );

      final result = delegate.eraseElements(
        [close, far],
        const Offset(12, 12),
        4,
      );

      expect(result.data!.map((e) => e.id).toList(), ['far']);
    });
  });
}
