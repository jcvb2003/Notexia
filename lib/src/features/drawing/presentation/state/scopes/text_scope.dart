import 'dart:ui';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';

import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/text_editing_delegate.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:uuid/uuid.dart';

class TextScope {
  final CanvasState Function() _getState;
  final void Function(CanvasState) _emit;
  final void Function(DrawingDocument) _saveDocument;
  final void Function(List<CanvasElement>) _applyCommand;
  final CommandStackService _commandStack;
  final PersistenceService _persistenceService;
  final Uuid _uuid;

  final TextEditingDelegate _delegate;

  TextScope(
    this._getState,
    this._emit,
    this._saveDocument,
    this._applyCommand,
    this._commandStack,
    this._persistenceService,
    this._uuid,
    this._delegate,
  );

  String? createTextElement(Offset position) {
    final result = _delegate.createTextElement(
      state: _getState(),
      position: position,
      uuid: _uuid,
      commandStack: _commandStack,
      applyCallback: _applyCommand,
    );

    if (result.isSuccess) {
      final (id, state) = result.data!;
      _emit(state);
      return id;
    }
    return null;
  }

  void updateTextElement(String elementId, String text) {
    final result = _delegate.updateTextElement(
      state: _getState(),
      elementId: elementId,
      text: text,
      scheduleSave: _saveDocument,
    );
    if (result.isSuccess) _emit(result.data!);
  }

  Future<void> commitTextEditing(String elementId, String text) async {
    final result = await _delegate.commitTextEditing(
      state: _getState(),
      elementId: elementId,
      text: text,
      scheduleSave: _saveDocument,
      persistenceService: _persistenceService,
      commandStack: _commandStack,
      applyCallback: _applyCommand,
    );
    if (result.isSuccess) _emit(result.data!);
  }

  Future<void> finalizeTextEditing(String elementId) async {
    final result = await _delegate.finalizeTextEditing(
      state: _getState(),
      elementId: elementId,
      persistenceService: _persistenceService,
    );
    if (result.isSuccess) _emit(result.data!);
  }

  void setEditingText(String? id) {
    final result = _delegate.setEditingText(state: _getState(), id: id);
    if (result.isSuccess) _emit(result.data!);
  }

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
