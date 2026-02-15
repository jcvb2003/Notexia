import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';

import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_gesture_math.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/pointer_hover_handlers.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/scale_gesture_handlers.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/selection_handles.dart';
import 'package:notexia/src/features/drawing/presentation/inputs/middleware/input_pipeline.dart';
import 'package:notexia/src/features/drawing/presentation/inputs/middleware/input_event.dart';
import 'package:notexia/src/features/drawing/presentation/inputs/middleware/snapping_middleware.dart';

class CanvasInputRouter {
  final CanvasCubit canvasCubit;
  final InputPipeline _pipeline = InputPipeline();

  // State exposed for handlers
  double? scaleStartZoom;
  Offset? scaleStartFocalWorld;
  Offset? selectionStart;
  bool isDraggingSelection = false;
  SelectionHandle? activeHandle;
  Rect? resizeStartRect;
  double? rotateStartAngle;
  double? rotateStartPointerAngle;

  CanvasInputRouter({required this.canvasCubit}) {
    _registerMiddlewares();
  }

  void _registerMiddlewares() {
    _pipeline.addMiddleware(SnappingMiddleware());

    // Configura o handler final para eventos processados
    _pipeline.onProcessed = (event) {
      if (event is ScaleUpdateInputEvent) {
        ScaleGestureHandlers.handleScaleUpdate(this, event);
      } else if (event is PointerHoverInputEvent) {
        PointerHoverHandlers.handleHover(this, event.details, event.state);
      } else if (event is TapDownInputEvent) {
        PointerHoverHandlers.handleTapDown(this, event.details, event.state);
      } else if (event is ScaleStartInputEvent) {
        ScaleGestureHandlers.handleScaleStart(
          this,
          event.details,
          event.state,
          event.selectedTool,
        );
      } else if (event is ScaleEndInputEvent) {
        ScaleGestureHandlers.handleScaleEnd(
          this,
          event.details,
          event.state,
          event.selectedTool,
        );
      } else if (event is PointerSignalInputEvent) {
        PointerHoverHandlers.handlePointerSignal(
          this,
          event.signal,
          event.state,
          event.selectedTool,
        );
      }
    };
  }

  void handlePointerSignal(
    PointerSignalEvent signal,
    CanvasState uiState,
    CanvasElementType selectedTool,
  ) {
    final event = PointerSignalInputEvent(
      signal: signal,
      state: uiState,
      selectedTool: selectedTool,
      worldPosition: toWorld(signal.localPosition, uiState),
    );
    _pipeline.process(event);
  }

  void handleTapDown(TapDownDetails details, CanvasState uiState) {
    // Se estiver editando texto, finaliza ao clicar fora (ou deixa o foco cuidar, mas aqui garantimos)
    if (uiState.editingTextId != null) {
      canvasCubit.finalizeTextEditing(uiState.editingTextId!);
      return;
    }

    final worldPosition = toWorld(details.localPosition, uiState);

    // Lógica específica para ferramenta de Texto
    if (uiState.selectedTool == CanvasElementType.text) {
      canvasCubit.handleTextToolTap(worldPosition);
      return;
    }

    final event = TapDownInputEvent(
      details: details,
      state: uiState,
      selectedTool: canvasCubit.state.selectedTool,
      worldPosition: worldPosition,
    );
    _pipeline.process(event);
  }

  void handleHover(PointerHoverEvent event, CanvasState uiState) {
    final inputEvent = PointerHoverInputEvent(
      details: event,
      state: uiState,
      selectedTool: canvasCubit.state.selectedTool,
      worldPosition: toWorld(event.localPosition, uiState),
    );
    _pipeline.process(inputEvent);
  }

  void handleScaleStart(
    ScaleStartDetails details,
    CanvasState uiState,
    CanvasElementType selectedTool,
  ) {
    final event = ScaleStartInputEvent(
      details: details,
      state: uiState,
      selectedTool: selectedTool,
      worldFocal: toWorld(details.localFocalPoint, uiState),
    );
    _pipeline.process(event);
  }

