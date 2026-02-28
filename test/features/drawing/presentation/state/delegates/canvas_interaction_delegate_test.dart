import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/canvas_interaction_delegate.dart';
import 'package:notexia/src/features/drawing/domain/services/canvas_manipulation_service.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';

class MockCanvasManipulationService extends Mock
    implements CanvasManipulationService {}

class MockTransformationService extends Mock implements TransformationService {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Offset(0, 0));
    registerFallbackValue(const Rect.fromLTWH(0, 0, 0, 0));
    registerFallbackValue(RectangleElement(
      id: 'fallback',
      x: 0,
      y: 0,
      width: 0,
      height: 0,
      strokeColor: Colors.black,
      updatedAt: DateTime.now(),
    ));
    registerFallbackValue(<String>{});
  });

  late CanvasInteractionDelegate delegate;
  late MockCanvasManipulationService mockManipulationService;
  late MockTransformationService mockTransformationService;
  late CanvasState baseState;
  late CanvasElement rect1;
  late CanvasElement rect2;

  setUp(() {
    mockManipulationService = MockCanvasManipulationService();
    mockTransformationService = MockTransformationService();
    delegate = CanvasInteractionDelegate(
      mockManipulationService,
      mockTransformationService,
    );

    rect1 = RectangleElement(
      id: 'rect1',
      x: 100,
      y: 100,
      width: 50,
      height: 50,
      strokeColor: Colors.black,
      updatedAt: DateTime.now(),
    );
    rect2 = RectangleElement(
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

  group('CanvasInteractionDelegate', () {
    group('Selection Methods', () {
      test('setSelectionBox sets selection box rect', () {
        const rect = Rect.fromLTWH(10, 10, 100, 100);
        final result = delegate.setSelectionBox(baseState, rect);
        expect(result.data!.transform.selectionBox, rect);
      });

      test('selectElementAt selects element when point is inside bounds', () {
        final result = delegate.selectElementAt(
          baseState,
          const Offset(125, 125),
        );
        expect(result.data!.selectedElementIds, {'rect1'});
      });

      test(
          'selectElementsInRect selects elements overlapping selection rectangle',
          () {
        const selectionRect = Rect.fromLTWH(90, 90, 70, 70);
        final result = delegate.selectElementsInRect(baseState, selectionRect);
        expect(result.data!.selectedElementIds, {'rect1'});
      });

      test('setHoveredElement sets hovered element id', () {
        final result = delegate.setHoveredElement(baseState, 'rect1');
        expect(result.data!.hoveredElementId, 'rect1');
      });
    });

    group('Manipulation Methods', () {
      test('moveSelectedElements calls manipulation service', () {
        final stateWithSelection = baseState.copyWith(
          interaction:
              baseState.interaction.copyWith(selectedElementIds: {'rect1'}),
        );
        const delta = Offset(10, 10);

        when(() => mockManipulationService.moveElements(any(), any(), any()))
            .thenReturn([rect1]);

        delegate.moveSelectedElements(state: stateWithSelection, delta: delta);

        verify(() => mockManipulationService.moveElements(
              stateWithSelection.document.elements,
              {'rect1'},
              delta,
            )).called(1);
      });

      test('resizeSelectedElement calls transformation service', () {
        final stateWithSelection = baseState.copyWith(
          interaction:
              baseState.interaction.copyWith(selectedElementIds: {'rect1'}),
        );
        const newRect = Rect.fromLTWH(100, 100, 60, 60);

        when(() => mockTransformationService.resizeAndPlace(any(), any()))
            .thenReturn(rect1);

        delegate.resizeSelectedElement(
            state: stateWithSelection, rect: newRect);

        verify(() => mockTransformationService.resizeAndPlace(rect1, newRect))
            .called(1);
      });
    });
  });
}
