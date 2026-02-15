import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_entities.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/settings/domain/repositories/app_settings_repository.dart';
import 'package:notexia/src/features/drawing/domain/services/drawing_service.dart';
import 'package:notexia/src/features/drawing/domain/services/canvas_manipulation_service.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/element_manipulation_delegate.dart';

class MockAppSettingsRepository extends Mock implements AppSettingsRepository {}

class MockDocumentRepository extends Mock implements DocumentRepository {}

class CanvasElementFake extends Fake implements CanvasElement {}

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
    registerFallbackValue(CanvasElementFake());
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

    when(
      () => mockDocumentRepository.saveDocument(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockDocumentRepository.saveElement(any(), any()),
    ).thenAnswer((_) async {});

    final transformationService = TransformationService();
    final canvasManipulationService =
        CanvasManipulationService(transformationService);
    final drawingService =
        DrawingService(canvasManipulationService: canvasManipulationService);
    final persistenceService = PersistenceService(mockDocumentRepository);
    final elementManipulationDelegate = ElementManipulationDelegate(
      canvasManipulationService,
      transformationService,
    );

    cubit = CanvasCubit(
      mockDocumentRepository,
      commandStackService,
      drawingService,
      persistenceService,
      elementManipulationDelegate,
      initialDoc,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is correct', () {
    expect(cubit.state, CanvasState(document: initialDoc));
  });

  group('selectTool', () {
    blocTest<CanvasCubit, CanvasState>(
      'emits correct state when selecting a new tool',
      build: () => cubit,
      act: (cubit) => cubit.selectTool(CanvasElementType.selection),
      expect: () => [
        isA<CanvasState>().having(
          (s) => s.selectedTool,
          'tool',
          CanvasElementType.selection,
        ),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'clears selection when switching from selection to drawing tool',
      build: () => cubit,
      seed: () => CanvasState(
        document: initialDoc,
        interaction: const InteractionState(
          selectedTool: CanvasElementType.selection,
          selectedElementIds: ['el1'],
        ),
      ),
      act: (cubit) => cubit.selectTool(CanvasElementType.rectangle),
      expect: () => [
        isA<CanvasState>()
            .having((s) => s.selectedTool, 'tool', CanvasElementType.rectangle)
            .having((s) => s.selectedElementIds, 'selection', isEmpty),
      ],
    );
  });

  group('updateTitle', () {
    blocTest<CanvasCubit, CanvasState>(
      'emits updated document when title is changed successfully',
      build: () {
        return cubit;
      },
      act: (cubit) => cubit.updateTitle('New Title'),
      expect: () => [
        isA<CanvasState>().having(
          (s) => s.document.title,
          'title',
          'New Title',
        ),
      ],
      verify: (_) {
        verify(() => mockDocumentRepository.saveDocument(any())).called(1);
      },
    );
  });

  group('drawing lifecycle', () {
    blocTest<CanvasCubit, CanvasState>(
      'startDrawing adds a new element and sets activeElementId',
      build: () => cubit,
      act: (cubit) => cubit.drawing.startDrawing(const Offset(10, 10)),
      expect: () => [
        isA<CanvasState>()
            .having((s) => s.document.elements, 'elements', isEmpty)
            .having((s) => s.isDrawing, 'isDrawing', true)
            .having((s) => s.activeElementId, 'activeId', isNotNull)
            .having((s) => s.activeDrawingElement, 'drawingElement', isNotNull),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'updateDrawing updates the active element',
      build: () => cubit,
      seed: () => CanvasState(
        document: initialDoc.copyWith(elements: []),
        interaction: const InteractionState(
          selectedTool: CanvasElementType.rectangle,
        ),
      ),
      act: (cubit) {
        cubit.drawing.startDrawing(const Offset(10, 10));
        cubit.drawing.updateDrawing(const Offset(50, 50));
      },
      expect: () => [
        isA<CanvasState>(), // startDrawing
        isA<CanvasState>().having(
          (s) => s.activeDrawingElement!.width,
          'width',
          40,
        ),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'stopDrawing saves the element and clears activeElementId (emits 3 states)',
      build: () {
        return cubit;
      },
      act: (cubit) async {
        cubit.drawing.startDrawing(const Offset(10, 10));
        await cubit.drawing.stopDrawing();
      },
      expect: () => [
        isA<CanvasState>(), // startDrawing
        isA<CanvasState>()
            .having((s) => s.isDrawing, 'isDrawing', false)
            .having(
              (s) => s.activeElementId,
              'activeId',
              isNull,
            )
            .having(
              (s) => s.activeDrawingElement,
              'drawingElement',
              isNull,
            )
            .having(
              (s) => s.document.elements,
              'elements',
              hasLength(1),
            ),
      ],
      verify: (_) {
        verify(
          () => mockDocumentRepository.saveElement(any(), any()),
        ).called(1);
      },
    );

    blocTest<CanvasCubit, CanvasState>(
      'updateSelectedElementsProperties updates elements in selection',
      build: () {
        return cubit;
      },
      seed: () {
        final el = RectangleElement(
          id: 'el1',
          x: 0,
          y: 0,
          width: 10,
          height: 10,
          strokeColor: const Color(0xff000000),
          updatedAt: DateTime.now(),
        );
        return CanvasState(
          document: initialDoc.copyWith(elements: [el]),
          interaction: const InteractionState(selectedElementIds: ['el1']),
        );
      },
      act: (cubit) => cubit.manipulation.updateSelectedElementsProperties(
        strokeColor: const Color(0xffff0000),
      ),
      expect: () => [
        isA<CanvasState>().having(
          (s) => s.currentStyle.strokeColor,
          'currentStyle.color',
          const Color(0xffff0000),
        ),
        isA<CanvasState>().having(
          (s) => s.document.elements.first.strokeColor,
          'element.color',
          const Color(0xffff0000),
        ),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'updateDrawing (Line) works correctly when drawing backwards (to negative offsets)',
      build: () => cubit,
      seed: () => CanvasState(
        document: initialDoc.copyWith(elements: []),
        interaction: const InteractionState(
          selectedTool: CanvasElementType.line,
        ),
      ),
      act: (cubit) {
        // Start at (100, 100)
        cubit.drawing.startDrawing(const Offset(100, 100));
        // move to (50, 50) -> relative (-50, -50)
        cubit.drawing.updateDrawing(const Offset(50, 50));
      },
      expect: () => [
        isA<CanvasState>(), // startDrawing
        isA<CanvasState>().having(
          (s) {
            final line = s.activeDrawingElement as LineElement;
            // Normalization should set x,y to min coordinate (50, 50)
            // and points to [(50, 50), (0, 0)]
            return line.x == 50 &&
                line.y == 50 &&
                line.points[0] == const Offset(50, 50) &&
                line.points[1] == const Offset(0, 0);
          },
          'coordinates normalized correctly',
          true,
        ),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'updateDrawing (FreeDraw) works correctly when drawing backwards',
      build: () => cubit,
      seed: () => CanvasState(
        document: initialDoc.copyWith(elements: []),
        interaction: const InteractionState(
          selectedTool: CanvasElementType.freeDraw,
        ),
      ),
      act: (cubit) async {
        // Start at (100, 100) -> points [(0,0)]
        cubit.drawing.startDrawing(const Offset(100, 100));
        await Future.delayed(const Duration(milliseconds: 20));
        // move to (90, 90) -> points [(0,0), (-10,-10)]
        cubit.drawing.updateDrawing(const Offset(90, 90));
        await Future.delayed(const Duration(milliseconds: 20));
        // move to (80, 80) -> points [(0,0), (-10,-10), (-20,-20)]
        cubit.drawing.updateDrawing(const Offset(80, 80));
      },
      expect: () => [
        isA<CanvasState>(), // startDrawing
        isA<CanvasState>(), // update 1
        isA<CanvasState>().having(
          (s) {
            final fd = s.activeDrawingElement as FreeDrawElement;
            // Normalization should set x,y to (80, 80)
            // points relative to (80, 80) should be [(20, 20), (10, 10), (0, 0)]
            return fd.x == 80 &&
                fd.y == 80 &&
                fd.points.length == 3 &&
                fd.points.last == const Offset(0, 0) &&
                fd.points.first == const Offset(20, 20);
          },
          'coordinates normalized correctly',
          true,
        ),
      ],
    );
  });

  group('manipulation actions', () {
    blocTest<CanvasCubit, CanvasState>(
      'moveSelectedElements moves only selected IDs',
      build: () => cubit,
      seed: () {
        final el1 = RectangleElement(
          id: 'el1',
          x: 10,
          y: 20,
          width: 30,
          height: 40,
          strokeColor: const Color(0xff000000),
          updatedAt: DateTime.now(),
        );
        final el2 = EllipseElement(
          id: 'el2',
          x: 50,
          y: 60,
          width: 20,
          height: 20,
          strokeColor: const Color(0xff000000),
          updatedAt: DateTime.now(),
        );
        final el3 = TextElement(
          id: 'el3',
          x: 0,
          y: 0,
          width: 100,
          height: 40,
          strokeColor: const Color(0xff000000),
          updatedAt: DateTime.now(),
          text: 'A',
        );
        return CanvasState(
          document: initialDoc.copyWith(elements: [el1, el2, el3]),
          interaction: const InteractionState(
            selectedElementIds: ['el1', 'el3'],
          ),
        );
      },
      act: (cubit) =>
          cubit.manipulation.moveSelectedElements(const Offset(5, -3)),
      expect: () => [
        isA<CanvasState>()
            .having(
              (s) => s.document.elements.firstWhere((e) => e.id == 'el1').x,
              'el1.x',
              15,
            )
            .having(
              (s) => s.document.elements.firstWhere((e) => e.id == 'el1').y,
              'el1.y',
              17,
            )
            .having(
              (s) => s.document.elements.firstWhere((e) => e.id == 'el3').x,
              'el3.x',
              5,
            )
            .having(
              (s) => s.document.elements.firstWhere((e) => e.id == 'el3').y,
              'el3.y',
              -3,
            )
            .having(
              (s) => s.document.elements.firstWhere((e) => e.id == 'el2').x,
              'el2.x',
              50,
            )
            .having(
              (s) => s.document.elements.firstWhere((e) => e.id == 'el2').y,
              'el2.y',
              60,
            ),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'deleteSelectedElements removes IDs and clears selection',
      build: () => cubit,
      seed: () {
        final el1 = RectangleElement(
          id: 'el1',
          x: 0,
          y: 0,
          width: 10,
          height: 10,
          strokeColor: const Color(0xff000000),
          updatedAt: DateTime.now(),
        );
        final el2 = EllipseElement(
          id: 'el2',
          x: 0,
          y: 0,
          width: 10,
          height: 10,
          strokeColor: const Color(0xff000000),
          updatedAt: DateTime.now(),
        );
        final el3 = TextElement(
          id: 'el3',
          x: 0,
          y: 0,
          width: 10,
          height: 10,
          strokeColor: const Color(0xff000000),
          updatedAt: DateTime.now(),
          text: 'A',
        );
        return CanvasState(
          document: initialDoc.copyWith(elements: [el1, el2, el3]),
          interaction: const InteractionState(
            selectedElementIds: ['el1', 'el3'],
          ),
        );
      },
      act: (cubit) => cubit.manipulation.deleteSelectedElements(),
      expect: () => [
        isA<CanvasState>()
            .having((s) => s.document.elements.length, 'remaining', 1)
            .having((s) => s.document.elements.first.id, 'remaining id', 'el2')
            .having((s) => s.selectedElementIds, 'selection', isEmpty)
            .having((s) => s.activeElementId, 'activeId', isNull),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'resizeSelectedElement updates geometry and increments version',
      build: () => cubit,
      seed: () {
        final el1 = RectangleElement(
          id: 'el1',
          x: 10,
          y: 20,
          width: 30,
          height: 40,
          strokeColor: const Color(0xff000000),
          updatedAt: DateTime.now(),
          version: 1,
        );
        return CanvasState(
          document: initialDoc.copyWith(elements: [el1]),
          interaction: const InteractionState(selectedElementIds: ['el1']),
        );
      },
      act: (cubit) => cubit.manipulation
          .resizeSelectedElement(const Rect.fromLTWH(0, 0, 100, 50)),
      expect: () => [
        isA<CanvasState>()
            .having((s) => s.document.elements.first.x, 'x', 0)
            .having((s) => s.document.elements.first.y, 'y', 0)
            .having((s) => s.document.elements.first.width, 'width', 100)
            .having((s) => s.document.elements.first.height, 'height', 50)
            .having((s) => s.document.elements.first.version, 'version', 2),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'updateLineEndpoint with snapAngle normalizes and snaps to nearest step',
      build: () => cubit,
      seed: () {
        final line = LineElement(
          id: 'l1',
          x: 10,
          y: 20,
          width: 100,
          height: 0,
          strokeColor: const Color(0xff000000),
          updatedAt: DateTime.now(),
          points: const [Offset(0, 0), Offset(100, 0)],
        );
        return CanvasState(
          document: initialDoc.copyWith(elements: [line]),
          interaction: const InteractionState(selectedElementIds: ['l1']),
        );
      },
      act: (cubit) => cubit.manipulation.updateLineEndpoint(
        isStart: false,
        worldPoint: const Offset(80, 80), // force a 45-degree inclination
        snapAngle: true,
      ),
      expect: () => [
        isA<CanvasState>().having(
          (s) {
            final el = s.document.elements.first as LineElement;
            // After normalization: points are relative to minX/minY of endpoints.
            expect(el.points.length, 2);
            final p0 = el.points[0];
            final p1 = el.points[1];
            // Vector should be approximately 45 degrees (dx ~ dy)
            expect((p1.dx - p0.dx).abs(), closeTo((p1.dy - p0.dy).abs(), 0.5));
            return true;
          },
          'snapped',
          true,
        ),
      ],
    );
  });
  group('CanvasCubit UI', () {
    blocTest<CanvasCubit, CanvasState>(
      'toggleSkeletonMode changes state',
      build: () => cubit,
      act: (cubit) => cubit.preferences.toggleSkeletonMode(),
      expect: () => [
        isA<CanvasState>().having((s) => s.isSkeletonMode, 'skeleton', true),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'toggleFullScreen changes state',
      build: () {
        TestWidgetsFlutterBinding.ensureInitialized();
        return cubit;
      },
      act: (cubit) => cubit.preferences.toggleFullScreen(),
      expect: () => [
        isA<CanvasState>().having((s) => s.isFullScreen, 'fullScreen', true),
      ],
    );

    late MockAppSettingsRepository repo;

    blocTest<CanvasCubit, CanvasState>(
      'loadAngleSnapSettings reads and sets enabled+step',
      build: () {
        final repo = MockAppSettingsRepository();
        when(() => repo.getSetting(any())).thenAnswer((invocation) async {
          final key = invocation.positionalArguments.first as String;
          if (key.contains('enabled')) return 'true';
          if (key.contains('step')) return '0.5235987755982989';
          return null;
        });
        final transformationService = TransformationService();
        final canvasManipulationService =
            CanvasManipulationService(transformationService);
        final drawingService = DrawingService(
            canvasManipulationService: canvasManipulationService);
        final persistenceService = PersistenceService(mockDocumentRepository);
        final elementManipulationDelegate = ElementManipulationDelegate(
          canvasManipulationService,
          transformationService,
        );

        return CanvasCubit(
          mockDocumentRepository,
          commandStackService,
          drawingService,
          persistenceService,
          elementManipulationDelegate,
          initialDoc,
          appSettingsRepository: repo,
        );
      },
      act: (cubit) => cubit.snap.loadAngleSnapSettings(),
      expect: () => [
        isA<CanvasState>()
            .having((s) => s.isAngleSnapEnabled, 'enabled', true)
            .having((s) => s.angleSnapStep, 'step', closeTo(0.5235988, 1e-6)),
      ],
    );

    blocTest<CanvasCubit, CanvasState>(
      'toggleAngleSnapEnabled persists and toggles value',
      build: () {
        repo = MockAppSettingsRepository();
        when(() => repo.saveSetting(any(), any())).thenAnswer((_) async {});
        final transformationService = TransformationService();
        final canvasManipulationService =
            CanvasManipulationService(transformationService);
        final drawingService = DrawingService(
            canvasManipulationService: canvasManipulationService);
        final persistenceService = PersistenceService(mockDocumentRepository);
        final elementManipulationDelegate = ElementManipulationDelegate(
          canvasManipulationService,
          transformationService,
        );

        return CanvasCubit(
          mockDocumentRepository,
          commandStackService,
          drawingService,
          persistenceService,
          elementManipulationDelegate,
          initialDoc,
          appSettingsRepository: repo,
        );
      },
      act: (cubit) async {
        await cubit.snap.toggleAngleSnapEnabled();
      },
      expect: () => [
        isA<CanvasState>().having((s) => s.isAngleSnapEnabled, 'enabled', true),
      ],
      verify: (_) {
        verify(() => repo.saveSetting(any(), any())).called(1);
      },
    );

    blocTest<CanvasCubit, CanvasState>(
      'setAngleSnapStep persists and updates state',
      build: () {
        final repo = MockAppSettingsRepository();
        when(() => repo.saveSetting(any(), any())).thenAnswer((_) async {});
        final transformationService = TransformationService();
        final canvasManipulationService =
            CanvasManipulationService(transformationService);
        final drawingService = DrawingService(
            canvasManipulationService: canvasManipulationService);
        final persistenceService = PersistenceService(mockDocumentRepository);
        final elementManipulationDelegate = ElementManipulationDelegate(
          canvasManipulationService,
          transformationService,
        );

        return CanvasCubit(
          mockDocumentRepository,
          commandStackService,
          drawingService,
          persistenceService,
          elementManipulationDelegate,
          initialDoc,
          appSettingsRepository: repo,
        );
      },
      act: (cubit) async {
        await cubit.snap.setAngleSnapStep(3.141592653589793 / 8);
      },
      expect: () => [
        isA<CanvasState>().having(
          (s) => s.angleSnapStep,
          'step',
          closeTo(0.3926991, 1e-6),
        ),
      ],
    );
  });
}
