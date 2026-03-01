import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/data/repositories/document_repository.dart';
import 'package:notexia/src/features/drawing/domain/services/canvas_manipulation_service.dart';
import 'package:notexia/src/features/drawing/domain/services/drawing_service.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/canvas_interaction_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/drawing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/eraser_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/snap_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/text_editing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/viewport_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_input_router.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';

class _DocumentRepositoryFake implements DocumentRepository {
  @override
  Future<Result<void>> deleteDocument(String id) async => Result.success(null);

  @override
  Future<Result<void>> deleteElement(
          String drawingId, String elementId) async =>
      Result.success(null);

  @override
  Future<Result<DrawingDocument?>> getDocumentById(String id) async =>
      Result.success(null);

  @override
  Future<Result<List<DrawingDocument>>> getDocuments() async =>
      Result.success([]);

  @override
  Future<Result<void>> saveDocument(DrawingDocument document) async =>
      Result.success(null);

  @override
  Future<Result<void>> saveElement(
          String drawingId, CanvasElement element) async =>
      Result.success(null);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  CanvasCubit buildCubit({
    required DrawingDocument initialDoc,
  }) {
    final repo = _DocumentRepositoryFake();
    final transformation = TransformationService();
    final manipulation = CanvasManipulationService(transformation);
    final drawingService =
        DrawingService(canvasManipulationService: manipulation);
    final persistence = PersistenceService(repo);
    final interaction = CanvasInteractionDelegate(manipulation, transformation);
    return CanvasCubit(
      repo,
      CommandStackService(),
      drawingService,
      persistence,
      interaction,
      const TextEditingDelegate(),
      const ViewportDelegate(),
      const DrawingDelegate(),
      const EraserDelegate(),
      const SnapDelegate(),
      initialDoc,
    );
  }

