import 'dart:math' as math;

/// Specific constants for Notexia drawing elements and canvas.
class NotexiaConstants {
  // Drawing Defaults
  static const double defaultStrokeWidth = 2.0;
  static const double defaultRoughness = 1.0;
  static const double defaultOpacity = 1.0;

  // Element Sizes
  static const double minElementSize = 1.0;
  static const double defaultFontSize = 16.0;

  // Canvas
  static const double maxZoom = 20.0;
  static const double minZoom = 0.1;
  static const double zoomStep = 0.1;
  static const double angleSnapStep = math.pi / 12;

  // Grid
  static const double gridSize = 20.0;

  // Animation
  static const Duration canvasRefreshRate = Duration(
    milliseconds: 16,
  ); // ~60fps
}
