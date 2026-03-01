import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';
import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/features/drawing/domain/services/canvas_manipulation_service.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/canvas_interaction_delegate.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';

class MockDocumentRepository extends Mock implements DocumentRepository {}

void main() {
  late CanvasInteractionDelegate delegate;
  late CommandStackService commandStack;
  late MockDocumentRepository repository;
  final now = DateTime(2026, 1, 1);

  setUpAll(() {
    registerFallbackValue(
      DrawingDocument(
        id: 'fallback',
        title: 'fallback',
        elements: const [],
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
    );
  });

  setUp(() {
    delegate = CanvasInteractionDelegate(
      CanvasManipulationService(TransformationService()),
      TransformationService(),
    );
    commandStack = CommandStackService();
    repository = MockDocumentRepository();
  });

  tearDown(() {
    commandStack.dispose();
  });

  group('CanvasInteractionDelegate advanced selection', () {
    test('selectElementAt picks top-most element on overlap', () {
      final bottom = _rectangle(id: 'bottom', x: 0, y: 0, w: 100, h: 100);
      final top = _rectangle(id: 'top', x: 0, y: 0, w: 100, h: 100);
      final state = _state(elements: [bottom, top]);

      final result = delegate.selectElementAt(state, const Offset(50, 50));

      expect(result.data!.selectedElementIds, {'top'});
    });

    test('multi-select toggles existing selection', () {
      final state = _state(
        elements: [_rectangle(id: 'a', x: 0, y: 0, w: 50, h: 50)],
        selectedElementIds: const {'a'},
      );

      final result = delegate.selectElementAt(
        state,
        const Offset(10, 10),
        isMultiSelect: true,
      );

      expect(result.data!.selectedElementIds, isEmpty);
    });

    test('clicking empty area in multi-select mode keeps selection', () {
      final state = _state(
        elements: [_rectangle(id: 'a', x: 0, y: 0, w: 10, h: 10)],
        selectedElementIds: const {'a'},
      );

      final result = delegate.selectElementAt(
        state,
        const Offset(100, 100),
        isMultiSelect: true,
      );

      expect(result.data!.selectedElementIds, {'a'});
    });
  });

  group('CanvasInteractionDelegate advanced manipulation', () {
    test('moveSelectedElements no-op when nothing selected', () {
      final state = _state(elements: [_rectangle(id: 'a', x: 0, y: 0, w: 10, h: 10)]);

      final result =
          delegate.moveSelectedElements(state: state, delta: const Offset(5, 5));

      expect(result.data, same(state));
    });

    test('resizeSelectedElement updates only when exactly one selected', () {
      final a = _rectangle(id: 'a', x: 0, y: 0, w: 20, h: 20);
      final b = _rectangle(id: 'b', x: 100, y: 100, w: 30, h: 30);

      final oneSelected = _state(elements: [a, b], selectedElementIds: const {'a'});
      final resized = delegate.resizeSelectedElement(
        state: oneSelected,
        rect: const Rect.fromLTWH(10, 11, 40, 50),
      );

      final resizedA =
          resized.data!.document.elements.firstWhere((e) => e.id == 'a');
      final untouchedB =
          resized.data!.document.elements.firstWhere((e) => e.id == 'b');
      expect(resizedA.bounds, const Rect.fromLTWH(10, 11, 40, 50));
      expect(untouchedB.bounds, b.bounds);

      final multiSelected = _state(
        elements: [a, b],
        selectedElementIds: const {'a', 'b'},
      );
      final multiResult = delegate.resizeSelectedElement(
        state: multiSelected,
        rect: const Rect.fromLTWH(0, 0, 1, 1),
      );
      expect(multiResult.data, same(multiSelected));
    });

    test('rotateSelectedElement rotates selected element only', () {
      final a = _rectangle(id: 'a', x: 0, y: 0, w: 20, h: 20);
      final b = _rectangle(id: 'b', x: 100, y: 100, w: 30, h: 30);
      final state = _state(elements: [a, b], selectedElementIds: const {'a'});

      final result = delegate.rotateSelectedElement(
        state: state,
        angle: 1.25,
      );

      final rotatedA = result.data!.document.elements.firstWhere((e) => e.id == 'a');
      final untouchedB = result.data!.document.elements.firstWhere((e) => e.id == 'b');
      expect(rotatedA.angle, 1.25);
      expect(untouchedB.angle, 0);
    });

    test('updateLineEndpoint updates selected line endpoint', () {
      final line = LineElement(
        id: 'l1',
        x: 0,
        y: 0,
        width: 100,
        height: 0,
        strokeColor: Colors.black,
        updatedAt: now,
        points: const [Offset(0, 0), Offset(100, 0)],
      );
      final state = _state(elements: [line], selectedElementIds: const {'l1'});

      final result = delegate.updateLineEndpoint(
        state: state,
        isStart: false,
        worldPoint: const Offset(100, 100),
        snapAngle: true,
      );

      final updated = result.data!.document.elements.single as LineElement;
      expect(updated.points.length, 2);
      expect(updated.width > 0, isTrue);
      expect(updated.height > 0, isTrue);
    });
  });

  group('CanvasInteractionDelegate commands and persistence', () {
    test('finalizeManipulation returns success on repository save', () async {
      when(() => repository.saveDocument(any()))
          .thenAnswer((_) async => Result.success(null));

      final state = _state(elements: [_rectangle(id: 'a', x: 0, y: 0, w: 10, h: 10)]);
      final result = await delegate.finalizeManipulation(
        state: state,
        documentRepository: repository,
      );

      expect(result.isSuccess, isTrue);
      verify(() => repository.saveDocument(state.document)).called(1);
    });

    test('finalizeManipulation returns failure when repository throws', () async {
      when(() => repository.saveDocument(any())).thenThrow(Exception('db down'));

      final result = await delegate.finalizeManipulation(
        state: _state(),
        documentRepository: repository,
      );

      expect(result.isFailure, isTrue);
      expect(result.failure!.message, contains('Erro ao salvar'));
    });

    test('deleteSelectedElements clears selection, pushes command and schedules save',
        () {
      final a = _rectangle(id: 'a', x: 0, y: 0, w: 10, h: 10);
      final b = _rectangle(id: 'b', x: 20, y: 20, w: 10, h: 10);
      final state = _state(
        elements: [a, b],
        selectedElementIds: const {'a'},
        activeElementId: 'a',
      );

      List<CanvasElement>? applied;
      DrawingDocument? scheduledDoc;
      final result = delegate.deleteSelectedElements(
        state: state,
        commandStack: commandStack,
        applyCallback: (elements) => applied = elements,
        scheduleSave: (doc) => scheduledDoc = doc,
      );

      final next = result.data!;
      final deletedA = next.document.elements.firstWhere((e) => e.id == 'a');
      expect(deletedA.isDeleted, isTrue);
      expect(next.selectedElementIds, isEmpty);
      expect(next.activeElementId, isNull);
      expect(commandStack.canUndo, isTrue);
      expect(scheduledDoc, isNotNull);

      commandStack.undo();
      expect(applied, isNotNull);
      expect(applied!.firstWhere((e) => e.id == 'a').isDeleted, isFalse);
    });

    test('deleteElementById removes element and updates selection', () {
      final a = _rectangle(id: 'a', x: 0, y: 0, w: 10, h: 10);
      final b = _rectangle(id: 'b', x: 20, y: 20, w: 10, h: 10);
      final state = _state(
        elements: [a, b],
        selectedElementIds: const {'a', 'b'},
        activeElementId: 'a',
      );

      DrawingDocument? scheduled;
      final result = delegate.deleteElementById(
        state: state,
        elementId: 'a',
        commandStack: commandStack,
        applyCallback: (_) {},
        scheduleSave: (doc) => scheduled = doc,
      );

      final next = result.data!;
      expect(next.document.elements.map((e) => e.id).toList(), ['b']);
      expect(next.selectedElementIds, {'b'});
      expect(next.activeElementId, isNull);
      expect(commandStack.canUndo, isTrue);
      expect(scheduled, isNotNull);
    });

    test('updateSelectedElementsProperties updates style only when no selection', () {
      final state = _state();
      DrawingDocument? scheduled;
      final patch = const ElementStylePatch(strokeColor: Colors.red);

      final result = delegate.updateSelectedElementsProperties(
        state: state,
        commandStack: commandStack,
        applyCallback: (_) {},
        scheduleSave: (doc) => scheduled = doc,
        patch: patch,
      );

      expect(result.data!.currentStyle.strokeColor, Colors.red);
      expect(commandStack.canUndo, isFalse);
      expect(scheduled, isNull);
    });

    test('updateSelectedElementsProperties updates elements and records command', () {
      final a = _rectangle(id: 'a', x: 0, y: 0, w: 10, h: 10);
      final state = _state(elements: [a], selectedElementIds: const {'a'});
      DrawingDocument? scheduled;

      final result = delegate.updateSelectedElementsProperties(
        state: state,
        commandStack: commandStack,
        applyCallback: (_) {},
        scheduleSave: (doc) => scheduled = doc,
        patch: const ElementStylePatch(strokeColor: Colors.blue, strokeWidth: 4),
      );

      final updated = result.data!.document.elements.single;
      expect(updated.strokeColor, Colors.blue);
      expect(updated.strokeWidth, 4);
      expect(commandStack.canUndo, isTrue);
      expect(scheduled, isNotNull);
    });
  });
}

CanvasState _state({
  List<CanvasElement> elements = const [],
  Set<String> selectedElementIds = const {},
  String? activeElementId,
}) {
  final now = DateTime(2026, 1, 1);
  return CanvasState(
    document: DrawingDocument(
      id: 'doc-1',
      title: 'Doc',
      elements: elements,
      createdAt: now,
      updatedAt: now,
    ),
    interaction: InteractionState(
      selectedTool: CanvasElementType.selection,
      selectedElementIds: selectedElementIds,
      activeElementId: activeElementId,
    ),
  );
}

RectangleElement _rectangle({
  required String id,
  required double x,
  required double y,
  required double w,
  required double h,
}) {
  return RectangleElement(
    id: id,
    x: x,
    y: y,
    width: w,
    height: h,
    strokeColor: Colors.black,
    updatedAt: DateTime(2026, 1, 1),
  );
}
