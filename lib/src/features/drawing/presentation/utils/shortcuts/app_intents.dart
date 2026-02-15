import 'package:flutter/widgets.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';

/// Intent to delete selected elements.
class DeleteSelectedElementsIntent extends Intent {
  const DeleteSelectedElementsIntent();
}

/// Intent to undo the last action.
class UndoIntent extends Intent {
  const UndoIntent();
}

/// Intent to redo the last undone action.
class RedoIntent extends Intent {
  const RedoIntent();
}

/// Intent to select a specific tool.
class SelectToolIntent extends Intent {
  final CanvasElementType tool;
  const SelectToolIntent(this.tool);
}

/// Intent to clear the canvas.
class ClearCanvasIntent extends Intent {
  const ClearCanvasIntent();
}

