import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/undo_redo/domain/entities/command.dart';

class TransformElementCommand implements Command {
  final List<CanvasElement> _before;
  final List<CanvasElement> _after;
  final void Function(List<CanvasElement>) _applyElements;
  final String _label;

  TransformElementCommand({
    required List<CanvasElement> before,
    required List<CanvasElement> after,
    required void Function(List<CanvasElement>) applyElements,
    String label = 'Transformar',
  }) : _before = before,
       _after = after,
       _applyElements = applyElements,
       _label = label;

  @override
  void execute() => _applyElements(_after);

  @override
  void undo() => _applyElements(_before);

  @override
  String get label => _label;
}

