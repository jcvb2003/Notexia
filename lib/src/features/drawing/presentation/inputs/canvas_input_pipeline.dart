import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/services/object_snap_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Input Events
// ─────────────────────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────────────────────
// Pipeline & Middlewares
// ─────────────────────────────────────────────────────────────────────────────

/// Interface para middlewares que processam eventos de input.
abstract class InputMiddleware {
  /// Processa o evento.
  /// [next] deve ser chamado para passar o evento para o próximo middleware na cadeia.
  void handle(InputEvent event, void Function(InputEvent) next);
}

class InputPipeline {
  final List<InputMiddleware> _middlewares = [];

  // Handler final que será executado após todos os middlewares
  void Function(InputEvent)? onProcessed;

  void addMiddleware(InputMiddleware middleware) {
    _middlewares.add(middleware);
  }

  void process(InputEvent event) {
    _executeMiddleware(0, event);
  }

  void _executeMiddleware(int index, InputEvent event) {
    if (index >= _middlewares.length) {
      if (onProcessed != null && !event.handled) {
        onProcessed!(event);
      }
      return;
    }

    final middleware = _middlewares[index];
    middleware.handle(event, (nextEvent) {
      _executeMiddleware(index + 1, nextEvent);
    });
  }
}

class SnappingMiddleware implements InputMiddleware {
  @override
  void handle(InputEvent event, void Function(InputEvent) next) {
    if (event is ScaleUpdateInputEvent) {
      _handleScaleUpdate(event);
    }
    next(event);
  }

  void _handleScaleUpdate(ScaleUpdateInputEvent event) {
    if (!event.isDraggingSelection) return;

    final isShift = _isShiftPressed();
    final isSnapEnabled = event.state.isAngleSnapEnabled;

    if (isShift || isSnapEnabled) {
      final selectedIds = event.state.selectedElementIds;
      final elements = event.state.elements;
      final selectedElements =
          elements.where((e) => selectedIds.contains(e.id)).toList();

      if (selectedElements.isNotEmpty) {
        double minX = double.infinity, minY = double.infinity;
        double maxX = double.negativeInfinity, maxY = double.negativeInfinity;

        for (final el in selectedElements) {
          minX = math.min(minX, el.x);
          minY = math.min(minY, el.y);
          maxX = math.max(maxX, el.x + el.width);
          maxY = math.max(maxY, el.y + el.height);
        }

        final currentRect = Rect.fromLTRB(minX, minY, maxX, maxY);
        final targetRect = currentRect.shift(event.worldFocalDelta);

        final snapResult = ObjectSnapService.snapMove(
          targetRect: targetRect,
          referenceElements: elements,
          excludedElementIds: selectedIds,
        );

        if (snapResult.hasSnap) {
          event.worldFocalDelta += Offset(snapResult.dx, snapResult.dy);
        }
      }
    }
  }

  bool _isShiftPressed() {
    return HardwareKeyboard.instance.logicalKeysPressed.contains(
          LogicalKeyboardKey.shiftLeft,
        ) ||
        HardwareKeyboard.instance.logicalKeysPressed.contains(
          LogicalKeyboardKey.shiftRight,
        );
  }
}
