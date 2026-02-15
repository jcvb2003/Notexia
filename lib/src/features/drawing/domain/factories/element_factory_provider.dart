import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/factories/element_factory.dart';
import 'package:notexia/src/features/drawing/domain/factories/shape_factories.dart';
import 'package:notexia/src/features/drawing/domain/factories/linear_factories.dart';
import 'package:notexia/src/features/drawing/domain/factories/other_factories.dart';

class ElementFactoryProvider {
  static final Map<CanvasElementType, ElementFactory<CanvasElement>>
      _factories = {
    CanvasElementType.rectangle: RectangleFactory(),
    CanvasElementType.ellipse: EllipseFactory(),
    CanvasElementType.diamond: DiamondFactory(),
    CanvasElementType.triangle: TriangleFactory(),
    CanvasElementType.line: LineFactory(),
    CanvasElementType.arrow: ArrowFactory(),
    CanvasElementType.freeDraw: FreeDrawFactory(),
    CanvasElementType.text: TextFactory(),
  };

  static ElementFactory getFactory(CanvasElementType type) {
    final factory = _factories[type];
    if (factory == null) {
      throw UnsupportedError('No factory found for element type: $type');
    }
    return factory;
  }
}
