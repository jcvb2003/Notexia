import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/undo_redo/domain/entities/command.dart';

import '../helpers/canvas_helpers.dart';

/// Comando unificado para qualquer alteração em elementos do canvas.
/// Substitui AddElementCommand, RemoveElementCommand, TransformElementCommand e UpdateStyleCommand.
class ElementsCommand implements Command {
  @override
  final String label;
  final List<CanvasElement> before;
  final List<CanvasElement> after;
  final ApplyElementsCallback applyElements;

  const ElementsCommand({
    required this.label,
    required this.before,
    required this.after,
    required this.applyElements,
  });

  @override
  void execute() {
    applyElements(after);
  }

  @override
  void undo() {
    applyElements(before);
  }
}
