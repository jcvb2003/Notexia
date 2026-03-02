import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';
import 'package:notexia/src/features/drawing/domain/services/object_snap_service.dart';

void main() {
  group('ObjectSnapService', () {
    final now = DateTime.now();

    RectangleElement rect(String id, Rect r) => RectangleElement(
          id: id,
          x: r.left,
          y: r.top,
          width: r.width,
          height: r.height,
          strokeColor: Colors.black,
          updatedAt: now,
        );

    test('snaps to aligned element within distance', () {
      final elements = [
        rect('e1', const Rect.fromLTWH(0, 0, 100, 100)),
      ];
      final targetRect = const Rect.fromLTWH(105, 5, 100, 100);

      final result = ObjectSnapService.snapMove(
        targetRect: targetRect,
        referenceElements: elements,
        excludedElementIds: const {},
        zoomLevel: 1.0,
      );

      // Alignment: 105 -> 100 (e1.right). Delta -5
      // Y: 5 -> 0 (e1.top). Delta -5
      expect(result.dx, -5.0);
      expect(result.dy, -5.0);
      expect(
          result.guides.any((g) => g.type == SnapGuideType.alignment), isTrue);
    });

    test('adaptive distance based on zoom', () {
      final elements = [
        rect('e1', const Rect.fromLTWH(0, 0, 100, 100)),
      ];
      final targetRect = const Rect.fromLTWH(106, 0, 100, 100);

      final resultZoom1 = ObjectSnapService.snapMove(
        targetRect: targetRect,
        referenceElements: elements,
        excludedElementIds: const {},
        zoomLevel: 1.0,
      );
      expect(resultZoom1.dx, -6.0); // Snapeia (6 < 8)

      final resultZoom2 = ObjectSnapService.snapMove(
        targetRect: targetRect,
        referenceElements: elements,
        excludedElementIds: const {},
        zoomLevel: 2.0,
      );
      expect(resultZoom2.dx, 0.0); // Não snapeia (6 > 4)
    });

    test('gap snap between three elements', () {
      final e1 = rect('1', const Rect.fromLTWH(0, 0, 100, 100));
      final e2 = rect('2', const Rect.fromLTWH(200, 0, 100, 100));
      final referenceElements = [e1, e2];

      final targetRect = const Rect.fromLTWH(395, 0, 100, 100);

      final result = ObjectSnapService.snapMove(
        targetRect: targetRect,
        referenceElements: referenceElements,
        excludedElementIds: const {},
        zoomLevel: 1.0,
      );

      // Deve snapar X para 400.0 (gap 100)
      expect(result.dx, 5.0);
      expect(result.guides.any((g) => g.type == SnapGuideType.gap), isTrue);
      expect(
          result.guides.firstWhere((g) => g.type == SnapGuideType.gap).gapValue,
          100.0);
    });
  });
}
