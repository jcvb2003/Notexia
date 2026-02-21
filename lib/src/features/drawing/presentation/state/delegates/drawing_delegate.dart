import 'dart:ui';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/services/drawing_service.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/core/errors/result.dart';

class DrawingDelegate {
  const DrawingDelegate();

  Result<CanvasState> startDrawing({
    required CanvasState state,
    required Offset position,
    required DrawingService drawingService,
    bool Function()? isDisposed,
  }) {
    if (state.selectedTool == CanvasElementType.selection) {
      return Result.success(state);
    }
    if (isDisposed != null && isDisposed()) return Result.success(state);

    final newElement = drawingService.startDrawing(
      type: state.selectedTool,
      position: position,
      style: state.currentStyle,
    );

    if (newElement == null) return Result.success(state);

    return Result.success(
      state.copyWith(
        interaction: state.interaction.copyWith(
          isDrawing: true,
          activeElementId: newElement.id,
          activeDrawingElement: newElement,
          gestureStartPosition: position,
        ),
      ),
    );
  }

  Result<CanvasState> updateDrawing({
    required CanvasState state,
    required Offset currentPosition,
    required DrawingService drawingService,
    bool Function()? isDisposed,
    bool keepAspect = false,
    bool snapAngle = false,
    bool createFromCenter = false,
    double? snapAngleStep,
  }) {
    if (isDisposed != null && isDisposed()) return Result.success(state);
    final element = state.activeElement;

    if (element == null) return Result.success(state);

    final updatedElement = drawingService.updateDrawingElement(
      element: element,
      currentPosition: currentPosition,
      startPosition: state.gestureStartPosition ?? Offset(element.x, element.y),
      keepAspect: keepAspect,
      snapAngle: snapAngle,
      snapAngleStep: snapAngleStep,
      createFromCenter: createFromCenter,
    );
    if (updatedElement == null) return Result.success(state);

    if (state.activeDrawingElement != null) {
      return Result.success(
        state.copyWith(
          interaction: state.interaction.copyWith(
            activeDrawingElement: updatedElement,
          ),
        ),
      );
    }

    final updatedElements = state.elements
        .map((e) => e.id == updatedElement.id ? updatedElement : e)
        .toList();
    final updatedDoc = state.document.copyWith(elements: updatedElements);
    return Result.success(state.copyWith(document: updatedDoc));
  }

  Future<Result<CanvasState>> stopDrawing({
    required CanvasState state,
    required PersistenceService persistenceService,
    bool Function()? isDisposed,
  }) async {
    if (!state.isDrawing) return Result.success(state);
    if (isDisposed != null && isDisposed()) return Result.success(state);

    final elementOfDrawing = state.activeDrawingElement;
    final elementId = state.activeElementId;

    DrawingDocument? updatedDoc;
    CanvasState currentState = state;

    if (elementOfDrawing != null) {
      updatedDoc = state.document.copyWith(
        elements: [...state.document.elements, elementOfDrawing],
      );

      final result = await persistenceService.saveElement(
        state.document.id,
        elementOfDrawing,
      );
      if (result.isFailure) {
        currentState = currentState.copyWith(error: result.failure?.message);
      }
    } else if (elementId != null) {
      final existingElement =
          state.document.elements.where((e) => e.id == elementId).firstOrNull;

      if (existingElement != null) {
        final result = await persistenceService.saveElement(
          state.document.id,
          existingElement,
        );
        if (result.isFailure) {
          currentState = currentState.copyWith(error: result.failure?.message);
        }
      }
    }

    if (isDisposed != null && isDisposed()) return Result.success(currentState);

    return Result.success(
      currentState.copyWith(
        document: updatedDoc ?? state.document,
        error: currentState.error,
        interaction: state.interaction.copyWith(
          isDrawing: false,
          activeElementId: null,
          activeDrawingElement: null,
          gestureStartPosition: null,
          selectedElementIds:
              elementId != null ? {elementId} : state.selectedElementIds,
        ),
      ),
    );
  }
}
