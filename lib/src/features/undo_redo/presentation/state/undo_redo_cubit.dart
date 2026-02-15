import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notexia/src/features/undo_redo/domain/entities/command.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:notexia/src/features/undo_redo/presentation/state/undo_redo_state.dart';

export 'package:notexia/src/features/undo_redo/presentation/state/undo_redo_state.dart';

class UndoRedoCubit extends Cubit<UndoRedoState> {
  final CommandStackService _commandStack;
  late final StreamSubscription<void> _subscription;

  UndoRedoCubit(this._commandStack) : super(UndoRedoInitial()) {
    _subscription = _commandStack.changes.listen((_) {
      _emitState();
    });
  }

  bool get canUndo => _commandStack.canUndo;
  bool get canRedo => _commandStack.canRedo;

  void addCommand(Command command) {
    _commandStack.add(command);
  }

  void undo() {
    _commandStack.undo();
  }

  void redo() {
    _commandStack.redo();
  }

  void _emitState() {
    emit(
      UndoRedoUpdated(
        canUndo: canUndo,
        canRedo: canRedo,
        lastActionLabel: _commandStack.lastActionLabel,
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
