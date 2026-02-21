import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/selection_delegate.dart';

void main() {
  late SelectionDelegate delegate;
  late CanvasState baseState;
  late CanvasElement rect1;
  late CanvasElement rect2;

  setUp(() {
    delegate = const SelectionDelegate();
    rect1 = CanvasElement.rectangle(
      id: 'rect1',
      x: 100,
      y: 100,
      width: 50,
      height: 50,
      strokeColor: Colors.black,
      updatedAt: DateTime.now(),
    );
    rect2 = CanvasElement.rectangle(
      id: 'rect2',
      x: 300,
      y: 300,
      width: 50,
      height: 50,
      strokeColor: Colors.red,
      updatedAt: DateTime.now(),
    );
    baseState = CanvasState(
      document: DrawingDocument(
        id: 'doc1',
        title: 'Test',
        elements: [rect1, rect2],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  });

  group('SelectionDelegate', () {
    group('setSelectionBox', () {
      test('sets selection box rect', () {
        const rect = Rect.fromLTWH(10, 10, 100, 100);
        final result = delegate.setSelectionBox(baseState, rect);
        expect(result.data!.transform.selectionBox, rect);
      });

      test('clears selection box when null', () {
        const rect = Rect.fromLTWH(10, 10, 100, 100);
        final withBox = delegate.setSelectionBox(baseState, rect).data!;
        final cleared = delegate.setSelectionBox(withBox, null).data!;
        expect(cleared.transform.selectionBox, isNull);
      });
    });

    group('selectElementAt', () {
      test('selects element when point is inside bounds', () {
        final result = delegate.selectElementAt(
          baseState,
          const Offset(125, 125),
        );
        expect(result.data!.selectedElementIds, {'rect1'});
      });

      test('clears selection when point is outside all elements', () {
        final result = delegate.selectElementAt(
          baseState,
          const Offset(500, 500),
        );
        expect(result.data!.selectedElementIds, isEmpty);
      });

      test('selects topmost element when elements overlap', () {
        final overlapping = CanvasElement.rectangle(
          id: 'overlap',
          x: 100,
          y: 100,
          width: 50,
          height: 50,
          strokeColor: Colors.blue,
          updatedAt: DateTime.now(),
        );
        final stateWithOverlap = baseState.copyWith(
          document: baseState.document.copyWith(
            elements: [rect1, overlapping],
          ),
        );
        final result = delegate.selectElementAt(
          stateWithOverlap,
          const Offset(125, 125),
        );
        // Should select the last element (topmost) since reversed iteration
        expect(result.data!.selectedElementIds, {'overlap'});
      });

      test('multi-select toggles element in selection', () {
        // First select rect1
        final withRect1 = delegate
            .selectElementAt(
              baseState,
              const Offset(125, 125),
            )
            .data!;
        expect(withRect1.selectedElementIds, {'rect1'});

        // Multi-select rect2
        final withBoth = delegate
            .selectElementAt(
              withRect1,
              const Offset(325, 325),
              isMultiSelect: true,
            )
            .data!;
        expect(withBoth.selectedElementIds, {'rect1', 'rect2'});

        // Multi-select rect1 again toggles it off
        final withOnlyRect2 = delegate
            .selectElementAt(
              withBoth,
              const Offset(125, 125),
              isMultiSelect: true,
            )
            .data!;
        expect(withOnlyRect2.selectedElementIds, {'rect2'});
      });

      test('multi-select on empty area does not clear selection', () {
        final withRect1 = delegate
            .selectElementAt(
              baseState,
              const Offset(125, 125),
            )
            .data!;
        final result = delegate.selectElementAt(
          withRect1,
          const Offset(500, 500),
          isMultiSelect: true,
        );
        expect(result.data!.selectedElementIds, {'rect1'});
      });

      test('does not re-select already selected element', () {
        final selected = delegate
            .selectElementAt(
              baseState,
              const Offset(125, 125),
            )
            .data!;
        final reselected = delegate
            .selectElementAt(
              selected,
              const Offset(125, 125),
            )
            .data!;
        expect(identical(selected, reselected), isTrue);
      });
    });

    group('selectElementsInRect', () {
      test('selects elements overlapping selection rectangle', () {
        const selectionRect = Rect.fromLTWH(90, 90, 70, 70);
        final result = delegate.selectElementsInRect(baseState, selectionRect);
        expect(result.data!.selectedElementIds, {'rect1'});
      });

      test('selects multiple elements in large rectangle', () {
        const selectionRect = Rect.fromLTWH(0, 0, 400, 400);
        final result = delegate.selectElementsInRect(baseState, selectionRect);
        expect(result.data!.selectedElementIds, {'rect1', 'rect2'});
      });

      test('returns empty set when no elements overlap', () {
        const selectionRect = Rect.fromLTWH(500, 500, 50, 50);
        final result = delegate.selectElementsInRect(baseState, selectionRect);
        expect(result.data!.selectedElementIds, isEmpty);
      });
    });

    group('setHoveredElement', () {
      test('sets hovered element id', () {
        final result = delegate.setHoveredElement(baseState, 'rect1');
        expect(result.data!.hoveredElementId, 'rect1');
      });

      test('clears hovered element id', () {
        final hovered = delegate.setHoveredElement(baseState, 'rect1').data!;
        final cleared = delegate.setHoveredElement(hovered, null).data!;
        expect(cleared.hoveredElementId, isNull);
      });
    });
  });
}