  void handleScaleUpdate(
    ScaleUpdateDetails details,
    CanvasState uiState,
    CanvasElementType selectedTool,
  ) {
    // Cria o evento e passa pelo pipeline
    final worldFocal = toWorld(details.localFocalPoint, uiState);
    final worldFocalDelta = toWorldDelta(details.focalPointDelta, uiState);

    final event = ScaleUpdateInputEvent(
      details: details,
      state: uiState,
      selectedTool: selectedTool,
      worldFocal: worldFocal,
      worldFocalDelta: worldFocalDelta,
      isDraggingSelection: isDraggingSelection,
    );

    _pipeline.process(event);
  }

  void handleScaleEnd(
    ScaleEndDetails details,
    CanvasState uiState,
    CanvasElementType selectedTool,
  ) {
    final event = ScaleEndInputEvent(
      details: details,
      state: uiState,
      selectedTool: selectedTool,
    );
    _pipeline.process(event);
  }

  Offset toWorld(Offset screenPoint, CanvasState uiState) {
    return (screenPoint - uiState.panOffset) / uiState.zoomLevel;
  }

  Offset toWorldDelta(Offset screenDelta, CanvasState uiState) {
    return screenDelta / uiState.zoomLevel;
  }

  CanvasElement? get selectedElement {
    final ids = canvasCubit.state.selectedElementIds;
    if (ids.length != 1) return null;
    final id = ids.first;
    for (final element in canvasCubit.state.elements) {
      if (element.id == id) return element;
    }
    return null;
  }

  void setScaleStart(double zoom, Offset focal) {
    scaleStartZoom = zoom;
    scaleStartFocalWorld = focal;
  }

  void clearScaleStart() {
    scaleStartZoom = null;
    scaleStartFocalWorld = null;
  }

  void updateHandleDrag(Offset worldPoint) {
    final handle = activeHandle;
    if (handle == null) return;
    final element = selectedElement;
    if (element == null) return;

    if (handle == SelectionHandle.rotate) {
      final center = element.bounds.center;
      final localPoint = CanvasGestureMath.toLocalForElement(
        worldPoint,
        element,
      );
      final currentPointerAngle = math.atan2(
        localPoint.dy - center.dy,
        localPoint.dx - center.dx,
      );
      final startPointerAngle = rotateStartPointerAngle;
      final startAngle = rotateStartAngle;
      if (startPointerAngle == null || startAngle == null) return;
      final nextAngle = startAngle + (currentPointerAngle - startPointerAngle);
      final snapEnabled =
          _isShiftPressed || canvasCubit.state.isAngleSnapEnabled;
      final step = canvasCubit.state.angleSnapStep;
      canvasCubit.rotateSelectedElement(
        CanvasGestureMath.snapAngle(nextAngle, snapEnabled, step),
      );
      return;
    }

    if (handle == SelectionHandle.lineStart ||
        handle == SelectionHandle.lineEnd) {
      final isStart = handle == SelectionHandle.lineStart;
      canvasCubit.updateLineEndpoint(
        isStart: isStart,
        worldPoint: worldPoint,
        snapAngle: _isShiftPressed || canvasCubit.state.isAngleSnapEnabled,
        angleStep: canvasCubit.state.angleSnapStep,
      );
      return;
    }

    final startRect = resizeStartRect;
    if (startRect == null) return;
    final localPoint = CanvasGestureMath.toLocalForElement(worldPoint, element);
    final newRect = CanvasGestureMath.resizeFromHandle(
      handle,
      startRect,
      localPoint,
      keepAspect: _isShiftPressed,
    );
    canvasCubit.resizeSelectedElement(newRect);
  }

  bool get _isShiftPressed {
    return HardwareKeyboard.instance.logicalKeysPressed.contains(
          LogicalKeyboardKey.shiftLeft,
        ) ||
        HardwareKeyboard.instance.logicalKeysPressed.contains(
          LogicalKeyboardKey.shiftRight,
        );
  }
}
