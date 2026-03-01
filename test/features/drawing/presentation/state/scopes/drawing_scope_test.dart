import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/core/errors/failure.dart';
import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/services/drawing_service.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/drawing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/drawing_scope.dart';

class MockDrawingDelegate extends Mock implements DrawingDelegate {}

class MockDrawingService extends Mock implements DrawingService {}

class MockPersistenceService extends Mock implements PersistenceService {}

void main() {
  late MockDrawingDelegate delegate;
  late MockDrawingService drawingService;
  late MockPersistenceService persistenceService;
  late CanvasState currentState;
  late List<CanvasState> emitted;
  late DrawingScope scope;

  setUpAll(() {
    registerFallbackValue(const Offset(0, 0));
    registerFallbackValue(_baseState());
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
    delegate = MockDrawingDelegate();
    drawingService = MockDrawingService();
    persistenceService = MockPersistenceService();
    currentState = _baseState();
    emitted = [];

    scope = DrawingScope(
      () => currentState,
      (state) {
        currentState = state;
        emitted.add(state);
      },
      drawingService,
      persistenceService,
      () => false,
      delegate,
    );
  });

  group('DrawingScope.startDrawing', () {
    test('emits state returned by delegate', () {
      final next = _baseState(isDrawing: true, activeElementId: 'a1');
      when(
        () => delegate.startDrawing(
          state: any(named: 'state'),
          position: any(named: 'position'),
          drawingService: drawingService,
          isDisposed: any(named: 'isDisposed'),
        ),
      ).thenReturn(Result.success(next));

      scope.startDrawing(const Offset(10, 20));

      expect(currentState, same(next));
      expect(emitted, [next]);
    });
  });

  group('DrawingScope.updateDrawing', () {
    test('does nothing when there is no active drawing', () {
      scope.updateDrawing(const Offset(10, 20));

      verifyNever(
        () => delegate.updateDrawing(
          state: any(named: 'state'),
          currentPosition: any(named: 'currentPosition'),
          drawingService: drawingService,
          isDisposed: any(named: 'isDisposed'),
          keepAspect: any(named: 'keepAspect'),
          snapAngle: any(named: 'snapAngle'),
          createFromCenter: any(named: 'createFromCenter'),
          snapAngleStep: any(named: 'snapAngleStep'),
        ),
      );
      expect(emitted, isEmpty);
    });

    test('calls delegate and emits when drawing is active', () {
      currentState = _baseState(isDrawing: true, activeElementId: 'shape-1');
      final next = _baseState(
        isDrawing: true,
        activeElementId: 'shape-1',
        elements: [
          RectangleElement(
            id: 'shape-1',
            x: 0,
            y: 0,
            width: 20,
            height: 30,
            strokeColor: Colors.black,
            updatedAt: DateTime(2026, 1, 1),
          ),
        ],
      );

      when(
        () => delegate.updateDrawing(
          state: any(named: 'state'),
          currentPosition: any(named: 'currentPosition'),
          drawingService: drawingService,
          isDisposed: any(named: 'isDisposed'),
          keepAspect: any(named: 'keepAspect'),
          snapAngle: any(named: 'snapAngle'),
          createFromCenter: any(named: 'createFromCenter'),
          snapAngleStep: any(named: 'snapAngleStep'),
        ),
      ).thenReturn(Result.success(next));

      scope.updateDrawing(
        const Offset(50, 60),
        keepAspect: true,
        snapAngle: true,
        createFromCenter: true,
        snapAngleStep: 0.5,
      );

      expect(currentState, same(next));
      expect(emitted.last, same(next));
      verify(
        () => delegate.updateDrawing(
          state: any(named: 'state'),
          currentPosition: const Offset(50, 60),
          drawingService: drawingService,
          isDisposed: any(named: 'isDisposed'),
          keepAspect: true,
          snapAngle: true,
          createFromCenter: true,
          snapAngleStep: 0.5,
        ),
      ).called(1);
    });
  });

  group('DrawingScope.stopDrawing', () {
    test('emits delegate success result', () async {
      final next = _baseState(isDrawing: false);
      when(
        () => delegate.stopDrawing(
          state: any(named: 'state'),
          persistenceService: persistenceService,
          isDisposed: any(named: 'isDisposed'),
        ),
      ).thenAnswer((_) async => Result.success(next));

      await scope.stopDrawing();

      expect(currentState, same(next));
      expect(emitted.last, same(next));
    });

    test('emits fallback error state when delegate returns failure', () async {
      currentState = _baseState(
        isDrawing: true,
        activeElementId: 'shape-1',
        activeDrawingElement: RectangleElement(
          id: 'shape-1',
          x: 0,
          y: 0,
          width: 10,
          height: 10,
          strokeColor: Colors.black,
          updatedAt: DateTime(2026, 1, 1),
        ),
      );
      when(
        () => delegate.stopDrawing(
          state: any(named: 'state'),
          persistenceService: persistenceService,
          isDisposed: any(named: 'isDisposed'),
        ),
      ).thenAnswer(
        (_) async => Result.failure(const ServerFailure('save failed')),
      );

      await scope.stopDrawing();

      expect(currentState.error, 'save failed');
      expect(currentState.isDrawing, isFalse);
      expect(currentState.activeElementId, isNull);
      expect(currentState.activeDrawingElement, isNull);
    });
  });
}

CanvasState _baseState({
  bool isDrawing = false,
  String? activeElementId,
  CanvasElement? activeDrawingElement,
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
      selectedTool: CanvasElementType.rectangle,
      isDrawing: isDrawing,
      activeElementId: activeElementId,
      activeDrawingElement: activeDrawingElement,
    ),
  );
}
