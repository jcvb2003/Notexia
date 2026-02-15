import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/presentation/utils/shortcuts/app_intents.dart';

class AppShortcuts {
  static Map<ShortcutActivator, Intent> get defaultShortcuts => {
    // Deletion
    const SingleActivator(LogicalKeyboardKey.delete):
        const DeleteSelectedElementsIntent(),
    const SingleActivator(LogicalKeyboardKey.backspace):
        const DeleteSelectedElementsIntent(),

    // Undo / Redo
    const SingleActivator(LogicalKeyboardKey.keyZ, control: true):
        const UndoIntent(),
    const SingleActivator(LogicalKeyboardKey.keyZ, control: true, shift: true):
        const RedoIntent(),
    const SingleActivator(LogicalKeyboardKey.keyY, control: true):
        const RedoIntent(),

    // Tools
    const SingleActivator(LogicalKeyboardKey.keyV): const SelectToolIntent(
      CanvasElementType.selection,
    ),
    const SingleActivator(LogicalKeyboardKey.keyH): const SelectToolIntent(
      CanvasElementType.navigation,
    ),
    const SingleActivator(LogicalKeyboardKey.keyR): const SelectToolIntent(
      CanvasElementType.rectangle,
    ),
    const SingleActivator(LogicalKeyboardKey.keyD): const SelectToolIntent(
      CanvasElementType.diamond,
    ),
    const SingleActivator(LogicalKeyboardKey.keyA): const SelectToolIntent(
      CanvasElementType.arrow,
    ),
    const SingleActivator(LogicalKeyboardKey.keyL): const SelectToolIntent(
      CanvasElementType.line,
    ),
    const SingleActivator(LogicalKeyboardKey.keyP): const SelectToolIntent(
      CanvasElementType.freeDraw,
    ),
    const SingleActivator(LogicalKeyboardKey.keyT): const SelectToolIntent(
      CanvasElementType.text,
    ),
    const SingleActivator(LogicalKeyboardKey.keyE): const SelectToolIntent(
      CanvasElementType.eraser,
    ),

    // Numeric Shortcuts (1-0)
    const SingleActivator(LogicalKeyboardKey.digit1): const SelectToolIntent(
      CanvasElementType.selection,
    ),
    const SingleActivator(LogicalKeyboardKey.digit2): const SelectToolIntent(
      CanvasElementType.navigation,
    ),
    const SingleActivator(LogicalKeyboardKey.digit3): const SelectToolIntent(
      CanvasElementType.rectangle,
    ),
    const SingleActivator(LogicalKeyboardKey.digit4): const SelectToolIntent(
      CanvasElementType.diamond,
    ),
    const SingleActivator(LogicalKeyboardKey.digit5): const SelectToolIntent(
      CanvasElementType.arrow,
    ),
    const SingleActivator(LogicalKeyboardKey.digit6): const SelectToolIntent(
      CanvasElementType.line,
    ),
    const SingleActivator(LogicalKeyboardKey.digit7): const SelectToolIntent(
      CanvasElementType.freeDraw,
    ),
    const SingleActivator(LogicalKeyboardKey.digit8): const SelectToolIntent(
      CanvasElementType.text,
    ),
    const SingleActivator(LogicalKeyboardKey.digit9): const SelectToolIntent(
      CanvasElementType.image,
    ),
    const SingleActivator(LogicalKeyboardKey.digit0): const SelectToolIntent(
      CanvasElementType.eraser,
    ),
  };
}

