import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';

import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';
import 'package:notexia/src/features/drawing/domain/services/canvas_manipulation_service.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:notexia/src/features/drawing/domain/commands/remove_element_command.dart';
import 'package:notexia/src/features/drawing/domain/commands/update_style_command.dart';
import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';

class ElementManipulationDelegate {
  final CanvasManipulationService _canvasManipulationService;
  final TransformationService _transformationService;

  ElementManipulationDelegate(
    this._canvasManipulationService,
    this._transformationService,
  );

  void moveSelectedElements({
    required CanvasState state,
    required Offset delta,
    required void Function(CanvasState) emit,
  }) {
    if (state.selectedElementIds.isEmpty) return;

    final updatedElements = _canvasManipulationService.moveElements(
      state.document.elements,
      state.selectedElementIds,
      delta,
    );

    final updatedDoc = state.document.copyWith(elements: updatedElements);
    emit(state.copyWith(document: updatedDoc));
  }

  void resizeSelectedElement({
    required CanvasState state,
    required Rect rect,
    required void Function(CanvasState) emit,
  }) {
    if (state.selectedElementIds.length != 1) return;
    final id = state.selectedElementIds.first;
    final updatedElements = state.document.elements.map((element) {
      if (element.id != id) return element;
      return _transformationService.resizeAndPlace(element, rect);
    }).toList();
    final updatedDoc = state.document.copyWith(elements: updatedElements);
    emit(state.copyWith(document: updatedDoc));
  }

  void rotateSelectedElement({
    required CanvasState state,
    required double angle,
    required void Function(CanvasState) emit,
  }) {
    if (state.selectedElementIds.length != 1) return;
    final id = state.selectedElementIds.first;
    final updatedElements = state.document.elements.map((element) {
      if (element.id != id) return element;
      return _transformationService.rotateElement(element, angle);
    }).toList();
    final updatedDoc = state.document.copyWith(elements: updatedElements);
    emit(state.copyWith(document: updatedDoc));
  }

  void updateLineEndpoint({
    required CanvasState state,
    required bool isStart,
    required Offset worldPoint,
    required void Function(CanvasState) emit,
    bool snapAngle = false,
    double? angleStep,
  }) {
    if (state.selectedElementIds.length != 1) return;
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
    emit(state.copyWith(document: updatedDoc));
  }

  Future<void> finalizeManipulation({
    required CanvasState state,
    required DocumentRepository documentRepository,
    required void Function(CanvasState) emit,
  }) async {
    try {
      await documentRepository.saveDocument(state.document);
      emit(state.copyWith(error: null));
    } catch (e) {
      emit(state.copyWith(error: 'Erro ao salvar alterações: $e'));
    }
  }

  void deleteSelectedElements({
    required CanvasState state,
    required CommandStackService commandStack,
    required void Function(CanvasState) emit,
    required void Function(List<CanvasElement>) applyCallback,
    required void Function(DrawingDocument) scheduleSave,
  }) {
    if (state.selectedElementIds.isEmpty) return;

    final before = List<CanvasElement>.from(state.document.elements);
    final updatedElements = _canvasManipulationService.deleteElements(
      state.document.elements,
      state.selectedElementIds,
    );

    final updatedDoc = state.document.copyWith(elements: updatedElements);
    emit(
      state.copyWith(
        document: updatedDoc,
        interaction: state.interaction.copyWith(
          selectedElementIds: [],
          activeElementId: null,
        ),
      ),
    );

    commandStack.add(
      RemoveElementCommand(
        before: before,
        after: List<CanvasElement>.from(updatedElements),
        applyElements: applyCallback,
        label: 'Remover',
      ),
    );
    scheduleSave(updatedDoc);
  }

  void deleteElementById({
    required CanvasState state,
    required String elementId,
    required CommandStackService commandStack,
    required void Function(CanvasState) emit,
    required void Function(List<CanvasElement>) applyCallback,
    required void Function(DrawingDocument) scheduleSave,
  }) {
    final before = List<CanvasElement>.from(state.document.elements);
    final updatedElements =
        state.document.elements.where((e) => e.id != elementId).toList();
    if (updatedElements.length == before.length) return;
    final updatedDoc = state.document.copyWith(elements: updatedElements);
    final updatedSelection = List<String>.from(state.selectedElementIds)
      ..remove(elementId);

    emit(
      state.copyWith(
        document: updatedDoc,
        interaction: state.interaction.copyWith(
          selectedElementIds: updatedSelection,
          activeElementId:
              state.activeElementId == elementId ? null : state.activeElementId,
        ),
      ),
    );

    commandStack.add(
      RemoveElementCommand(
        before: before,
        after: List<CanvasElement>.from(updatedElements),
        applyElements: applyCallback,
        label: 'Remover',
      ),
    );
    scheduleSave(updatedDoc);
  }

  // I'll define it later if needed. For now I keep it in Cubit or I implement it here if I see it fits.
  // It fits.

  void updateSelectedElementsProperties({
    required CanvasState state,
    required CommandStackService commandStack,
    required void Function(CanvasState) emit,
    required void Function(List<CanvasElement>) applyCallback,
    required void Function(DrawingDocument) scheduleSave,
    required ElementStylePatch patch,
  }) {
    final newStyle = patch.applyTo(state.currentStyle);

    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(currentStyle: newStyle),
      ),
    );

    if (state.selectedElementIds.isEmpty) return;

    final before = List<CanvasElement>.from(state.document.elements);
    final updatedElements = _canvasManipulationService.updateElementsProperties(
      state.document.elements,
      state.selectedElementIds,
      patch,
    );

    final updatedDoc = state.document.copyWith(elements: updatedElements);
    emit(state.copyWith(document: updatedDoc));

    if (!listEquals(before, updatedElements)) {
      commandStack.add(
        UpdateStyleCommand(
          before: before,
          after: List<CanvasElement>.from(updatedElements),
          applyElements: applyCallback,
          label: 'Ajustar estilo',
        ),
      );
    }
    scheduleSave(updatedDoc);
  }

  void updateCurrentStyle({
    required CanvasState state,
    required ElementStyle style,
    required void Function(CanvasState) emit,
  }) {
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(currentStyle: style),
      ),
    );
  }
}
