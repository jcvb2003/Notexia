import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/core/errors/failure.dart';
import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';
import 'package:notexia/src/features/drawing/domain/services/drawing_service.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/drawing_delegate.dart';

class MockDrawingService extends Mock implements DrawingService {}

class MockPersistenceService extends Mock implements PersistenceService {}

void main() {
  late DrawingDelegate delegate;
  late MockDrawingService drawingService;
  late MockPersistenceService persistenceService;
  final now = DateTime(2026, 1, 1);

  setUpAll(() {
    registerFallbackValue(const Offset(0, 0));
    registerFallbackValue(const ElementStyle());
    registerFallbackValue(CanvasElementType.rectangle);
    registerFallbackValue(
      RectangleElement(
        id: 'fallback',
        x: 0,
        y: 0,
        width: 1,
        height: 1,
        strokeColor: Colors.black,
        updatedAt: DateTime(2026, 1, 1),
      ),
    );
  });

  setUp(() {
    delegate = const DrawingDelegate();
    drawingService = MockDrawingService();
    persistenceService = MockPersistenceService();
    when(() => persistenceService.saveElement(any(), any()))
        .thenAnswer((_) async => Result.success(null));
  });

  group('DrawingDelegate.startDrawing', () {
    test('returns same state when selected tool is selection', () {
      final state = _state(selectedTool: CanvasElementType.selection);

      final result = delegate.startDrawing(
        state: state,
        position: const Offset(10, 10),
        drawingService: drawingService,
      );

      expect(result.isSuccess, isTrue);
      expect(result.data, same(state));
    });

    test('sets active drawing metadata when element is created', () {
      final created = RectangleElement(
        id: 'new-1',
        x: 10,
        y: 10,
        width: 0,
        height: 0,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      when(
        () => drawingService.startDrawing(
          type: any(named: 'type'),
          position: any(named: 'position'),
          style: any(named: 'style'),
        ),
      ).thenReturn(created);

      final result = delegate.startDrawing(
        state: _state(selectedTool: CanvasElementType.rectangle),
        position: const Offset(10, 10),
        drawingService: drawingService,
      );

      final next = result.data!;
      expect(next.isDrawing, isTrue);
      expect(next.activeElementId, 'new-1');
      expect(next.activeDrawingElement, same(created));
      expect(next.gestureStartPosition, const Offset(10, 10));
    });
  });

  group('DrawingDelegate.updateDrawing', () {
    test('updates in-memory activeDrawingElement during active draw', () {
      final original = RectangleElement(
        id: 'shape-1',
        x: 0,
        y: 0,
        width: 0,
        height: 0,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      final updated = original.copyWith(width: 20, height: 10);

      when(
        () => drawingService.updateDrawingElement(
          element: any(named: 'element'),
          currentPosition: any(named: 'currentPosition'),
          startPosition: any(named: 'startPosition'),
          keepAspect: any(named: 'keepAspect'),
          snapAngle: any(named: 'snapAngle'),
          createFromCenter: any(named: 'createFromCenter'),
          snapAngleStep: any(named: 'snapAngleStep'),
        ),
      ).thenReturn(updated);

      final result = delegate.updateDrawing(
        state: _state(
          elements: const [],
          activeElementId: 'shape-1',
          activeDrawingElement: original,
          gestureStartPosition: const Offset(0, 0),
          isDrawing: true,
        ),
        currentPosition: const Offset(20, 10),
        drawingService: drawingService,
      );

      expect(result.data!.activeDrawingElement, updated);
      expect(result.data!.document.elements, isEmpty);
    });

    test('updates persisted element list when drawing from existing element id', () {
      final original = RectangleElement(
        id: 'shape-1',
        x: 1,
        y: 2,
        width: 3,
        height: 4,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      final updated = original.copyWith(x: 9, y: 8);

      when(
        () => drawingService.updateDrawingElement(
          element: any(named: 'element'),
          currentPosition: any(named: 'currentPosition'),
          startPosition: any(named: 'startPosition'),
          keepAspect: any(named: 'keepAspect'),
          snapAngle: any(named: 'snapAngle'),
          createFromCenter: any(named: 'createFromCenter'),
          snapAngleStep: any(named: 'snapAngleStep'),
        ),
      ).thenReturn(updated);

      final result = delegate.updateDrawing(
        state: _state(
          elements: [original],
          activeElementId: 'shape-1',
          gestureStartPosition: const Offset(1, 2),
          isDrawing: true,
        ),
        currentPosition: const Offset(9, 8),
        drawingService: drawingService,
      );

      expect(result.data!.document.elements.first, updated);
    });
  });

  group('DrawingDelegate.stopDrawing', () {
    test('returns same state when not drawing', () async {
      final state = _state();

      final result = await delegate.stopDrawing(
        state: state,
        persistenceService: persistenceService,
      );

      expect(result.data, same(state));
      verifyNever(() => persistenceService.saveElement('doc-1', any()));
    });

    test('appends activeDrawingElement and persists it successfully', () async {
      final drawingElement = RectangleElement(
        id: 'shape-1',
        x: 0,
        y: 0,
        width: 10,
        height: 10,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      final result = await delegate.stopDrawing(
        state: _state(
          isDrawing: true,
          activeElementId: 'shape-1',
          activeDrawingElement: drawingElement,
          elements: const [],
        ),
        persistenceService: persistenceService,
      );

      final next = result.data!;
      expect(next.isDrawing, isFalse);
      expect(next.activeElementId, isNull);
      expect(next.activeDrawingElement, isNull);
      expect(next.document.elements, [drawingElement]);
      expect(next.selectedElementIds, {'shape-1'});
      verify(() => persistenceService.saveElement('doc-1', drawingElement)).called(1);
    });

    test('keeps drawing stop flow but exposes error when persistence fails', () async {
      final drawingElement = RectangleElement(
        id: 'shape-1',
        x: 0,
        y: 0,
        width: 10,
        height: 10,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      when(() => persistenceService.saveElement('doc-1', drawingElement)).thenAnswer(
        (_) async => Result.failure(const PersistenceFailure('falha ao salvar')),
      );

      final result = await delegate.stopDrawing(
        state: _state(
          isDrawing: true,
          activeElementId: 'shape-1',
          activeDrawingElement: drawingElement,
          elements: const [],
        ),
        persistenceService: persistenceService,
      );

      final next = result.data!;
      expect(next.error, 'falha ao salvar');
      expect(next.isDrawing, isFalse);
      expect(next.activeDrawingElement, isNull);
    });
  });
}

CanvasState _state({
  CanvasElementType selectedTool = CanvasElementType.rectangle,
  bool isDrawing = false,
  String? activeElementId,
  CanvasElement? activeDrawingElement,
  Offset? gestureStartPosition,
  List<CanvasElement> elements = const [],
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
      selectedTool: selectedTool,
      isDrawing: isDrawing,
      activeElementId: activeElementId,
      activeDrawingElement: activeDrawingElement,
      gestureStartPosition: gestureStartPosition,
    ),
  );
}
