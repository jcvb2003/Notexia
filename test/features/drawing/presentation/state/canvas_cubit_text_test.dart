import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/core/errors/result.dart';

import 'package:notexia/src/features/drawing/data/repositories/document_repository.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:notexia/src/features/drawing/domain/services/drawing_service.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/canvas_interaction_delegate.dart';
import 'package:notexia/src/features/drawing/domain/services/canvas_manipulation_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/text_editing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/viewport_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/drawing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/eraser_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/snap_delegate.dart';

class MockDocumentRepository extends Mock implements DocumentRepository {}

void main() {
  late CanvasCubit cubit;
  late MockDocumentRepository mockDocumentRepository;
  late CommandStackService commandStackService;
  late DrawingDocument initialDoc;

  setUpAll(() {
    registerFallbackValue(
      DrawingDocument(
        id: 'doc-id',
        title: 'Title',
        elements: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    registerFallbackValue(RectangleElement(
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
    mockDocumentRepository = MockDocumentRepository();
    commandStackService = CommandStackService();

    initialDoc = DrawingDocument(
      id: 'test-id',
      title: 'Test Doc',
      elements: const [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    when(() => mockDocumentRepository.saveDocument(any()))
        .thenAnswer((_) async => Result.success(null));
    when(() => mockDocumentRepository.saveElement(any(), any()))
        .thenAnswer((_) async => Result.success(null));

    final transformationService = TransformationService();
    final canvasManipulationService =
        CanvasManipulationService(transformationService);
    final drawingService =
        DrawingService(canvasManipulationService: canvasManipulationService);
    final persistenceService = PersistenceService(mockDocumentRepository);
    final canvasInteractionDelegate = CanvasInteractionDelegate(
      canvasManipulationService,
      transformationService,
    );

    cubit = CanvasCubit(
      mockDocumentRepository,
      commandStackService,
      drawingService,
      persistenceService,
      canvasInteractionDelegate,
      const TextEditingDelegate(),
      const ViewportDelegate(),
      const DrawingDelegate(),
      const EraserDelegate(),
      const SnapDelegate(),
      initialDoc,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('Text Editing', () {
    blocTest<CanvasCubit, CanvasState>(
      'createTextElement adds a TextElement and selects it',
      build: () => cubit,
      act: (cubit) => cubit.text.createTextElement(const Offset(100, 200)),
      expect: () => [
        isA<CanvasState>()
            .having((s) => s.document.elements.length, 'elements count', 1)
            .having(
              (s) => s.document.elements.first,
              'element is TextElement',
              isA<TextElement>(),
            )
            .having((s) => s.document.elements.first.x, 'x', 100)
            .having((s) => s.document.elements.first.y, 'y', 200)
            .having((s) => s.selectedElementIds, 'selected', hasLength(1))
            .having((s) => s.activeElementId, 'activeId', isNotNull),
      ],
      verify: (_) {
        expect(commandStackService.canUndo, isTrue,
            reason: 'Deve registrar AddElementCommand na stack');
      },
    );

    blocTest<CanvasCubit, CanvasState>(
      'updateTextElement updates text content of existing element',
      build: () => cubit,
      seed: () {
        final textEl = TextElement(
          id: 'text-1',
          x: 50,
          y: 50,
          width: 200,
          height: 30,
          strokeColor: Colors.black,
          updatedAt: DateTime.now(),
          text: 'Antigo',
        );
        return CanvasState(
          document: initialDoc.copyWith(elements: [textEl]),
        );
      },
      act: (cubit) => cubit.text.updateTextElement('text-1', 'Novo texto'),
      expect: () => [
        isA<CanvasState>().having(
          (s) => (s.document.elements.first as TextElement).text,
          'text atualizado',
          'Novo texto',
        ),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'setEditingText updates editingTextId in state',
      build: () => cubit,
      act: (cubit) => cubit.text.setEditingText('some-id'),
      expect: () => [
        isA<CanvasState>().having(
          (s) => s.interaction.textEditing.editingTextId,
          'editingId',
          'some-id',
        ),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'setEditingText(null) clears editingTextId',
      build: () => cubit,
      seed: () => CanvasState(
        document: initialDoc,
        interaction: const InteractionState(
          textEditing: TextEditingState(editingTextId: 'old-id'),
        ),
      ),
      act: (cubit) => cubit.text.setEditingText(null),
      expect: () => [
        isA<CanvasState>().having(
          (s) => s.interaction.textEditing.editingTextId,
          'editingId limpo',
          isNull,
        ),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'commitTextEditing deletes element when text is whitespace-only',
      build: () => cubit,
      seed: () {
        final textEl = TextElement(
          id: 'text-1',
          x: 100,
          y: 100,
          width: 200,
          height: 30,
          strokeColor: Colors.black,
          updatedAt: DateTime.now(),
          text: '',
        );
        return CanvasState(
          document: initialDoc.copyWith(elements: [textEl]),
          interaction: const InteractionState(
            textEditing: TextEditingState(editingTextId: 'text-1'),
          ),
        );
      },
      act: (cubit) => cubit.text.commitTextEditing('text-1', '   '),
      expect: () => [
        isA<CanvasState>()
            .having((s) => s.document.elements, 'elements vazio', isEmpty)
            .having((s) => s.selectedElementIds, 'seleção limpa', isEmpty),
      ],
      verify: (_) {
        expect(commandStackService.canUndo, isTrue,
            reason: 'Deve registrar RemoveElementCommand na stack');
      },
    );

    blocTest<CanvasCubit, CanvasState>(
      'commitTextEditing with valid text updates and finalizes',
      build: () => cubit,
      seed: () {
        final textEl = TextElement(
          id: 'text-1',
          x: 100,
          y: 100,
          width: 200,
          height: 30,
          strokeColor: Colors.black,
          updatedAt: DateTime.now(),
          text: '',
        );
        return CanvasState(
          document: initialDoc.copyWith(elements: [textEl]),
          interaction: const InteractionState(
            textEditing: TextEditingState(editingTextId: 'text-1'),
          ),
        );
      },
      act: (cubit) => cubit.text.commitTextEditing('text-1', 'Texto final'),
      expect: () => [
        isA<CanvasState>()
            .having(
              (s) => (s.document.elements.first as TextElement).text,
              'text atualizado',
              'Texto final',
            )
            .having(
              (s) => s.interaction.textEditing.editingTextId,
              'editingId limpo',
              isNull,
            ),
      ],
      verify: (_) {
        verify(() => mockDocumentRepository.saveElement(any(), any()))
            .called(1);
      },
    );
  });
}
