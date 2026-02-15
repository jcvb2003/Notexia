import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
    ScaleStartDetails details,
    CanvasState uiState,
    CanvasElementType selectedTool,
  ) {
    if (details.pointerCount == 1) {
      _handlePanStart(router, details.localFocalPoint, uiState);
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
      );
    } else {
      final isNavOrSelection =
          selectedTool == CanvasElementType.selection ||
          selectedTool == CanvasElementType.navigation;
      final zoomEnabled = uiState.isZoomMode || isNavOrSelection;
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
    ScaleEndDetails details,
    CanvasState uiState,
    CanvasElementType selectedTool,
  ) {
    _handlePanEnd(router, uiState);
    router.clearScaleStart();
  }

  static void _handlePanStart(
    CanvasInputRouter router,
    Offset localPosition,
    CanvasState uiState,
  ) {
    if (router.canvasCubit.state.selectedTool == CanvasElementType.navigation) {
      router.canvasCubit.setSelectionBox(null);
      router.isDraggingSelection = false;
      return;
    }
    if (router.canvasCubit.state.selectedTool == CanvasElementType.eraser) {
      final worldPoint = router.toWorld(localPosition, uiState);
      SnapshotHitUtils.beginGestureSnapshot(router.canvasCubit, 'Apagar');
      router.canvasCubit.startEraser(worldPoint);
      eraseAt(router, uiState, worldPoint);
      return;
    }
    if (router.canvasCubit.state.selectedTool == CanvasElementType.text) {
      return;
    }
    final worldPoint = router.toWorld(localPosition, uiState);
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
    final hitId = SnapshotHitUtils.hitTest(router.canvasCubit, worldPoint);
    if (router.canvasCubit.state.selectedTool != CanvasElementType.selection) {
      if (hitId != null &&
          router.canvasCubit.state.selectedElementIds.contains(hitId)) {
        SnapshotHitUtils.beginGestureSnapshot(router.canvasCubit, 'Mover');
        router.isDraggingSelection = true;
        return;
      }
      SnapshotHitUtils.beginGestureSnapshot(router.canvasCubit, 'Desenhar');
      router.canvasCubit.startDrawing(worldPoint);
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
  ) {
    if (router.canvasCubit.state.selectedTool == CanvasElementType.navigation) {
      // PanBy expects screen delta usually? Or world?
      // panBy implementation usually shifts panOffset. panOffset is in screen pixels?
      // Wait, panOffset is used in `toWorld` as `(screen - pan) / zoom`.
      // So panOffset is in screen coordinates (scaled?).
      // Let's check panBy. Assuming it takes screen delta.
      // But we passed processed delta.
      // If snapping modified deltaWorld, we should use it.
      // But panBy is for navigation. Snapping doesn't apply to navigation.
      // So we can fallback to original details for navigation if needed, or convert back.
      // However, SnappingMiddleware only touches delta if isDraggingSelection.
      // So for navigation, deltaWorld is just converted screen delta.
      // We need screen delta for panBy if panBy expects screen delta.
      
      // Let's assume panBy expects screen delta.
      // router.canvasCubit.panBy(deltaWorld * uiState.zoomLevel); // Revert?
      
      // Actually, let's look at `CanvasCubit.panBy`.
      // It likely updates `panOffset`.
      // If I use `deltaWorld`, it's `screenDelta / zoom`.
      // `panOffset += delta`.
      // If I pass `deltaWorld`, `panOffset += screenDelta / zoom`.
      // This means panning speed depends on zoom. Usually we want 1:1 screen movement.
      // So we should probably use `details.focalPointDelta` for panning, ignoring middleware.
      // But `_handlePanUpdate` is generic.
      
      // I will keep `delta` parameter as `deltaWorld` but maybe I need `screenDelta` too?
      // Or I can just use `router.toWorldDelta` reverse.
      
      // For now, let's check `_handlePanUpdate` usage.
      
      // Original code:
      // router.canvasCubit.panBy(delta); // delta was details.focalPointDelta (screen)
      
      // So I should pass screen delta for navigation.
      // But `handleScaleUpdate` calls `_handlePanUpdate`.
      
      // I will modify `_handlePanUpdate` to accept `screenDelta` as well or just use `deltaWorld` for drawing/moving.
      
      // Let's pass both?
      // Or just revert `deltaWorld` for `panBy`.
      
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
      router.canvasCubit.updateDrawing(
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
      router.canvasCubit.setSelectionBox(Rect.fromPoints(start, current));
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
      await router.canvasCubit.stopDrawing();
      SnapshotHitUtils.endGestureSnapshot(router.canvasCubit);
      return;
    }
    final selectionStart = router.selectionStart;
    if (selectionStart != null) {
      final rect =
          uiState.selectionBox ??
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
        CanvasElementType.triangle => true,
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

