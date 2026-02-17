import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';

import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:notexia/src/features/drawing/domain/services/drawing_service.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/element_manipulation_delegate.dart';
import 'package:notexia/src/features/drawing/domain/services/canvas_manipulation_service.dart';

class MockDocumentRepository extends Mock implements DocumentRepository {}

/// Cria um RectangleElement de teste em (x,y) com width/height.
RectangleElement _makeRect(
  String id, {
  double x = 0,
  double y = 0,
  double w = 100,
  double h = 100,
}) {
  return RectangleElement(
    id: id,
    x: x,
    y: y,
    width: w,
    height: h,
    strokeColor: Colors.black,
    updatedAt: DateTime.now(),
  );
}

void main() {
  late CanvasCubit cubit;
  late MockDocumentRepository mockDocRepo;
  late CommandStackService commandStack;
  late DrawingDocument initialDoc;

  setUpAll(() {
    registerFallbackValue(
      DrawingDocument(
        id: 'doc-id',
        title: 'T',
        elements: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    registerFallbackValue(CanvasElement.rectangle(
      id: 'fallback',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      strokeColor: Colors.black,
      updatedAt: DateTime.now(),
    ));
  });

  setUp(() {
    mockDocRepo = MockDocumentRepository();
    commandStack = CommandStackService();

    initialDoc = DrawingDocument(
      id: 'test-id',
      title: 'Test Doc',
      elements: const [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    when(() => mockDocRepo.saveDocument(any()))
        .thenAnswer((_) async => Result.success(null));
    when(() => mockDocRepo.saveElement(any(), any()))
        .thenAnswer((_) async => Result.success(null));

    final transformationService = TransformationService();
    final canvasManipulationService =
        CanvasManipulationService(transformationService);
    final drawingService =
        DrawingService(canvasManipulationService: canvasManipulationService);
    final persistenceService = PersistenceService(mockDocRepo);
    final elementManipulationDelegate = ElementManipulationDelegate(
      canvasManipulationService,
      transformationService,
    );

    cubit = CanvasCubit(
      mockDocRepo,
      commandStack,
      drawingService,
      persistenceService,
      elementManipulationDelegate,
      initialDoc,
    );
  });

  tearDown(() => cubit.close());

  group('Selection - selectElementAt', () {
    blocTest<CanvasCubit, CanvasState>(
      'selects element when tapping inside its bounds',
      build: () => cubit,
      seed: () {
        final rect = _makeRect('r1', x: 10, y: 10, w: 100, h: 100);
        return CanvasState(
          document: initialDoc.copyWith(elements: [rect]),
        );
      },
      act: (c) => c.selection.selectElementAt(const Offset(50, 50)),
      expect: () => [
        isA<CanvasState>().having(
          (s) => s.selectedElementIds,
          'seleção',
          ['r1'],
        ),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'clears selection when tapping empty area',
      build: () => cubit,
      seed: () {
        final rect = _makeRect('r1', x: 10, y: 10, w: 100, h: 100);
        return CanvasState(
          document: initialDoc.copyWith(elements: [rect]),
          interaction: const InteractionState(selectedElementIds: ['r1']),
        );
      },
      act: (c) => c.selection.selectElementAt(const Offset(500, 500)),
      expect: () => [
        isA<CanvasState>().having(
          (s) => s.selectedElementIds,
          'seleção vazia',
          isEmpty,
        ),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'multiselect adds element to existing selection',
      build: () => cubit,
      seed: () {
        final r1 = _makeRect('r1', x: 10, y: 10, w: 50, h: 50);
        final r2 = _makeRect('r2', x: 200, y: 200, w: 50, h: 50);
        return CanvasState(
          document: initialDoc.copyWith(elements: [r1, r2]),
          interaction: const InteractionState(selectedElementIds: ['r1']),
        );
      },
      act: (c) => c.selection
          .selectElementAt(const Offset(210, 210), isMultiSelect: true),
      expect: () => [
        isA<CanvasState>().having(
          (s) => s.selectedElementIds,
          'multi seleção',
          containsAll(['r1', 'r2']),
        ),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'multiselect toggles off already selected element',
      build: () => cubit,
      seed: () {
        final r1 = _makeRect('r1', x: 10, y: 10, w: 50, h: 50);
        return CanvasState(
          document: initialDoc.copyWith(elements: [r1]),
          interaction: const InteractionState(selectedElementIds: ['r1']),
        );
      },
      act: (c) => c.selection
          .selectElementAt(const Offset(20, 20), isMultiSelect: true),
      expect: () => [
        isA<CanvasState>().having(
          (s) => s.selectedElementIds,
          'deseleciona r1',
          isEmpty,
        ),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'does not emit when same element is already selected (single select)',
      build: () => cubit,
      seed: () {
        final r1 = _makeRect('r1', x: 10, y: 10, w: 100, h: 100);
        return CanvasState(
          document: initialDoc.copyWith(elements: [r1]),
          interaction: const InteractionState(selectedElementIds: ['r1']),
        );
      },
      act: (c) => c.selection.selectElementAt(const Offset(50, 50)),
      // State does not change → Bloc does not emit
      expect: () => <CanvasState>[],
    );
  });

  group('Selection - selectElementsInRect', () {
    blocTest<CanvasCubit, CanvasState>(
      'selects all elements overlapping the rect',
      build: () => cubit,
      seed: () {
        final r1 = _makeRect('r1', x: 0, y: 0, w: 50, h: 50);
        final r2 = _makeRect('r2', x: 100, y: 100, w: 50, h: 50);
        final r3 = _makeRect('r3', x: 500, y: 500, w: 50, h: 50);
        return CanvasState(
          document: initialDoc.copyWith(elements: [r1, r2, r3]),
        );
      },
      act: (c) =>
          c.selection.selectElementsInRect(const Rect.fromLTRB(0, 0, 120, 120)),
      expect: () => [
        isA<CanvasState>().having(
          (s) => s.selectedElementIds,
          'contém r1 e r2',
          containsAll(['r1', 'r2']),
        ),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'returns empty selection when rect has no overlap',
      build: () => cubit,
      seed: () {
        final r1 = _makeRect('r1', x: 100, y: 100, w: 50, h: 50);
        return CanvasState(
          document: initialDoc.copyWith(elements: [r1]),
          interaction: const InteractionState(selectedElementIds: ['r1']),
        );
      },
      act: (c) =>
          c.selection.selectElementsInRect(const Rect.fromLTRB(0, 0, 10, 10)),
      expect: () => [
        isA<CanvasState>().having(
          (s) => s.selectedElementIds,
          'vazio',
          isEmpty,
        ),
      ],
    );
  });

  group('Selection - setHoveredElement', () {
    blocTest<CanvasCubit, CanvasState>(
      'sets hoveredElementId',
      build: () => cubit,
      act: (c) => c.selection.setHoveredElement('r1'),
      expect: () => [
        isA<CanvasState>().having(
          (s) => s.interaction.hoveredElementId,
          'hoveredId',
          'r1',
        ),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'clears hoveredElementId with null',
      build: () => cubit,
      seed: () => CanvasState(
        document: initialDoc,
        interaction: const InteractionState(hoveredElementId: 'r1'),
      ),
      act: (c) => c.selection.setHoveredElement(null),
      expect: () => [
        isA<CanvasState>().having(
          (s) => s.interaction.hoveredElementId,
          'hoveredId nulo',
          isNull,
        ),
      ],
    );
  });

  group('Selection - deleteSelectedElements', () {
    blocTest<CanvasCubit, CanvasState>(
      'removes selected elements from document',
      build: () => cubit,
      seed: () {
        final r1 = _makeRect('r1');
        final r2 = _makeRect('r2', x: 200);
        return CanvasState(
          document: initialDoc.copyWith(elements: [r1, r2]),
          interaction: const InteractionState(selectedElementIds: ['r1']),
        );
      },
      act: (c) => c.manipulation.deleteSelectedElements(),
      expect: () => [
        isA<CanvasState>()
            .having(
              (s) => s.document.elements.length,
              'resta 1 elemento',
              1,
            )
            .having(
              (s) => s.document.elements.first.id,
              'restou r2',
              'r2',
            )
            .having(
              (s) => s.selectedElementIds,
              'seleção limpa',
              isEmpty,
            ),
      ],
      verify: (_) {
        expect(commandStack.canUndo, isTrue,
            reason: 'Deve ter RemoveElementCommand na stack');
      },
    );
  });
}
