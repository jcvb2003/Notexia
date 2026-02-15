import 'package:notexia/src/features/undo_redo/domain/entities/command.dart';
import 'dart:async';

class CommandStackService {
  final List<Command> _undoStack = [];
  final List<Command> _redoStack = [];
  final StreamController<void> _changes = StreamController.broadcast();

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;
  String? get lastActionLabel =>
      _undoStack.isNotEmpty ? _undoStack.last.label : null;
  Stream<void> get changes => _changes.stream;

  void add(Command command) {
    _undoStack.add(command);
    _redoStack.clear();
    _changes.add(null);
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    final command = _undoStack.removeLast();
    command.undo();
    _redoStack.add(command);
    _changes.add(null);
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    final command = _redoStack.removeLast();
    command.execute();
    _undoStack.add(command);
    _changes.add(null);
  }

  void clear() {
    _undoStack.clear();
    _redoStack.clear();
    _changes.add(null);
  }

  void dispose() {
    _changes.close();
  }
}
