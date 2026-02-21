import 'dart:ui';
import 'package:uuid/uuid.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/factories/canvas_element_factory.dart';
import 'package:notexia/src/features/drawing/domain/helpers/canvas_helpers.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:notexia/src/features/drawing/domain/commands/elements_command.dart';

import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/core/errors/failure.dart';

class TextEditingDelegate {
  const TextEditingDelegate();

  Result<(String, CanvasState)> createTextElement({
    required CanvasState state,
    required Offset position,
    required Uuid uuid,
    required CommandStackService commandStack,
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

    if (newElement == null) {
      return Result.failure(
          const ServerFailure('Falha ao criar elemento de texto'));
    }

    final before = List<CanvasElement>.from(state.document.elements);
    final updatedDoc = state.document.copyWith(
      elements: [...state.document.elements, newElement],
    );

    final newState = state.copyWith(
      document: updatedDoc,
      interaction: state.interaction.copyWith(
        selectedElementIds: {newId},
        activeElementId: newId,
      ),
    );

    commandStack.add(
      ElementsCommand(
        before: before,
        after: List<CanvasElement>.from(updatedDoc.elements),
        applyElements: applyCallback,
        label: 'Editar texto',
      ),
    );

    return Result.success((newId, newState));
  }

  Result<CanvasState> updateTextElement({
    required CanvasState state,
    required String elementId,
    required String text,
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
    scheduleSave(updatedDoc);
    return Result.success(newState);
  }

  Future<Result<CanvasState>> finalizeTextEditing({
    required CanvasState state,
    required String elementId,
    required PersistenceService persistenceService,
  }) async {
    final element = state.elements.where((e) => e.id == elementId).firstOrNull;
    if (element == null) {
      return Result.success(
          state); // Or failure if preferred, but success with no change is safe
    }
    try {
      await persistenceService.saveElement(state.document.id, element);
      return Result.success(
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
      return Result.failure(ServerFailure('Erro ao salvar elemento: $e'));
    }
  }

  Future<Result<CanvasState>> commitTextEditing({
    required CanvasState state,
    required String elementId,
    required String text,
    required void Function(DrawingDocument) scheduleSave,
    required PersistenceService persistenceService,
    required CommandStackService commandStack,
    required void Function(List<CanvasElement>) applyCallback,
  }) async {
    if (text.trim().isEmpty) {
      final element =
          state.document.elements.where((e) => e.id == elementId).firstOrNull;
      if (element == null) return Result.success(state);

      final before = List<CanvasElement>.from(state.document.elements);
      final updatedElements =
          state.document.elements.where((e) => e.id != elementId).toList();
      final updatedDoc = state.document.copyWith(elements: updatedElements);

      final newState = state.copyWith(
        document: updatedDoc,
        interaction: state.interaction.copyWith(
          selectedElementIds:
              state.selectedElementIds.where((id) => id != elementId).toSet(),
          textEditing:
              state.interaction.textEditing.copyWith(editingTextId: null),
        ),
      );

      commandStack.add(
        ElementsCommand(
          before: before,
          after: List<CanvasElement>.from(updatedDoc.elements),
          applyElements: applyCallback,
          label: 'Excluir elemento',
        ),
      );

      scheduleSave(updatedDoc);
      return Result.success(newState);
    } else {
      final updateResult = updateTextElement(
        state: state,
        elementId: elementId,
        text: text,
        scheduleSave: scheduleSave,
      );

      if (updateResult.isFailure) return updateResult;

      return finalizeTextEditing(
        state: updateResult.data!,
        elementId: elementId,
        persistenceService: persistenceService,
      );
    }
  }

  Result<CanvasState> setEditingText({
    required CanvasState state,
    required String? id,
  }) {
    return Result.success(
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
