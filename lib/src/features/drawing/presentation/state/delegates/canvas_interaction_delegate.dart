import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';

import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';
import 'package:notexia/src/features/drawing/domain/services/canvas_manipulation_service.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:notexia/src/features/drawing/domain/commands/elements_command.dart';
import 'package:notexia/src/features/drawing/data/repositories/document_repository.dart';
import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/core/errors/failure.dart';

class CanvasInteractionDelegate {
  final CanvasManipulationService _canvasManipulationService;
  final TransformationService _transformationService;

  CanvasInteractionDelegate(
    this._canvasManipulationService,
    this._transformationService,
  );

  // ==========================================
  // SELECTION METHODS
  // ==========================================

  Result<CanvasState> setSelectionBox(CanvasState state, Rect? rect) {
    return Result.success(state.copyWith(
      transform: state.transform.copyWith(selectionBox: rect),
    ));
  }

  Result<CanvasState> selectElementAt(CanvasState state, Offset localPosition,
      {bool isMultiSelect = false}) {
    final reversedElements = state.elements.reversed;
    String? foundId;
    for (final element in reversedElements) {
      if (element.containsPoint(localPosition)) {
        foundId = element.id;
        break;
      }
    }

    if (foundId != null) {
      if (isMultiSelect) {
        final newSelection = Set<String>.from(state.selectedElementIds);
        if (newSelection.contains(foundId)) {
          newSelection.remove(foundId);
        } else {
          newSelection.add(foundId);
        }
        return Result.success(state.copyWith(
          interaction: state.interaction.copyWith(
            selectedElementIds: newSelection,
          ),
        ));
      } else {
        if (!state.selectedElementIds.contains(foundId)) {
          return Result.success(state.copyWith(
            interaction: state.interaction.copyWith(
              selectedElementIds: {foundId},
            ),
          ));
        }
        return Result.success(state);
      }
    } else {
      if (!isMultiSelect) {
        return Result.success(state.copyWith(
          interaction: state.interaction.copyWith(selectedElementIds: {}),
        ));
      }
      return Result.success(state);
    }
  }

  Result<CanvasState> selectElementsInRect(
      CanvasState state, Rect selectionRect) {
    final selected = <String>{};
    for (final element in state.elements) {
      if (selectionRect.overlaps(element.bounds)) {
        selected.add(element.id);
      }
    }
    return Result.success(state.copyWith(
      interaction: state.interaction.copyWith(selectedElementIds: selected),
    ));
  }

  Result<CanvasState> setHoveredElement(CanvasState state, String? id) {
    return Result.success(state.copyWith(
      interaction: state.interaction.copyWith(hoveredElementId: id),
    ));
  }

  // ==========================================
  // MANIPULATION METHODS
  // ==========================================

  Result<CanvasState> moveSelectedElements({
    required CanvasState state,
    required Offset delta,
  }) {
    if (state.selectedElementIds.isEmpty) return Result.success(state);

    final updatedElements = _canvasManipulationService.moveElements(
      state.document.elements,
      state.selectedElementIds,
      delta,
    );

    final updatedDoc = state.document.copyWith(elements: updatedElements);
    return Result.success(state.copyWith(document: updatedDoc));
  }

  Result<CanvasState> resizeSelectedElement({
    required CanvasState state,
    required Rect rect,
  }) {
    if (state.selectedElementIds.length != 1) return Result.success(state);
    final id = state.selectedElementIds.first;
    final updatedElements = state.document.elements.map((element) {
      if (element.id != id) return element;
      return _transformationService.resizeAndPlace(element, rect);
    }).toList();
    final updatedDoc = state.document.copyWith(elements: updatedElements);
    return Result.success(state.copyWith(document: updatedDoc));
  }

  Result<CanvasState> rotateSelectedElement({
    required CanvasState state,
    required double angle,
  }) {
    if (state.selectedElementIds.length != 1) return Result.success(state);
    final id = state.selectedElementIds.first;
    final updatedElements = state.document.elements.map((element) {
      if (element.id != id) return element;
      return _transformationService.rotateElement(element, angle);
    }).toList();
    final updatedDoc = state.document.copyWith(elements: updatedElements);
    return Result.success(state.copyWith(document: updatedDoc));
  }

