import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';

class GestureSnapshotHelper {
  static void begin(CanvasCubit cubit, String label) {
    cubit.beginCommandGesture(label);
  }

  static void end(CanvasCubit cubit) {
    cubit.endCommandGesture();
  }
}
