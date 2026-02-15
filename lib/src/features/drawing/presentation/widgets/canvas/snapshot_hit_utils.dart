import 'package:flutter/widgets.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';

class SnapshotHitUtils {
  static String? hitTest(CanvasCubit canvasCubit, Offset worldPoint) {
    final elements = canvasCubit.state.elements;
    for (var i = elements.length - 1; i >= 0; i--) {
      if (elements[i].containsPoint(worldPoint)) {
        return elements[i].id;
      }
    }
    return null;
  }

  static void beginGestureSnapshot(CanvasCubit canvasCubit, String label) {
    canvasCubit.beginCommandGesture(label);
  }

  static void endGestureSnapshot(CanvasCubit canvasCubit) {
    canvasCubit.endCommandGesture();
  }
}
