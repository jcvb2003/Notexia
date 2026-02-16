import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

import 'package:notexia/src/features/drawing/presentation/rendering/element_renderer.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/renderers/rectangle_renderer.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/renderers/ellipse_renderer.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/renderers/diamond_renderer.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/renderers/triangle_renderer.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/renderers/line_renderer.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/renderers/arrow_renderer.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/renderers/free_draw_renderer.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/renderers/text_renderer.dart';

class RendererProvider {
  static final _rectangleRenderer = RectangleRenderer();
  static final _ellipseRenderer = EllipseRenderer();
  static final _diamondRenderer = DiamondRenderer();
  static final _triangleRenderer = TriangleRenderer();
  static final _lineRenderer = LineRenderer();
  static final _arrowRenderer = ArrowRenderer();
  static final _freeDrawRenderer = FreeDrawRenderer();
  static final _textRenderer = TextRenderer();

  /// Returns the appropriate [ElementRenderer] for the given [element].
  ///
  /// Uses pattern matching instead of `runtimeType` because Freezed
  /// generates private implementation classes (e.g. `_$RectangleElementImpl`)
  /// that don't match the public type aliases.
  static ElementRenderer getRenderer(CanvasElement element) {
    return switch (element) {
      RectangleElement() => _rectangleRenderer,
      DiamondElement() => _diamondRenderer,
      EllipseElement() => _ellipseRenderer,
      TriangleElement() => _triangleRenderer,
      LineElement() => _lineRenderer,
      ArrowElement() => _arrowRenderer,
      FreeDrawElement() => _freeDrawRenderer,
      TextElement() => _textRenderer,
    };
  }
}
