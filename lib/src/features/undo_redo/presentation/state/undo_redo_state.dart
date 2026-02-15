import 'package:equatable/equatable.dart';

abstract class UndoRedoState extends Equatable {
  final bool canUndo;
  final bool canRedo;
  final String? lastActionLabel;

  const UndoRedoState({
    this.canUndo = false,
    this.canRedo = false,
    this.lastActionLabel,
  });

  @override
  List<Object?> get props => [canUndo, canRedo, lastActionLabel];
}

class UndoRedoInitial extends UndoRedoState {}

class UndoRedoUpdated extends UndoRedoState {
  const UndoRedoUpdated({
    required super.canUndo,
    required super.canRedo,
    super.lastActionLabel,
  });
}
