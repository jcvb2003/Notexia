import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/utils/selection_utils.dart';
import 'package:notexia/src/features/drawing/domain/utils/resize_math_utils.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';

enum SelectionHandle {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  top,
  right,
  bottom,
  left,
  rotate,
  lineStart,
  lineEnd,
}

class SelectionHitTester {
  static SelectionHandle? hitTestHandle(
    Offset worldPoint,
    CanvasState uiState,
    CanvasElement element,
  ) {
    if (SelectionUtils.isLineElementType(element.type)) {
      final points = SelectionUtils.lineEndpoints(element);
      if (points != null) {
        final touchSize = 16.0 / uiState.zoomLevel;
        final startRect = Rect.fromCenter(
          center: points.$1,
          width: touchSize,
          height: touchSize,
        );
        if (startRect.contains(worldPoint)) {
          return SelectionHandle.lineStart;
        }
        final endRect = Rect.fromCenter(
          center: points.$2,
          width: touchSize,
          height: touchSize,
        );
        if (endRect.contains(worldPoint)) {
          return SelectionHandle.lineEnd;
        }
      }
      return null;
    }

    if (!SelectionUtils.isResizableElementType(element.type)) return null;

    final rect = element.bounds.inflate(6 / uiState.zoomLevel);
    final localPoint = ResizeMathUtils.toLocalForElement(worldPoint, element);

    final touchSize = 16.0 / uiState.zoomLevel;
    const rotateOffset = 24.0;

    final rotateCenter = SelectionUtils.computeRotateHandleCenter(
      rect,
      uiState.zoomLevel,
      rotateOffset: rotateOffset,
    );
    if ((localPoint - rotateCenter).distance <= touchSize / 1.5) {
      return SelectionHandle.rotate;
    }

    final handlePositions = {
      SelectionHandle.topLeft: rect.topLeft,
      SelectionHandle.topRight: rect.topRight,
      SelectionHandle.bottomLeft: rect.bottomLeft,
      SelectionHandle.bottomRight: rect.bottomRight,
      SelectionHandle.top: rect.topCenter,
      SelectionHandle.right: rect.centerRight,
      SelectionHandle.bottom: rect.bottomCenter,
      SelectionHandle.left: rect.centerLeft,
    };

    for (final entry in handlePositions.entries) {
      final handleHitRect = Rect.fromCenter(
        center: entry.value,
        width: touchSize,
        height: touchSize,
      );
      if (handleHitRect.contains(localPoint)) {
        return entry.key;
      }
    }
    return null;
  }
}

