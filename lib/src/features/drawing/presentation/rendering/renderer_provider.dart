import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/rectangle_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/ellipse_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/diamond_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/triangle_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/line_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/arrow_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/free_draw_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/text_element.dart';

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
  static final Map<Type, ElementRenderer> _renderers = {
    RectangleElement: RectangleRenderer(),
    EllipseElement: EllipseRenderer(),
    DiamondElement: DiamondRenderer(),
    TriangleElement: TriangleRenderer(),
    LineElement: LineRenderer(),
    ArrowElement: ArrowRenderer(),
    FreeDrawElement: FreeDrawRenderer(),
    TextElement: TextRenderer(),
  };

  static ElementRenderer<T> getRenderer<T extends CanvasElement>(T element) {
    final renderer = _renderers[element.runtimeType];
    if (renderer != null) {
      return renderer as ElementRenderer<T>;
    }

    throw UnimplementedError(
        'Renderer not found for type ${element.runtimeType}');
  }
}
