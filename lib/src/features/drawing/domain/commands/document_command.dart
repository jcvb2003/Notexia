import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/undo_redo/domain/entities/command.dart';

typedef ApplyDocumentCallback = void Function(DrawingDocument document);

class DocumentCommand implements Command {
  final DrawingDocument before;
  final DrawingDocument after;
  final ApplyDocumentCallback applyCallback;
  final String _label;

  DocumentCommand({
    required this.before,
    required this.after,
    required this.applyCallback,
    String? label,
  }) : _label = label ?? 'Modificar Documento';

  @override
  void execute() {
    applyCallback(after);
  }

  @override
  void undo() {
    applyCallback(before);
  }

  @override
  String get label => _label;
}
