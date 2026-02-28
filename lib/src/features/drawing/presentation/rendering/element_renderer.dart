import 'dart:ui';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

/// Interface base para renderizadores de elementos do canvas.
abstract class ElementRenderer<T extends CanvasElement> {
  void render(Canvas canvas, T element);
}
