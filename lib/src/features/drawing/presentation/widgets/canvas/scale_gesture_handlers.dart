import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:notexia/src/app/config/constants/app_constants.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/utils/resize_math_utils.dart';
import 'package:notexia/src/features/drawing/presentation/inputs/middleware/input_event.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_input_router.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/selection_handles.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/snapshot_hit_utils.dart';

class ScaleGestureHandlers {
  static void handleScaleStart(
    CanvasInputRouter router,
    ScaleStartInputEvent event,
  ) {
    final details = event.details;
    final uiState = event.state;
    if (details.pointerCount == 1) {
      _handlePanStart(router, details.localFocalPoint, uiState, event.kind);
    } else {
      router.setScaleStart(
        uiState.zoomLevel,
        router.toWorld(details.localFocalPoint, uiState),
      );
    }
  }

  static void handleScaleUpdate(
    CanvasInputRouter router,
    ScaleUpdateInputEvent event,
  ) {
    final details = event.details;
    final uiState = event.state;
    final selectedTool = event.selectedTool;

    if (details.pointerCount == 1) {
      _handlePanUpdate(
        router,
        details.localFocalPoint,
        event.worldFocalDelta, // Usa o delta processado pelo middleware
        uiState,
        event.kind,
      );
    } else {
      final isNavOrSelection = selectedTool == CanvasElementType.selection ||
          selectedTool == CanvasElementType.navigation;
      // Sempre permite zoom com dois dedos se for toque ou modo zoom estiver on
      final zoomEnabled = uiState.isZoomMode ||
          isNavOrSelection ||
          event.kind == PointerDeviceKind.touch;
      if (!zoomEnabled) return;
      if (details.scale != 1.0 &&
          router.scaleStartZoom != null &&
          router.scaleStartFocalWorld != null) {
        final nextZoom = (router.scaleStartZoom! * details.scale).clamp(
          AppConstants.minZoom,
          AppConstants.maxZoom,
        );
        final nextPan =
            details.localFocalPoint - (router.scaleStartFocalWorld! * nextZoom);
        router.canvasCubit.setZoom(nextZoom);
        router.canvasCubit.setPanOffset(nextPan);
      } else if (details.focalPointDelta != Offset.zero) {
        router.canvasCubit.panBy(details.focalPointDelta);
      }
    }
  }

  static void handleScaleEnd(
    CanvasInputRouter router,
    ScaleEndInputEvent event,
  ) {
    _handlePanEnd(router, event.state);
    router.clearScaleStart();
  }

