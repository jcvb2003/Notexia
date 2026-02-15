import 'dart:ui';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/text_element.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/text_editing_delegate.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:uuid/uuid.dart';

class TextScope {
  final CanvasState Function() _getState;
  final void Function(CanvasState) _emit;
  final void Function(DrawingDocument) _saveDocument;
  final void Function(String) _deleteElementById;
  final void Function(List<CanvasElement>) _applyCommand;
  final CommandStackService _commandStack;
  final PersistenceService _persistenceService;
  final Uuid _uuid;

  final _delegate = const TextEditingDelegate();

  TextScope(
    this._getState,
    this._emit,
    this._saveDocument,
    this._deleteElementById,
    this._applyCommand,
    this._commandStack,
    this._persistenceService,
    this._uuid,
  );

  String? createTextElement(Offset position) => _delegate.createTextElement(
        state: _getState(),
        position: position,
        uuid: _uuid,
        commandStack: _commandStack,
        emit: _emit,
        applyCallback: _applyCommand,
      );

  void updateTextElement(String elementId, String text) =>
      _delegate.updateTextElement(
        state: _getState(),
        elementId: elementId,
        text: text,
        emit: _emit,
        scheduleSave: _saveDocument,
      );

  void commitTextEditing(String elementId, String text) =>
      _delegate.commitTextEditing(
        state: _getState(),
        elementId: elementId,
        text: text,
        emit: _emit,
        scheduleSave: _saveDocument,
        persistenceService: _persistenceService,
        deleteElementByIdCallback: _deleteElementById,
      );

  Future<void> finalizeTextEditing(String elementId) =>
      _delegate.finalizeTextEditing(
        state: _getState(),
        elementId: elementId,
        persistenceService: _persistenceService,
        emit: _emit,
      );

  void setEditingText(String? id) =>
      _delegate.setEditingText(state: _getState(), id: id, emit: _emit);

  void handleTextToolTap(Offset worldPosition,
      void Function(CanvasElementType) selectToolCallback) {
    CanvasElement? clickedElement;
    for (final element in _getState().document.elements.reversed) {
      if (element.containsPoint(worldPosition)) {
        clickedElement = element;
        break;
      }
    }

    if (clickedElement is TextElement) {
      setEditingText(clickedElement.id);
      selectToolCallback(CanvasElementType.selection);
      return;
    }

    final newId = createTextElement(worldPosition);
    setEditingText(newId);
    selectToolCallback(CanvasElementType.selection);
  }
}