  Result<CanvasState> updateLineEndpoint({
    required CanvasState state,
    required bool isStart,
    required Offset worldPoint,
    bool snapAngle = false,
    double? angleStep,
  }) {
    if (state.selectedElementIds.length != 1) return Result.success(state);
    final id = state.selectedElementIds.first;
    final updatedElements = state.document.elements.map((element) {
      if (element.id != id) return element;
      return _transformationService.updateLineOrArrowEndpoint(
        element: element,
        isStart: isStart,
        worldPoint: worldPoint,
        snapAngle: snapAngle,
        angleStep: angleStep,
      );
    }).toList();
    final updatedDoc = state.document.copyWith(elements: updatedElements);
    return Result.success(state.copyWith(document: updatedDoc));
  }

  Future<Result<CanvasState>> finalizeManipulation({
    required CanvasState state,
    required DocumentRepository documentRepository,
  }) async {
    try {
      await documentRepository.saveDocument(state.document);
      return Result.success(state.copyWith(error: null));
    } catch (e) {
      return Result.failure(ServerFailure('Erro ao salvar alterações: $e'));
    }
  }

  Result<CanvasState> deleteSelectedElements({
    required CanvasState state,
    required CommandStackService commandStack,
    required void Function(List<CanvasElement>) applyCallback,
    required void Function(DrawingDocument) scheduleSave,
  }) {
    if (state.selectedElementIds.isEmpty) return Result.success(state);

    final before = List<CanvasElement>.from(state.document.elements);
    final updatedElements = _canvasManipulationService.deleteElements(
      state.document.elements,
      state.selectedElementIds,
    );

    final updatedDoc = state.document.copyWith(elements: updatedElements);
    final newState = state.copyWith(
      document: updatedDoc,
      interaction: state.interaction.copyWith(
        selectedElementIds: {},
        activeElementId: null,
      ),
    );

    commandStack.add(
      ElementsCommand(
        before: before,
        after: List<CanvasElement>.from(updatedElements),
        applyElements: applyCallback,
        label: 'Remover',
      ),
    );
    scheduleSave(updatedDoc);

    return Result.success(newState);
  }

  Result<CanvasState> deleteElementById({
    required CanvasState state,
    required String elementId,
    required CommandStackService commandStack,
    required void Function(List<CanvasElement>) applyCallback,
    required void Function(DrawingDocument) scheduleSave,
  }) {
    final before = List<CanvasElement>.from(state.document.elements);
    final updatedElements =
        state.document.elements.where((e) => e.id != elementId).toList();
    if (updatedElements.length == before.length) return Result.success(state);
    final updatedDoc = state.document.copyWith(elements: updatedElements);
    final updatedSelection = Set<String>.from(state.selectedElementIds)
      ..remove(elementId);

    final newState = state.copyWith(
      document: updatedDoc,
      interaction: state.interaction.copyWith(
        selectedElementIds: updatedSelection,
        activeElementId:
            state.activeElementId == elementId ? null : state.activeElementId,
      ),
    );

    commandStack.add(
      ElementsCommand(
        before: before,
        after: List<CanvasElement>.from(updatedElements),
        applyElements: applyCallback,
        label: 'Remover',
      ),
    );
    scheduleSave(updatedDoc);
    return Result.success(newState);
  }

  Result<CanvasState> updateSelectedElementsProperties({
    required CanvasState state,
    required CommandStackService commandStack,
    required void Function(List<CanvasElement>) applyCallback,
    required void Function(DrawingDocument) scheduleSave,
    required ElementStylePatch patch,
  }) {
    final newStyle = patch.applyTo(state.currentStyle);

    final styleUpdatedState = state.copyWith(
      interaction: state.interaction.copyWith(currentStyle: newStyle),
    );

    if (state.selectedElementIds.isEmpty) {
      return Result.success(styleUpdatedState);
    }

    final before = List<CanvasElement>.from(state.document.elements);
    final updatedElements = _canvasManipulationService.updateElementsProperties(
      state.document.elements,
      state.selectedElementIds,
      patch,
    );

    final updatedDoc = state.document.copyWith(elements: updatedElements);
    final finalState = styleUpdatedState.copyWith(document: updatedDoc);

    if (!listEquals(before, updatedElements)) {
      commandStack.add(
        ElementsCommand(
          before: before,
          after: List<CanvasElement>.from(updatedElements),
          applyElements: applyCallback,
          label: 'Ajustar estilo',
        ),
      );
    }
    scheduleSave(updatedDoc);
    return Result.success(finalState);
  }

  Result<CanvasState> updateCurrentStyle({
    required CanvasState state,
    required ElementStyle style,
  }) {
    return Result.success(
      state.copyWith(
        interaction: state.interaction.copyWith(currentStyle: style),
      ),
    );
  }
}