  static void _handlePanStart(
    CanvasInputRouter router,
    Offset localPosition,
    CanvasState uiState,
    PointerDeviceKind kind,
  ) {
    final worldPoint = router.toWorld(localPosition, uiState);
    final hitId = SnapshotHitUtils.hitTest(router.canvasCubit, worldPoint);

    // MODO CANETA: Se for toque e não habilitado desenho com dedo,
    // forçar comportamento de navegação ou seleção.
    if (kind == PointerDeviceKind.touch && !uiState.isDrawWithFingerEnabled) {
      if (hitId != null) {
        // Se acertou algo, selecionar/mover
        if (!router.canvasCubit.state.selectedElementIds.contains(hitId)) {
          router.canvasCubit.selectElementAt(worldPoint);
        }
        SnapshotHitUtils.beginGestureSnapshot(router.canvasCubit, 'Mover');
        router.isDraggingSelection = true;
      } else {
        // Se fundo, Panning (Navigation)
        router.canvasCubit.setSelectionBox(null);
        router.isDraggingSelection = false;
        // O Panning real acontece no _handlePanUpdate via NavigationTool logic
      }
      return;
    }

    if (router.canvasCubit.state.selectedTool == CanvasElementType.navigation) {
      router.canvasCubit.setSelectionBox(null);
      router.isDraggingSelection = false;
      return;
    }
    if (router.canvasCubit.state.selectedTool == CanvasElementType.eraser) {
      SnapshotHitUtils.beginGestureSnapshot(router.canvasCubit, 'Apagar');
      router.canvasCubit.startEraser(worldPoint);
      eraseAt(router, uiState, worldPoint);
      return;
    }
    if (router.canvasCubit.state.selectedTool == CanvasElementType.text) {
      return;
    }
    final element = router.selectedElement;
    final handle = element == null
        ? null
        : SelectionHandles.hitTestSelectionHandle(worldPoint, uiState, element);
    if (handle != null) {
      router.activeHandle = handle;
      router.resizeStartRect = router.selectedElement?.bounds;
      if (handle == SelectionHandle.rotate && router.selectedElement != null) {
        final element = router.selectedElement!;
        final center = element.bounds.center;
        final localPoint = ResizeMathUtils.toLocalForElement(
          worldPoint,
          element,
        );
        router.rotateStartPointerAngle = math.atan2(
          localPoint.dy - center.dy,
          localPoint.dx - center.dx,
        );
        router.rotateStartAngle = element.angle;
        SnapshotHitUtils.beginGestureSnapshot(router.canvasCubit, 'Rotacionar');
      } else {
        SnapshotHitUtils.beginGestureSnapshot(
          router.canvasCubit,
          'Redimensionar',
        );
      }
      router.canvasCubit.setSelectionBox(null);
      return;
    }

    if (router.canvasCubit.state.selectedTool != CanvasElementType.selection) {
      if (hitId != null &&
          router.canvasCubit.state.selectedElementIds.contains(hitId)) {
        SnapshotHitUtils.beginGestureSnapshot(router.canvasCubit, 'Mover');
        router.isDraggingSelection = true;
        return;
      }
      SnapshotHitUtils.beginGestureSnapshot(router.canvasCubit, 'Desenhar');
      router.canvasCubit.drawing.startDrawing(worldPoint);
      return;
    }
    if (hitId != null) {
      if (!router.canvasCubit.state.selectedElementIds.contains(hitId)) {
        router.canvasCubit.selectElementAt(worldPoint);
      }
      SnapshotHitUtils.beginGestureSnapshot(router.canvasCubit, 'Mover');
      router.isDraggingSelection = true;
    } else {
      router.isDraggingSelection = false;
      router.selectionStart = worldPoint;
      router.canvasCubit.setSelectionBox(
        Rect.fromPoints(worldPoint, worldPoint),
      );
    }
  }

  static void _handlePanUpdate(
    CanvasInputRouter router,
    Offset localPosition,
    Offset deltaWorld, // Agora recebe deltaWorld diretamente
    CanvasState uiState,
    PointerDeviceKind kind,
  ) {
    // MODO CANETA: Se toque e não habilitado desenho com dedo,
    // se não estiver arrastando seleção, fazer Panning.
    if (kind == PointerDeviceKind.touch && !uiState.isDrawWithFingerEnabled) {
      if (!router.isDraggingSelection && router.activeHandle == null) {
        router.canvasCubit.panBy(deltaWorld * uiState.zoomLevel);
        return;
      }
    }

    if (router.canvasCubit.state.selectedTool == CanvasElementType.navigation) {
      // Navigation uses screen delta for 1:1 panning.
      // deltaWorld = screenDelta/zoom, so multiply back to restore screen-space.
      router.canvasCubit.panBy(deltaWorld * uiState.zoomLevel);
      return;
    }
    if (router.canvasCubit.state.selectedTool == CanvasElementType.eraser) {
      final worldPoint = router.toWorld(localPosition, uiState);
      router.canvasCubit.updateEraserTrail(worldPoint);
      eraseAt(router, uiState, worldPoint);
      return;
    }
    if (router.canvasCubit.state.selectedTool == CanvasElementType.text) {
      return;
    }
    if (router.activeHandle != null) {
      router.updateHandleDrag(router.toWorld(localPosition, uiState));
      return;
    }
    if (router.isDraggingSelection) {
      // Snapping logic removed from here, handled by middleware!
      router.canvasCubit.moveSelectedElements(deltaWorld);
      return;
    }
    if (router.canvasCubit.state.selectedTool != CanvasElementType.selection) {
      final keepAspect = _isShiftPressed() && _isShapeTool(router);
      final snapAngle =
          (_isShiftPressed() || router.canvasCubit.state.isAngleSnapEnabled) &&
              _isLineTool(router);
      final createFromCenter = _isAltPressed() && _isShapeTool(router);
      router.canvasCubit.drawing.updateDrawing(
        router.toWorld(localPosition, uiState),
        keepAspect: keepAspect,
        snapAngle: snapAngle,
        snapAngleStep: router.canvasCubit.state.angleSnapStep,
        createFromCenter: createFromCenter,
      );
      return;
    }
    final start = router.selectionStart;
    if (start != null) {
      final current = router.toWorld(localPosition, uiState);
      router.canvasCubit.setSelectionBox(
        Rect.fromPoints(start, current),
      );
      return;
    }
  }

