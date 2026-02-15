import 'dart:ui';
import 'package:notexia/src/app/config/constants/app_constants.dart';
import 'package:notexia/src/core/canvas/primitives/geometry_service.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/utils/resize_math_utils.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/selection_handles.dart';

class CanvasGestureMath {
  static Offset toLocalForElement(Offset worldPoint, CanvasElement element) {
    return ResizeMathUtils.toLocalForElement(worldPoint, element);
  }

  static Rect resizeFromHandle(
    SelectionHandle handle,
    Rect startRect,
    Offset point, {
    required bool keepAspect,
  }) {
    final mapped = switch (handle) {
      SelectionHandle.topLeft => ResizeHandleType.topLeft,
      SelectionHandle.topRight => ResizeHandleType.topRight,
      SelectionHandle.bottomLeft => ResizeHandleType.bottomLeft,
      SelectionHandle.bottomRight => ResizeHandleType.bottomRight,
      SelectionHandle.top => ResizeHandleType.top,
      SelectionHandle.right => ResizeHandleType.right,
      SelectionHandle.bottom => ResizeHandleType.bottom,
      SelectionHandle.left => ResizeHandleType.left,
      _ => ResizeHandleType.topLeft,
    };
    return ResizeMathUtils.resizeFromHandle(
      mapped,
      startRect,
      point,
      keepAspect: keepAspect,
      minSize: AppConstants.minElementSize,
    );
  }

  static double snapAngle(double angle, bool enabled, double step) {
    if (!enabled) return angle;
    return GeometryService.snapAngle(angle, step);
  }
}

