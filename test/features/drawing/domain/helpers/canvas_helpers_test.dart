import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/rectangle_element.dart';
import 'package:notexia/src/features/drawing/domain/helpers/canvas_helpers.dart';
import 'package:notexia/src/features/drawing/domain/commands/add_element_command.dart';
import 'package:notexia/src/features/drawing/domain/commands/remove_element_command.dart';
import 'package:notexia/src/features/drawing/domain/commands/transform_element_command.dart';

void main() {
  group('CanvasHelpers', () {
    // --- Mock Data ---
    final element1 = RectangleElement(
      id: '1',
      x: 10,
      y: 10,
      width: 50,
      height: 50,
      strokeColor: Colors.black,
      fillColor: Colors.transparent,
      fillType: FillType.hachure,
      strokeWidth: 1,
      strokeStyle: StrokeStyle.solid,
      roughness: 1,
      opacity: 1,
      angle: 0,
      updatedAt: DateTime.now(),
    );

    final element2 = RectangleElement(
      id: '2',
      x: 100,
      y: 100,
      width: 50,
      height: 50,
      strokeColor: Colors.black,
      fillColor: Colors.transparent,
      fillType: FillType.hachure,
      strokeWidth: 1,
      strokeStyle: StrokeStyle.solid,
      roughness: 1,
      opacity: 1,
      angle: 0,
      updatedAt: DateTime.now(),
    );

    group('moveElements', () {
      test('should move selected elements by delta', () {
        final elements = [element1, element2];
        final selectedIds = ['1'];
        const delta = Offset(20, 30);

        final result = CanvasHelpers.moveElements(elements, selectedIds, delta);

        // Element 1 should have moved
        expect(result[0].x, 30); // 10 + 20
        expect(result[0].y, 40); // 10 + 30
        expect(result[0].id, '1');

        // Element 2 should stay same
        expect(result[1].x, 100);
        expect(result[1].y, 100);
        expect(result[1].id, '2');
      });

      test('should return same list if selectedIds is empty', () {
        final elements = [element1, element2];
        final result = CanvasHelpers.moveElements(
          elements,
          [],
          const Offset(10, 10),
        );
        expect(result.length, 2);
        expect(result[0].x, 10);
      });
    });

    group('buildElementsCommand', () {
      test('should return AddElementCommand when elements are added', () {
        final List<CanvasElement> before = [element1];
        final List<CanvasElement> after = [element1, element2];

        final command = CanvasHelpers.buildElementsCommand(
          label: 'Add',
          before: before,
          after: after,
          applyCallback: (_) {},
        );

        expect(command, isA<AddElementCommand>());
      });

      test('should return RemoveElementCommand when elements are removed', () {
        final List<CanvasElement> before = [element1, element2];
        final List<CanvasElement> after = [element1];

        final command = CanvasHelpers.buildElementsCommand(
          label: 'Remove',
          before: before,
          after: after,
          applyCallback: (_) {},
        );

        expect(command, isA<RemoveElementCommand>());
      });

      test('should return TransformElementCommand when sizes are equal', () {
        final movedElement = element1.copyWith(x: 20);
        final List<CanvasElement> before = [element1];
        final List<CanvasElement> after = [movedElement];

        final command = CanvasHelpers.buildElementsCommand(
          label: 'Move',
          before: before,
          after: after,
          applyCallback: (_) {},
        );

        expect(command, isA<TransformElementCommand>());
      });
    });
  });
}
