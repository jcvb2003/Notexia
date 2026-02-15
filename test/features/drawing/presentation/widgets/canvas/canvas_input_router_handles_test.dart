import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:notexia/src/app/config/constants/notexia_constants.dart';
import 'package:notexia/src/features/drawing/domain/utils/selection_utils.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_entities.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_input_router.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';

class _DocumentRepositoryFake implements DocumentRepository {
  @override
  Future<void> deleteDocument(String id) async {}
  @override
  Future<void> deleteElement(String drawingId, String elementId) async {}
  @override
  Future<DrawingDocument?> getDocumentById(String id) async => null;
  @override
  Future<List<DrawingDocument>> getDocuments() async => [];
  @override
  Future<void> saveDocument(DrawingDocument document) async {}
  @override
  Future<void> saveElement(String drawingId, CanvasElement element) async {}
}

Offset _rotate(Offset delta, double angle) {
  final c = math.cos(angle);
  final s = math.sin(angle);
  return Offset(delta.dx * c - delta.dy * s, delta.dx * s + delta.dy * c);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('CanvasInputRouter selection handles', () {
    test('rotaciona via handle de rotaÃ§Ã£o com elemento rotacionado e zoom',
        () {
      final doc = DrawingDocument(
        id: 'doc',
        title: 'T',
        elements: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final repo = _DocumentRepositoryFake();
      final drawingCubit = CanvasCubit(
          repo, CommandStackService(), TransformationService(), doc);

      final el = RectangleElement(
        id: 'r1',
        x: 100,
        y: 100,
        width: 80,
        height: 60,
        angle: math.pi / 4,
        strokeColor: const Color(0xff000000),
        updatedAt: DateTime.now(),
      );
      drawingCubit.emit(
        drawingCubit.state.copyWith(
          document: doc.copyWith(elements: [el]),
          interaction: drawingCubit.state.interaction.copyWith(
            selectedTool: CanvasElementType.selection,
            selectedElementIds: const ['r1'],
          ),
        ),
      );
      drawingCubit.setZoom(2.0);

      final router = CanvasInputRouter(canvasCubit: drawingCubit);
      final uiState = drawingCubit.state;
      final rect = el.bounds.inflate(6 / uiState.zoomLevel);
      final center = el.bounds.center;
      final rotateCenter = SelectionUtils.computeRotateHandleCenter(
        rect,
        uiState.zoomLevel,
      );
      final localDelta = rotateCenter - center;
      final worldPoint = center + _rotate(localDelta, el.angle);
      final localFocalPoint =
          worldPoint * uiState.zoomLevel + uiState.panOffset;

      router.handleScaleStart(
        ScaleStartDetails(localFocalPoint: localFocalPoint, pointerCount: 1),
        uiState,
        CanvasElementType.selection,
      );

      final delta = math.pi / 10;
      final nextLocal = center + _rotate(localDelta, delta);
      final nextWorld = center + _rotate(nextLocal - center, el.angle);
      final nextLocalFocal = nextWorld * uiState.zoomLevel + uiState.panOffset;
      router.handleScaleUpdate(
        ScaleUpdateDetails(
          localFocalPoint: nextLocalFocal,
          focalPointDelta: Offset.zero,
          scale: 1.0,
          pointerCount: 1,
        ),
        uiState,
        CanvasElementType.selection,
      );

      final updated =
          drawingCubit.state.document.elements.first as RectangleElement;
      expect(updated.angle, closeTo(el.angle + delta, 0.001));
    });

    test('redimensiona via canto superior direito sob rotaÃ§Ã£o e zoom', () {
      final doc = DrawingDocument(
        id: 'doc',
        title: 'T',
        elements: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final repo = _DocumentRepositoryFake();
      final drawingCubit = CanvasCubit(
          repo, CommandStackService(), TransformationService(), doc);

      final el = RectangleElement(
        id: 'r2',
        x: 50,
        y: 50,
        width: 100,
        height: 80,
        angle: math.pi / 6,
        strokeColor: const Color(0xff000000),
        updatedAt: DateTime.now(),
      );
      drawingCubit.emit(
        drawingCubit.state.copyWith(
          document: doc.copyWith(elements: [el]),
          interaction: drawingCubit.state.interaction.copyWith(
            selectedTool: CanvasElementType.selection,
            selectedElementIds: const ['r2'],
          ),
        ),
      );
      drawingCubit.setZoom(2.0);

      final router = CanvasInputRouter(canvasCubit: drawingCubit);

      final uiState = drawingCubit.state;
      final rect = el.bounds.inflate(6 / uiState.zoomLevel);
      final center = el.bounds.center;
      final handlePos = rect.topRight;
      final localDelta = handlePos - center;
      final worldPoint = center + _rotate(localDelta, el.angle);
      final localFocalPoint =
          worldPoint * uiState.zoomLevel + uiState.panOffset;

      router.handleScaleStart(
        ScaleStartDetails(localFocalPoint: localFocalPoint, pointerCount: 1),
        uiState,
        CanvasElementType.selection,
      );

      final move = const Offset(10, -5);
      final nextLocal = handlePos + move;
      final nextWorld = center + _rotate(nextLocal - center, el.angle);
      final nextLocalFocal = nextWorld * uiState.zoomLevel + uiState.panOffset;
      router.handleScaleUpdate(
        ScaleUpdateDetails(
          localFocalPoint: nextLocalFocal,
          focalPointDelta: Offset.zero,
          scale: 1.0,
          pointerCount: 1,
        ),
        uiState,
        CanvasElementType.selection,
      );

      final updated =
          drawingCubit.state.document.elements.first as RectangleElement;
      final inflate = 6 / uiState.zoomLevel;
      expect(updated.width, closeTo(el.width + move.dx + inflate, 0.001));
      expect(updated.height, closeTo(el.height + (-move.dy) + inflate, 0.001));
      expect(updated.x, closeTo(el.bounds.left, 0.001));
      expect(updated.y, closeTo(nextLocal.dy, 0.001));
    });

    testWidgets('redimensiona via borda superior sem manter proporÃ§Ã£o', (
      tester,
    ) async {
      final doc = DrawingDocument(
        id: 'doc',
        title: 'T',
        elements: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final repo = _DocumentRepositoryFake();
      final drawingCubit = CanvasCubit(
          repo, CommandStackService(), TransformationService(), doc);

      final el = RectangleElement(
        id: 'r3',
        x: 20,
        y: 20,
        width: 120,
        height: 60,
        angle: math.pi / 6,
        strokeColor: const Color(0xff000000),
        updatedAt: DateTime.now(),
      );
      drawingCubit.emit(
        drawingCubit.state.copyWith(
          document: doc.copyWith(elements: [el]),
          interaction: drawingCubit.state.interaction.copyWith(
            selectedTool: CanvasElementType.selection,
            selectedElementIds: const ['r3'],
          ),
        ),
      );
      drawingCubit.setZoom(2.0);

      final router = CanvasInputRouter(canvasCubit: drawingCubit);

      final uiState = drawingCubit.state;
      final rect = el.bounds.inflate(6 / uiState.zoomLevel);
      final center = el.bounds.center;
      final handlePos = rect.topCenter;
      final localDelta = handlePos - center;
      final worldPoint = center + _rotate(localDelta, el.angle);
      final localFocalPoint =
          worldPoint * uiState.zoomLevel + uiState.panOffset;

      router.handleScaleStart(
        ScaleStartDetails(localFocalPoint: localFocalPoint, pointerCount: 1),
        uiState,
        CanvasElementType.selection,
      );

      final move = const Offset(0, -12);
      final nextLocal = handlePos + move;
      final nextWorld = center + _rotate(nextLocal - center, el.angle);
      final nextLocalFocal = nextWorld * uiState.zoomLevel + uiState.panOffset;
      router.handleScaleUpdate(
        ScaleUpdateDetails(
          localFocalPoint: nextLocalFocal,
          focalPointDelta: Offset.zero,
          scale: 1.0,
          pointerCount: 1,
        ),
        uiState,
        CanvasElementType.selection,
      );

      final updated =
          drawingCubit.state.document.elements.first as RectangleElement;
      final inflate = 6 / uiState.zoomLevel;
      expect(updated.width, closeTo(el.width, 0.001));
      expect(updated.height, closeTo(el.height + (-move.dy) + inflate, 0.001));
    });

    testWidgets(
      'redimensiona via borda superior mantendo proporÃ§Ã£o com Shift',
      (tester) async {
        final doc = DrawingDocument(
          id: 'doc',
          title: 'T',
          elements: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        final repo = _DocumentRepositoryFake();
        final drawingCubit = CanvasCubit(
            repo, CommandStackService(), TransformationService(), doc);

        final el = RectangleElement(
          id: 'r4',
          x: 40,
          y: 40,
          width: 120,
          height: 80,
          angle: math.pi / 8,
          strokeColor: const Color(0xff000000),
          updatedAt: DateTime.now(),
        );
        drawingCubit.emit(
          drawingCubit.state.copyWith(
            document: doc.copyWith(elements: [el]),
            interaction: drawingCubit.state.interaction.copyWith(
              selectedTool: CanvasElementType.selection,
              selectedElementIds: const ['r4'],
            ),
          ),
        );
        drawingCubit.setZoom(2.0);

        final router = CanvasInputRouter(canvasCubit: drawingCubit);

        final uiState = drawingCubit.state;
        final rect = el.bounds.inflate(6 / uiState.zoomLevel);
        final center = el.bounds.center;
        final handlePos = rect.topCenter;
        final localDelta = handlePos - center;
        final worldPoint = center + _rotate(localDelta, el.angle);
        final localFocalPoint =
            worldPoint * uiState.zoomLevel + uiState.panOffset;

        router.handleScaleStart(
          ScaleStartDetails(localFocalPoint: localFocalPoint, pointerCount: 1),
          uiState,
          CanvasElementType.selection,
        );

        await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);

        final move = const Offset(0, -10);
        final nextLocal = handlePos + move;
        final nextWorld = center + _rotate(nextLocal - center, el.angle);
        final nextLocalFocal =
            nextWorld * uiState.zoomLevel + uiState.panOffset;
        router.handleScaleUpdate(
          ScaleUpdateDetails(
            localFocalPoint: nextLocalFocal,
            focalPointDelta: Offset.zero,
            scale: 1.0,
            pointerCount: 1,
          ),
          uiState,
          CanvasElementType.selection,
        );

        await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);

        final updated =
            drawingCubit.state.document.elements.first as RectangleElement;
        final inflate = 6 / uiState.zoomLevel;
        final aspect = el.width / el.height;
        expect(
          updated.height,
          closeTo(el.height + (-move.dy) + inflate, 0.001),
        );
        expect((updated.width / updated.height), closeTo(aspect, 0.001));
      },
    );

    testWidgets('rotaÃ§Ã£o com Shift aplica snapping de Ã¢ngulo (pi/12)', (
      tester,
    ) async {
      final doc = DrawingDocument(
        id: 'doc',
        title: 'T',
        elements: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final repo = _DocumentRepositoryFake();
      final drawingCubit = CanvasCubit(
          repo, CommandStackService(), TransformationService(), doc);

      final startAngle = math.pi / 5;
      final el = RectangleElement(
        id: 'r5',
        x: 100,
        y: 100,
        width: 80,
        height: 60,
        angle: startAngle,
        strokeColor: const Color(0xff000000),
        updatedAt: DateTime.now(),
      );
      drawingCubit.emit(
        drawingCubit.state.copyWith(
          document: doc.copyWith(elements: [el]),
          interaction: drawingCubit.state.interaction.copyWith(
            selectedTool: CanvasElementType.selection,
            selectedElementIds: const ['r5'],
          ),
        ),
      );
      drawingCubit.setZoom(2.0);

      final router = CanvasInputRouter(canvasCubit: drawingCubit);

      final uiState = drawingCubit.state;
      final rect = el.bounds.inflate(6 / uiState.zoomLevel);
      final center = el.bounds.center;
      final rotateCenter = SelectionUtils.computeRotateHandleCenter(
        rect,
        uiState.zoomLevel,
      );
      final localDelta = rotateCenter - center;
      final worldPoint = center + _rotate(localDelta, el.angle);
      final localFocalPoint =
          worldPoint * uiState.zoomLevel + uiState.panOffset;

      router.handleScaleStart(
        ScaleStartDetails(localFocalPoint: localFocalPoint, pointerCount: 1),
        uiState,
        CanvasElementType.selection,
      );

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);

      final delta = math.pi / 10;
      final nextLocal = center + _rotate(localDelta, delta);
      final nextWorld = center + _rotate(nextLocal - center, el.angle);
      final nextLocalFocal = nextWorld * uiState.zoomLevel + uiState.panOffset;
      router.handleScaleUpdate(
        ScaleUpdateDetails(
          localFocalPoint: nextLocalFocal,
          focalPointDelta: Offset.zero,
          scale: 1.0,
          pointerCount: 1,
        ),
        uiState,
        CanvasElementType.selection,
      );

      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);

      final updated =
          drawingCubit.state.document.elements.first as RectangleElement;
      final step = NotexiaConstants.angleSnapStep;
      final expected = ((startAngle + delta) / step).round() * step;
      expect(updated.angle, closeTo(expected, 0.001));
    });

    testWidgets(
      'rotaÃ§Ã£o com snap global habilitado e passo customizado (pi/6)',
      (tester) async {
        final doc = DrawingDocument(
          id: 'doc',
          title: 'T',
          elements: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        final repo = _DocumentRepositoryFake();
        final drawingCubit = CanvasCubit(
            repo, CommandStackService(), TransformationService(), doc);
        await drawingCubit.setAngleSnapEnabled(true);
        await drawingCubit.setAngleSnapStep(math.pi / 6);

        final startAngle = math.pi / 7;
        final el = RectangleElement(
          id: 'r6',
          x: 120,
          y: 120,
          width: 60,
          height: 40,
          angle: startAngle,
          strokeColor: const Color(0xff000000),
          updatedAt: DateTime.now(),
        );
        drawingCubit.emit(
          drawingCubit.state.copyWith(
            document: doc.copyWith(elements: [el]),
            interaction: drawingCubit.state.interaction.copyWith(
              selectedTool: CanvasElementType.selection,
              selectedElementIds: const ['r6'],
            ),
          ),
        );
        drawingCubit.setZoom(2.0);

        final router = CanvasInputRouter(canvasCubit: drawingCubit);

        final uiState = drawingCubit.state;
        final rect = el.bounds.inflate(6 / uiState.zoomLevel);
        final center = el.bounds.center;
        final rotateCenter = SelectionUtils.computeRotateHandleCenter(
          rect,
          uiState.zoomLevel,
        );
        final localDelta = rotateCenter - center;
        final worldPoint = center + _rotate(localDelta, el.angle);
        final localFocalPoint =
            worldPoint * uiState.zoomLevel + uiState.panOffset;

        router.handleScaleStart(
          ScaleStartDetails(localFocalPoint: localFocalPoint, pointerCount: 1),
          uiState,
          CanvasElementType.selection,
        );

        // Sem pressionar Shift, snap deve aplicar por estar habilitado no UI
        final delta = math.pi / 10;
        final nextLocal = center + _rotate(localDelta, delta);
        final nextWorld = center + _rotate(nextLocal - center, el.angle);
        final nextLocalFocal =
            nextWorld * uiState.zoomLevel + uiState.panOffset;
        router.handleScaleUpdate(
          ScaleUpdateDetails(
            localFocalPoint: nextLocalFocal,
            focalPointDelta: Offset.zero,
            scale: 1.0,
            pointerCount: 1,
          ),
          uiState,
          CanvasElementType.selection,
        );

        final updated =
            drawingCubit.state.document.elements.first as RectangleElement;
        final step = math.pi / 6;
        final expected = ((startAngle + delta) / step).round() * step;
        expect(updated.angle, closeTo(expected, 0.001));
      },
    );
  });
}
