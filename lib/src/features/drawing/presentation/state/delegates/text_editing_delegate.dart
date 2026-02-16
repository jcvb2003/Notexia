import 'dart:ui';
import 'package:uuid/uuid.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/factories/canvas_element_factory.dart';
import 'package:notexia/src/features/drawing/domain/helpers/canvas_helpers.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:notexia/src/features/drawing/domain/commands/add_element_command.dart';

import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';

class TextEditingDelegate {
  const TextEditingDelegate();

  String? createTextElement({
    required CanvasState state,
    required Offset position,
    required Uuid uuid,
    required CommandStackService commandStack,
    required void Function(CanvasState) emit,
    required void Function(List<CanvasElement>) applyCallback,
  }) {
    final newId = uuid.v4();
    final newElement = CanvasElementFactory.create(
      type: CanvasElementType.text,
      id: newId,
      position: position,
      strokeColor: state.currentStyle.strokeColor,
      opacity: state.currentStyle.opacity,
    );

    if (newElement == null) return null;

    final before = List<CanvasElement>.from(state.document.elements);
    final updatedDoc = state.document.copyWith(
      elements: [...state.document.elements, newElement],
    );

    emit(
      state.copyWith(
        document: updatedDoc,
        interaction: state.interaction.copyWith(
          selectedElementIds: [newId],
          activeElementId: newId,
        ),
      ),
    );

    commandStack.add(
      AddElementCommand(
        before: before,
        after: List<CanvasElement>.from(updatedDoc.elements),
        applyElements: applyCallback,
        label: 'Editar texto',
      ),
    );

    return newId;
  }

  CanvasState updateTextElement({
    required CanvasState state,
    required String elementId,
    required String text,
    required void Function(CanvasState) emit,
    required void Function(DrawingDocument) scheduleSave,
  }) {
    final updatedElements = state.document.elements.map((element) {
      if (element.id != elementId) return element;
      if (element is! TextElement) return element;
      final measured = CanvasHelpers.measureText(element, text);
      return element.copyWith(
        text: text,
        width: measured.width,
        height: measured.height,
        updatedAt: DateTime.now(),
      );
    }).toList();

    final updatedDoc = state.document.copyWith(elements: updatedElements);
    final newState = state.copyWith(document: updatedDoc);
    emit(newState);
    scheduleSave(updatedDoc);
    return newState;
  }

  Future<void> finalizeTextEditing({
    required CanvasState state,
    required String elementId,
    required PersistenceService persistenceService,
    required void Function(CanvasState) emit,
  }) async {
    final element = state.elements.where((e) => e.id == elementId).firstOrNull;
    if (element == null) return;
    try {
      await persistenceService.saveElement(state.document.id, element);
      emit(
        state.copyWith(
          error: null,
          interaction: state.interaction.copyWith(
            textEditing: state.interaction.textEditing.copyWith(
              editingTextId: null,
            ),
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Erro ao salvar elemento: $e'));
    }
  }

  void commitTextEditing({
    required CanvasState state,
    required String elementId,
    required String text,
    required void Function(CanvasState) emit,
    required void Function(DrawingDocument) scheduleSave,
    required PersistenceService persistenceService,
    required void Function(String) deleteElementByIdCallback,
  }) {
    if (text.trim().isEmpty) {
      deleteElementByIdCallback(elementId);
    } else {
      final newState = updateTextElement(
        state: state,
        elementId: elementId,
        text: text,
        emit: emit,
        scheduleSave: scheduleSave,
      );

      finalizeTextEditing(
        state: newState,
        elementId: elementId,
        persistenceService: persistenceService,
        emit: emit,
      );
    }
  }

  void setEditingText({
    required CanvasState state,
    required String? id,
    required void Function(CanvasState) emit,
  }) {
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(
          textEditing: state.interaction.textEditing.copyWith(
            editingTextId: id,
          ),
        ),
      ),
    );
  }
}
