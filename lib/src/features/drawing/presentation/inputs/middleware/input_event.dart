import 'package:flutter/gestures.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';

/// Classe base para todos os eventos de input processados pelo middleware.
abstract class InputEvent {
  final CanvasState state;
  final CanvasElementType selectedTool;
  bool handled = false;

  InputEvent({
    required this.state,
    required this.selectedTool,
  });
}

class PointerHoverInputEvent extends InputEvent {
  final PointerHoverEvent details;
  Offset worldPosition;

  PointerHoverInputEvent({
    required this.details,
    required super.state,
    required super.selectedTool,
    required this.worldPosition,
  });
}

class TapDownInputEvent extends InputEvent {
  final TapDownDetails details;
  final PointerDeviceKind kind;
  Offset worldPosition;

  TapDownInputEvent({
    required this.details,
    required this.kind,
    required super.state,
    required super.selectedTool,
    required this.worldPosition,
  });
}

class ScaleStartInputEvent extends InputEvent {
  final ScaleStartDetails details;
  final PointerDeviceKind kind;
  Offset worldFocal;

  ScaleStartInputEvent({
    required this.details,
    required this.kind,
    required super.state,
    required super.selectedTool,
    required this.worldFocal,
  });
}

class ScaleUpdateInputEvent extends InputEvent {
  final ScaleUpdateDetails details;
  final PointerDeviceKind kind;
  Offset worldFocal;
  Offset worldFocalDelta;
  final bool isDraggingSelection;

  ScaleUpdateInputEvent({
    required this.details,
    required this.kind,
    required super.state,
    required super.selectedTool,
    required this.worldFocal,
    required this.worldFocalDelta,
    required this.isDraggingSelection,
  });
}

class ScaleEndInputEvent extends InputEvent {
  final ScaleEndDetails details;
  final PointerDeviceKind kind;

  ScaleEndInputEvent({
    required this.details,
    required this.kind,
    required super.state,
    required super.selectedTool,
  });
}

class PointerSignalInputEvent extends InputEvent {
  final PointerSignalEvent signal;
  Offset worldPosition;

  PointerSignalInputEvent({
    required this.signal,
    required super.state,
    required super.selectedTool,
    required this.worldPosition,
  });
}
