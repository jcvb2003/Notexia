import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:notexia/src/app/config/constants/app_constants.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_input_router.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/snapshot_hit_utils.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/selection_handles.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/scale_gesture_handlers.dart';

class PointerHoverHandlers {
  static void handlePointerSignal(
    CanvasInputRouter self,
    PointerSignalEvent signal,
    CanvasState uiState,
    CanvasElementType selectedTool,
  ) {
    final isNavOrSelection = selectedTool == CanvasElementType.selection ||
        selectedTool == CanvasElementType.navigation;
    if (!uiState.isZoomMode && !isNavOrSelection) {
      return;
    }
    if (signal is PointerScrollEvent) {
      final isCtrlPressed =
          HardwareKeyboard.instance.logicalKeysPressed.contains(
                LogicalKeyboardKey.controlLeft,
              ) ||
              HardwareKeyboard.instance.logicalKeysPressed.contains(
                LogicalKeyboardKey.controlRight,
              );
      if (isCtrlPressed) {
        final direction = signal.scrollDelta.dy.sign;
        if (direction == 0) return;
        final factor = direction > 0 ? 0.95 : 1.05;
        final nextZoom = (uiState.zoomLevel * factor).clamp(
          AppConstants.minZoom,
          AppConstants.maxZoom,
        );
        final focal = signal.localPosition;
        final worldPoint = self.toWorld(focal, uiState);
        final nextPan = focal - (worldPoint * nextZoom);
        self.canvasCubit.setZoom(nextZoom);
        self.canvasCubit.setPanOffset(nextPan);
      } else {
        self.canvasCubit.panBy(-signal.scrollDelta);
      }
    }
  }

  static void handleTapDown(
    CanvasInputRouter self,
    TapDownDetails details,
    CanvasState uiState,
  ) {
    if (self.canvasCubit.state.selectedTool == CanvasElementType.eraser) {
      final worldPoint = self.toWorld(details.localPosition, uiState);
      SnapshotHitUtils.beginGestureSnapshot(self.canvasCubit, 'Apagar');
      self.canvasCubit.startEraser(worldPoint);
      ScaleGestureHandlers.eraseAt(self, uiState, worldPoint);
      Future.delayed(const Duration(milliseconds: 120), () {
        self.canvasCubit.endEraser();
        SnapshotHitUtils.endGestureSnapshot(self.canvasCubit);
      });
      return;
    }
    if (self.canvasCubit.state.selectedTool == CanvasElementType.selection) {
      self.canvasCubit.setSelectionBox(null);
      final worldPoint = self.toWorld(details.localPosition, uiState);
      final selectedElement = self.selectedElement;
      if (selectedElement != null) {
        final handle = SelectionHandles.hitTestSelectionHandle(
          worldPoint,
          uiState,
          selectedElement,
        );
        if (handle != null) {
          return;
        }
      }
      self.canvasCubit.selectElementAt(worldPoint);
    }
  }

  static void handleHover(
    CanvasInputRouter self,
    PointerHoverEvent event,
    CanvasState uiState,
  ) {
    if (self.canvasCubit.state.selectedTool != CanvasElementType.selection) {
      if (uiState.hoveredElementId != null) {
        self.canvasCubit.setHoveredElement(null);
      }
      return;
    }
    final worldPoint = self.toWorld(event.localPosition, uiState);
    final hitId = SnapshotHitUtils.hitTest(self.canvasCubit, worldPoint);
    if (hitId != uiState.hoveredElementId) {
      self.canvasCubit.setHoveredElement(hitId);
    }
  }
}
