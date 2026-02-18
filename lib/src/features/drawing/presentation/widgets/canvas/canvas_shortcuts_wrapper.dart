import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notexia/src/features/drawing/presentation/utils/shortcuts/app_intents.dart';
import 'package:notexia/src/features/drawing/presentation/utils/shortcuts/app_shortcuts.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/undo_redo/presentation/state/undo_redo_cubit.dart';

/// Wraps [child] with keyboard shortcut bindings for the canvas.
///
/// Shortcuts are disabled when [isTextEditing] is true so they don't
/// interfere with inline text input.
class CanvasShortcutsWrapper extends StatelessWidget {
  final bool isTextEditing;
  final Widget child;

  const CanvasShortcutsWrapper({
    super.key,
    required this.isTextEditing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final shortcuts = isTextEditing
        ? const <ShortcutActivator, Intent>{}
        : AppShortcuts.defaultShortcuts;

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          DeleteSelectedElementsIntent:
              CallbackAction<DeleteSelectedElementsIntent>(
            onInvoke: (_) {
              context.read<CanvasCubit>().manipulation.deleteSelectedElements();
              return null;
            },
          ),
          UndoIntent: CallbackAction<UndoIntent>(
            onInvoke: (_) {
              context.read<UndoRedoCubit>().undo();
              return null;
            },
          ),
          RedoIntent: CallbackAction<RedoIntent>(
            onInvoke: (_) {
              context.read<UndoRedoCubit>().redo();
              return null;
            },
          ),
          ClearCanvasIntent: CallbackAction<ClearCanvasIntent>(
            onInvoke: (_) {
              context.read<CanvasCubit>().clearCanvas();
              return null;
            },
          ),
          SelectToolIntent: CallbackAction<SelectToolIntent>(
            onInvoke: (intent) {
              context.read<CanvasCubit>().selectTool(intent.tool);
              return null;
            },
          ),
        },
        child: child,
      ),
    );
  }
}
