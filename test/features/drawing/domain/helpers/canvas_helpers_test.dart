import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';

import 'package:notexia/src/features/drawing/domain/helpers/canvas_helpers.dart';
import 'package:notexia/src/features/drawing/domain/commands/elements_command.dart';

void main() {
  group('CanvasHelpers', () {
    // --- Mock Data ---
    final element1 = CanvasElement.rectangle(
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

    final element2 = CanvasElement.rectangle(
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

    group('buildElementsCommand', () {
      test('should return ElementsCommand when elements are added', () {
        final List<CanvasElement> before = [element1];
        final List<CanvasElement> after = [element1, element2];

        final command = CanvasHelpers.buildElementsCommand(
          label: 'Add',
          before: before,
          after: after,
          applyCallback: (_) {},
        );

        expect(command, isA<ElementsCommand>());
        expect((command as ElementsCommand).label, 'Add');
      });

      test('should return ElementsCommand when elements are removed', () {
        final List<CanvasElement> before = [element1, element2];
        final List<CanvasElement> after = [element1];

        final command = CanvasHelpers.buildElementsCommand(
          label: 'Remove',
          before: before,
          after: after,
          applyCallback: (_) {},
        );

        expect(command, isA<ElementsCommand>());
        expect((command as ElementsCommand).label, 'Remove');
      });

      test('should return ElementsCommand when sizes are equal', () {
        final movedElement = element1.copyWith(x: 20);
        final List<CanvasElement> before = [element1];
        final List<CanvasElement> after = [movedElement];

        final command = CanvasHelpers.buildElementsCommand(
          label: 'Move',
          before: before,
          after: after,
          applyCallback: (_) {},
        );

        expect(command, isA<ElementsCommand>());
        expect((command as ElementsCommand).label, 'Move');
      });
    });
  });
}
