import 'dart:math' as math;
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
        if (signal.scrollDelta.dy == 0) return;

        final currentState = self.canvasCubit.state;
        final now = DateTime.now();

        // Verifica se temos uma sessão de scroll ativa e fresca (últimos 200ms)
        // Se a posição local do sinal mudou muito, resetamos a âncora para ser reativo ao mouse
        final bool isSessionValid = self.scrollStartFocalWorld != null &&
            self.lastScrollTime != null &&
            now.difference(self.lastScrollTime!).inMilliseconds < 200;

        if (!isSessionValid) {
          self.setScrollStart(self.toWorld(signal.localPosition, currentState));
        } else {
          // Atualiza o timestamp para manter a sessão viva
          self.lastScrollTime = now;
        }

        final factor = math.exp(-signal.scrollDelta.dy / 1000.0);
        final nextZoom = (currentState.zoomLevel * factor).clamp(
          AppConstants.minZoom,
          AppConstants.maxZoom,
        );

        // Usamos a âncora mundo original, mas a posição LOCAL atual do sinal
        // Isso permite que o centro do zoom "persiga" o mouse se ele se mover levemente,
        // mas sem o drift acumulado de re-projetar o ponto mundo a cada frame.
        final focal = signal.localPosition;
        final nextPan = focal - (self.scrollStartFocalWorld! * nextZoom);

        self.canvasCubit.setZoomAtPoint(nextZoom, nextPan);
      } else {
        self.canvasCubit.panBy(-signal.scrollDelta);
      }
    }
  }

  static void handleTapDown(
    CanvasInputRouter self,
    TapDownDetails details,
    CanvasState uiState,
    PointerDeviceKind kind,
  ) {
    if (self.canvasCubit.state.selectedTool == CanvasElementType.eraser) {
      if (!uiState.isDrawWithFingerEnabled) {
        if (kind != PointerDeviceKind.stylus &&
            kind != PointerDeviceKind.mouse) {
          return;
        }
      }

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