  group('CanvasInputRouter gestures integration', () {
    test('selection drag moves selected element by focal delta', () {
      final rect = RectangleElement(
        id: 'r1',
        x: 100,
        y: 100,
        width: 60,
        height: 40,
        strokeColor: Colors.black,
        updatedAt: DateTime(2026, 1, 1),
      );
      final doc = DrawingDocument(
        id: 'doc',
        title: 'T',
        elements: [rect],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final cubit = buildCubit(initialDoc: doc);
      cubit.emit(
        cubit.state.copyWith(
          interaction: cubit.state.interaction.copyWith(
            selectedTool: CanvasElementType.selection,
            selectedElementIds: const {'r1'},
          ),
        ),
      );
      final router = CanvasInputRouter(canvasCubit: cubit);
      final state = cubit.state;

      router.handleScaleStart(
        ScaleStartDetails(
          localFocalPoint: Offset(110, 110),
          pointerCount: 1,
        ),
        state,
        CanvasElementType.selection,
        PointerDeviceKind.mouse,
      );
      router.handleScaleUpdate(
        ScaleUpdateDetails(
          localFocalPoint: Offset(130, 115),
          focalPointDelta: Offset(20, 5),
          scale: 1.0,
          pointerCount: 1,
        ),
        state,
        CanvasElementType.selection,
        PointerDeviceKind.mouse,
      );

      final moved = cubit.state.document.elements.single as RectangleElement;
      expect(moved.x, 120);
      expect(moved.y, 105);
    });

    test('dragging selection box selects overlapping elements on end', () {
      final a = RectangleElement(
        id: 'a',
        x: 20,
        y: 20,
        width: 40,
        height: 40,
        strokeColor: Colors.black,
        updatedAt: DateTime(2026, 1, 1),
      );
      final b = RectangleElement(
        id: 'b',
        x: 200,
        y: 200,
        width: 40,
        height: 40,
        strokeColor: Colors.black,
        updatedAt: DateTime(2026, 1, 1),
      );
      final doc = DrawingDocument(
        id: 'doc',
        title: 'T',
        elements: [a, b],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final cubit = buildCubit(initialDoc: doc);
      cubit.emit(
        cubit.state.copyWith(
          interaction: cubit.state.interaction.copyWith(
            selectedTool: CanvasElementType.selection,
            selectedElementIds: const {},
          ),
        ),
      );
      final router = CanvasInputRouter(canvasCubit: cubit);

      router.handleScaleStart(
        ScaleStartDetails(localFocalPoint: const Offset(0, 0), pointerCount: 1),
        cubit.state,
        CanvasElementType.selection,
        PointerDeviceKind.mouse,
      );
      router.handleScaleUpdate(
        ScaleUpdateDetails(
          localFocalPoint: Offset(80, 80),
          focalPointDelta: Offset(80, 80),
          scale: 1.0,
          pointerCount: 1,
        ),
        cubit.state,
        CanvasElementType.selection,
        PointerDeviceKind.mouse,
      );

      router.handleScaleEnd(
        ScaleEndDetails(),
        cubit.state,
        CanvasElementType.selection,
        PointerDeviceKind.mouse,
      );

      expect(cubit.state.selectedElementIds, {'a'});
      expect(cubit.state.selectionBox, isNull);
    });

    test('navigation mode pans using screen-space delta', () {
      final doc = DrawingDocument(
        id: 'doc',
        title: 'T',
        elements: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final cubit = buildCubit(initialDoc: doc);
      cubit.emit(
        cubit.state.copyWith(
          transform: cubit.state.transform.copyWith(zoomLevel: 2.0),
          interaction: cubit.state.interaction.copyWith(
            selectedTool: CanvasElementType.navigation,
          ),
        ),
      );
      final router = CanvasInputRouter(canvasCubit: cubit);

      router.handleScaleStart(
        ScaleStartDetails(
          localFocalPoint: Offset(10, 10),
          pointerCount: 1,
        ),
        cubit.state,
        CanvasElementType.navigation,
        PointerDeviceKind.mouse,
      );
      router.handleScaleUpdate(
        ScaleUpdateDetails(
          localFocalPoint: Offset(30, 20),
          focalPointDelta: Offset(20, 10),
          scale: 1.0,
          pointerCount: 1,
        ),
        cubit.state,
        CanvasElementType.navigation,
        PointerDeviceKind.mouse,
      );

      expect(cubit.state.panOffset, const Offset(20, 10));
    });

    test('two-finger pinch updates zoom anchored at focal point', () {
      final doc = DrawingDocument(
        id: 'doc',
        title: 'T',
        elements: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final cubit = buildCubit(initialDoc: doc);
      final router = CanvasInputRouter(canvasCubit: cubit);

      router.handleScaleStart(
        ScaleStartDetails(
          localFocalPoint: Offset(100, 100),
          pointerCount: 2,
        ),
        cubit.state,
        CanvasElementType.selection,
        PointerDeviceKind.touch,
      );

      router.handleScaleUpdate(
        ScaleUpdateDetails(
          localFocalPoint: Offset(100, 100),
          focalPointDelta: Offset.zero,
          scale: 2.0,
          pointerCount: 2,
        ),
        cubit.state,
        CanvasElementType.selection,
        PointerDeviceKind.touch,
      );

      expect(cubit.state.zoomLevel, 2.0);
      expect(cubit.state.panOffset, const Offset(-100, -100));
    });

    test('touch in pen mode disabled pans when no selection drag is active',
        () {
      final doc = DrawingDocument(
        id: 'doc',
        title: 'T',
        elements: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final cubit = buildCubit(initialDoc: doc);
      cubit.emit(
        cubit.state.copyWith(
          isDrawWithFingerEnabled: false,
          interaction: cubit.state.interaction.copyWith(
            selectedTool: CanvasElementType.selection,
          ),
        ),
      );
      final router = CanvasInputRouter(canvasCubit: cubit);

      router.handleScaleStart(
        ScaleStartDetails(localFocalPoint: const Offset(0, 0), pointerCount: 1),
        cubit.state,
        CanvasElementType.selection,
        PointerDeviceKind.touch,
      );
      router.handleScaleUpdate(
        ScaleUpdateDetails(
          localFocalPoint: Offset(15, -5),
          focalPointDelta: Offset(15, -5),
          scale: 1.0,
          pointerCount: 1,
        ),
        cubit.state,
        CanvasElementType.selection,
        PointerDeviceKind.touch,
      );

      expect(cubit.state.panOffset, const Offset(15, -5));
    });

    test('freeDraw raw pointer accepts stylus and ignores touch when disabled',
        () async {
      final doc = DrawingDocument(
        id: 'doc',
        title: 'T',
        elements: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final cubit = buildCubit(initialDoc: doc);
      cubit.emit(
        cubit.state.copyWith(
          isDrawWithFingerEnabled: false,
          interaction: cubit.state.interaction.copyWith(
            selectedTool: CanvasElementType.freeDraw,
          ),
        ),
      );
      final router = CanvasInputRouter(canvasCubit: cubit);

      router.handlePointerDown(
        const PointerDownEvent(
          kind: PointerDeviceKind.touch,
          position: Offset(10, 10),
        ),
        cubit.state,
      );
      expect(cubit.state.isDrawing, isFalse);

      router.handlePointerDown(
        const PointerDownEvent(
          kind: PointerDeviceKind.stylus,
          position: Offset(10, 10),
        ),
        cubit.state,
      );
      expect(cubit.state.isDrawing, isTrue);

      router.handlePointerMove(
        const PointerMoveEvent(
          kind: PointerDeviceKind.stylus,
          position: Offset(30, 30),
        ),
        cubit.state,
      );
      router.handlePointerUp(
        const PointerUpEvent(
          kind: PointerDeviceKind.stylus,
          position: Offset(30, 30),
        ),
        cubit.state,
      );

      await Future<void>.delayed(Duration.zero);
      expect(
        cubit.state.document.elements
            .any((e) => e.type == CanvasElementType.freeDraw),
        isTrue,
      );
    });
  });
}