  static Future<void> _handlePanEnd(
    CanvasInputRouter router,
    CanvasState uiState,
  ) async {
    if (router.canvasCubit.state.selectedTool == CanvasElementType.navigation) {
      return;
    }
    if (router.canvasCubit.state.selectedTool == CanvasElementType.eraser) {
      router.canvasCubit.endEraser();
      SnapshotHitUtils.endGestureSnapshot(router.canvasCubit);
      return;
    }
    if (router.activeHandle != null) {
      router.activeHandle = null;
      router.resizeStartRect = null;
      router.rotateStartAngle = null;
      router.rotateStartPointerAngle = null;
      await router.canvasCubit.finalizeManipulation();
      SnapshotHitUtils.endGestureSnapshot(router.canvasCubit);
      return;
    }
    if (router.isDraggingSelection) {
      await router.canvasCubit.finalizeManipulation();
      SnapshotHitUtils.endGestureSnapshot(router.canvasCubit);
      router.isDraggingSelection = false;
      return;
    }
    if (router.canvasCubit.state.selectedTool != CanvasElementType.selection) {
      await router.canvasCubit.drawing.stopDrawing();
      SnapshotHitUtils.endGestureSnapshot(router.canvasCubit);
      return;
    }
    final selectionStart = router.selectionStart;
    if (selectionStart != null) {
      final rect = uiState.selectionBox ??
          Rect.fromPoints(selectionStart, selectionStart);
      router.canvasCubit.selectElementsInRect(rect);
      router.selectionStart = null;
      router.canvasCubit.setSelectionBox(null);
      return;
    } else {
      if (router.isDraggingSelection) {
        await router.canvasCubit.finalizeManipulation();
        SnapshotHitUtils.endGestureSnapshot(router.canvasCubit);
      }
    }
    router.isDraggingSelection = false;
  }

  static void eraseAt(
    CanvasInputRouter router,
    CanvasState uiState,
    Offset worldPoint,
  ) {
    final radius = 12.0 / uiState.zoomLevel;
    final mode = uiState.eraserMode;
    if (mode == EraserMode.all) {
      if (router.canvasCubit.state.elements.isNotEmpty) {
        router.canvasCubit.clearCanvas();
      }
      return;
    }
    if (mode == EraserMode.stroke) {
      router.canvasCubit.eraseElementsAtPoint(worldPoint, radius);
    }
  }

  static bool _isShapeTool(CanvasInputRouter router) =>
      switch (router.canvasCubit.state.selectedTool) {
        CanvasElementType.rectangle ||
        CanvasElementType.ellipse ||
        CanvasElementType.diamond ||
        CanvasElementType.triangle =>
          true,
        _ => false,
      };

  static bool _isLineTool(CanvasInputRouter router) =>
      switch (router.canvasCubit.state.selectedTool) {
        CanvasElementType.line || CanvasElementType.arrow => true,
        _ => false,
      };

  static bool _isShiftPressed() {
    return HardwareKeyboard.instance.logicalKeysPressed.contains(
          LogicalKeyboardKey.shiftLeft,
        ) ||
        HardwareKeyboard.instance.logicalKeysPressed.contains(
          LogicalKeyboardKey.shiftRight,
        );
  }

  static bool _isAltPressed() {
    return HardwareKeyboard.instance.logicalKeysPressed.contains(
          LogicalKeyboardKey.altLeft,
        ) ||
        HardwareKeyboard.instance.logicalKeysPressed.contains(
          LogicalKeyboardKey.altRight,
        );
  }
}
