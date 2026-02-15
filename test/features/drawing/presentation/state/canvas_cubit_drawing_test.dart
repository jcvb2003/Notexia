import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/rectangle_element.dart';
import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';

class MockDocumentRepository extends Mock implements DocumentRepository {}

class CanvasElementFake extends Fake implements CanvasElement {}

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
    registerFallbackValue(CanvasElementFake());
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

    when(() => mockDocRepo.saveDocument(any())).thenAnswer((_) async {});
    when(() => mockDocRepo.saveElement(any(), any())).thenAnswer((_) async {});

    cubit = CanvasCubit(
      mockDocRepo,
      commandStack,
      TransformationService(),
      initialDoc,
    );
  });

  tearDown(() => cubit.close());

  group('Drawing - startDrawing', () {
    blocTest<CanvasCubit, CanvasState>(
      'starts drawing a rectangle and sets isDrawing',
      build: () => cubit,
      seed: () => CanvasState(
        document: initialDoc,
        interaction: const InteractionState(
          selectedTool: CanvasElementType.rectangle,
        ),
      ),
      act: (c) => c.startDrawing(const Offset(100, 100)),
      expect: () => [
        isA<CanvasState>()
            .having((s) => s.interaction.isDrawing, 'isDrawing', isTrue)
            .having(
              (s) => s.interaction.activeDrawingElement,
              'activeDrawingElement',
              isNotNull,
            )
            .having(
              (s) => s.interaction.activeElementId,
              'activeElementId',
              isNotNull,
            )
            .having(
              (s) => s.interaction.gestureStartPosition,
              'gestureStartPosition',
              const Offset(100, 100),
            ),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'does not start drawing when tool is selection',
      build: () => cubit,
      seed: () => CanvasState(
        document: initialDoc,
        interaction: const InteractionState(
          selectedTool: CanvasElementType.selection,
        ),
      ),
      act: (c) => c.startDrawing(const Offset(100, 100)),
      expect: () => <CanvasState>[],
    );
  });

  group('Drawing - stopDrawing', () {
    blocTest<CanvasCubit, CanvasState>(
      'does nothing when not drawing',
      build: () => cubit,
      act: (c) => c.stopDrawing(),
      expect: () => <CanvasState>[],
    );
  });

  group('Drawing - clearCanvas', () {
    blocTest<CanvasCubit, CanvasState>(
      'removes all elements and clears selection',
      build: () => cubit,
      seed: () {
        final r = RectangleElement(
          id: 'r1',
          x: 0,
          y: 0,
          width: 100,
          height: 100,
          strokeColor: Colors.black,
          updatedAt: DateTime.now(),
        );
        return CanvasState(
          document: initialDoc.copyWith(elements: [r]),
          interaction: const InteractionState(selectedElementIds: ['r1']),
        );
      },
      act: (c) => c.clearCanvas(),
      expect: () => [
        isA<CanvasState>()
            .having(
              (s) => s.document.elements,
              'elements vazio',
              isEmpty,
            )
            .having(
              (s) => s.selectedElementIds,
              'seleção vazia',
              isEmpty,
            ),
      ],
      verify: (_) {
        expect(commandStack.canUndo, isTrue,
            reason: 'Deve ter RemoveElementCommand');
      },
    );

    blocTest<CanvasCubit, CanvasState>(
      'does nothing when canvas is already empty',
      build: () => cubit,
      act: (c) => c.clearCanvas(),
      expect: () => <CanvasState>[],
    );
  });

  group('Drawing - selectTool', () {
    blocTest<CanvasCubit, CanvasState>(
      'changes selected tool',
      build: () => cubit,
      act: (c) => c.selectTool(CanvasElementType.ellipse),
      expect: () => [
        isA<CanvasState>().having(
          (s) => s.interaction.selectedTool,
          'ferramenta selecionada',
          CanvasElementType.ellipse,
        ),
      ],
    );
  });
}
