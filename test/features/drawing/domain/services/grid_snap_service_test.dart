import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';
import 'package:notexia/src/features/drawing/domain/services/grid_snap_service.dart';

void main() {
  group('GridSnapService', () {
    const double gridSize = 20.0;

    test('snaps top-left to nearest grid point', () {
      const rect = Rect.fromLTWH(18.0, 22.0, 100.0, 100.0);

      final result = GridSnapService.snapRectToGrid(
        rect: rect,
        gridSize: gridSize,
      );

      // 18.0 -> 20.0 (delta +2)
      // 22.0 -> 20.0 (delta -2)
      expect(result.dx, 2.0);
      expect(result.dy, -2.0);
      expect(result.guides.length, 2);
      expect(result.guides[0].type, SnapGuideType.grid);
    });

    test('returns empty result when already on grid', () {
      const rect = Rect.fromLTWH(40.0, 80.0, 100.0, 100.0);

      final result = GridSnapService.snapRectToGrid(
        rect: rect,
        gridSize: gridSize,
      );

      expect(result.dx, 0.0);
      expect(result.dy, 0.0);
      expect(result.guides, isEmpty);
    });

    test('returns empty result for invalid grid size', () {
      const rect = Rect.fromLTWH(18.0, 22.0, 100.0, 100.0);

      final result = GridSnapService.snapRectToGrid(
        rect: rect,
        gridSize: 0,
      );

      expect(result.dx, 0.0);
      expect(result.dy, 0.0);
    });

    test('emits horizontal guide for Y snap and vertical for X snap', () {
      const rect = Rect.fromLTWH(18.0, 80.0, 100.0, 100.0);

      final result = GridSnapService.snapRectToGrid(
        rect: rect,
        gridSize: gridSize,
      );

      expect(result.dx, 2.0);
      expect(result.dy, 0.0);
      expect(result.guides.length, 1);
      expect(result.guides[0].isVertical, isTrue);
      expect(result.guides[0].offset, 20.0);
    });
  });
}
