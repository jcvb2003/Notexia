import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:notexia/src/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:notexia/src/features/drawing/domain/services/drawing_service.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/element_manipulation_delegate.dart';
import 'package:notexia/src/features/drawing/domain/services/canvas_manipulation_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/selection_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/text_editing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/viewport_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/drawing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/eraser_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/snap_delegate.dart';

class MockDocumentRepository extends Mock implements DocumentRepository {}

class MockPersistenceService extends Mock implements PersistenceService {}

void main() {
  late CanvasCubit cubit;
  late MockDocumentRepository mockDocRepo;
  late MockPersistenceService mockPersistence;
  late CommandStackService commandStack;
  late DrawingDocument initialDoc;
  final fixedDate = DateTime(2024, 1, 1);

  setUpAll(() {
    registerFallbackValue(
      DrawingDocument(
        id: 'doc-id',
        title: 'T',
        elements: const [],
        createdAt: fixedDate,
        updatedAt: fixedDate,
      ),
    );
    registerFallbackValue(RectangleElement(
      id: 'fallback',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      strokeColor: Colors.black,
      updatedAt: fixedDate,
    ));
    registerFallbackValue(const Duration(milliseconds: 0));
  });

  setUp(() {
    mockDocRepo = MockDocumentRepository();
    commandStack = CommandStackService();

    initialDoc = DrawingDocument(
      id: 'test-id',
      title: 'Test Doc',
      elements: const [],
      createdAt: fixedDate,
      updatedAt: fixedDate,
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
    mockPersistence = MockPersistenceService();

    when(() => mockPersistence.scheduleSaveDocument(any(),
            debounceDuration: any(named: 'debounceDuration'),
            onComplete: any(named: 'onComplete')))
        .thenAnswer((Invocation invocation) {
      final onComplete =
          invocation.namedArguments[#onComplete] as void Function(Failure?)?;
      onComplete?.call(null);
    });
    when(() => mockPersistence.saveElement(any(), any()))
        .thenAnswer((_) async => Result.success(null));
    when(() => mockPersistence.dispose()).thenReturn(null);
    final elementManipulationDelegate = ElementManipulationDelegate(
      canvasManipulationService,
      transformationService,
    );

    cubit = CanvasCubit(
      mockDocRepo,
      commandStack,
      drawingService,
      mockPersistence,
      elementManipulationDelegate,
      const SelectionDelegate(),
      const TextEditingDelegate(),
      const ViewportDelegate(),
      const DrawingDelegate(),
      const EraserDelegate(),
      const SnapDelegate(),
      initialDoc,
    );
  });

  tearDown(() async {
    await cubit.close();
    commandStack.dispose();
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
      act: (c) => c.drawing.startDrawing(const Offset(100, 100)),
      expect: () => [
        isA<CanvasState>()
            .having((s) => s.interaction.isDrawing, 'isDrawing', isTrue)
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
      verify: (cubit) {
        expect(cubit.state.activeDrawingElement, isNotNull);
      },
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
      act: (c) => c.drawing.startDrawing(const Offset(100, 100)),
      expect: () => <CanvasState>[],
    );
  });

  group('Drawing - stopDrawing', () {
    blocTest<CanvasCubit, CanvasState>(
      'does nothing when not drawing',
      build: () => cubit,
      act: (c) => c.drawing.stopDrawing(),
      expect: () => [
        // stopDrawing returns Result.success(state) via copyWith
        // which creates a new object reference, so it emits.
        isA<CanvasState>()
            .having((s) => s.interaction.isDrawing, 'isDrawing', false),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'emits error state when saving fails',
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
          document: initialDoc,
          interaction: InteractionState(
            isDrawing: true,
            activeElementId: 'r1',
            activeDrawingElement: r,
          ),
        );
      },
      act: (c) {
        when(() => mockPersistence.saveElement(any(), any())).thenAnswer(
          (_) async => Result.failure(const PersistenceFailure('Erro de Mock')),
        );
        return c.drawing.stopDrawing();
      },
      expect: () => [
        isA<CanvasState>()
            .having((s) => s.error, 'error message', 'Erro de Mock')
            .having((s) => s.interaction.isDrawing, 'drawing stopped', false),
      ],
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
          interaction: const InteractionState(selectedElementIds: {'r1'}),
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
}
