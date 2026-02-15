import 'dart:ui';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/services/drawing_service.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';

class DrawingDelegate {
  const DrawingDelegate();

  void startDrawing({
    required CanvasState state,
    required Offset position,
    required DrawingService drawingService,
    required void Function(CanvasState) emit,
  }) {
    if (state.selectedTool == CanvasElementType.selection) return;

    final newElement = drawingService.startDrawing(
      type: state.selectedTool,
      position: position,
      style: state.currentStyle,
    );

    if (newElement == null) return;

    emit(
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

  void updateDrawing({
    required CanvasState state,
    required Offset currentPosition,
    required DrawingService drawingService,
    required void Function(CanvasState) emit,
    bool keepAspect = false,
    bool snapAngle = false,
    bool createFromCenter = false,
    double? snapAngleStep,
  }) {
    final element = state.activeElement;
    if (element == null) return;

    final updatedElement = drawingService.updateDrawingElement(
      element: element,
      currentPosition: currentPosition,
      startPosition: state.gestureStartPosition ?? Offset(element.x, element.y),
      keepAspect: keepAspect,
      snapAngle: snapAngle,
      snapAngleStep: snapAngleStep,
      createFromCenter: createFromCenter,
    );
    if (updatedElement == null) return;

    // Drawing new element
    if (state.activeDrawingElement != null) {
      emit(
        state.copyWith(
          interaction: state.interaction.copyWith(
            activeDrawingElement: updatedElement,
          ),
        ),
      );
      return;
    }

    // Editing existing element
    final updatedElements = state.elements
        .map((e) => e.id == updatedElement.id ? updatedElement : e)
        .toList();
    final updatedDoc = state.document.copyWith(elements: updatedElements);
    emit(state.copyWith(document: updatedDoc));
  }

  Future<void> stopDrawing({
    required CanvasState state,
    required PersistenceService persistenceService,
    required void Function(CanvasState) emit,
  }) async {
    if (!state.isDrawing) return;

    final elementOfDrawing = state.activeDrawingElement;
    final elementId = state.activeElementId;

    DrawingDocument? updatedDoc;

    // Case 1: Creating new element
    if (elementOfDrawing != null) {
      updatedDoc = state.document.copyWith(
        elements: [...state.document.elements, elementOfDrawing],
      );

      try {
        await persistenceService.saveElement(
          state.document.id,
          elementOfDrawing,
        );
      } catch (e) {
        emit(state.copyWith(error: 'Erro ao salvar elemento: $e'));
      }
    }
    // Case 2: Editing existing element
    else {
      final existingElement =
          state.document.elements.where((e) => e.id == elementId).firstOrNull;

      if (existingElement != null) {
        try {
          await persistenceService.saveElement(
            state.document.id,
            existingElement,
          );
        } catch (e) {
          emit(state.copyWith(error: 'Erro ao salvar elemento: $e'));
        }
      }
    }

    emit(
      state.copyWith(
        document: updatedDoc ?? state.document,
        error: null,
        interaction: state.interaction.copyWith(
          isDrawing: false,
          activeElementId: null,
          activeDrawingElement: null,
          gestureStartPosition: null,
          selectedElementIds:
              elementId != null ? [elementId] : state.selectedElementIds,
        ),
      ),
    );
  }
}
