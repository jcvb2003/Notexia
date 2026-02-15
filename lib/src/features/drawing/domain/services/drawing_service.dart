import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/factories/canvas_element_factory.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';
import 'package:notexia/src/features/drawing/domain/services/canvas_manipulation_service.dart';
import 'package:uuid/uuid.dart';

class DrawingService {
  final Uuid _uuid;
  final CanvasManipulationService _canvasManipulationService;

  DrawingService({
    required CanvasManipulationService canvasManipulationService,
    Uuid? uuid,
  })  : _canvasManipulationService = canvasManipulationService,
        _uuid = uuid ?? const Uuid();

  /// Inicia o desenho de um novo elemento.
  CanvasElement? startDrawing({
    required CanvasElementType type,
    required Offset position,
    required ElementStyle style,
  }) {
    final newId = _uuid.v4();
    return CanvasElementFactory.create(
      type: type,
      id: newId,
      position: position,
      strokeColor: style.strokeColor,
      fillColor: style.fillColor,
      strokeWidth: style.strokeWidth,
      strokeStyle: style.strokeStyle,
      fillType: style.fillType,
      opacity: style.opacity,
      roughness: style.roughness,
    );
  }

  /// Atualiza o elemento que está sendo desenhado/manipulado.
  CanvasElement? updateDrawingElement({
    required CanvasElement element,
    required Offset currentPosition,
    required Offset startPosition,
    bool keepAspect = false,
    bool snapAngle = false,
    bool createFromCenter = false,
    double? snapAngleStep,
  }) {
    return _canvasManipulationService.updateDrawingElement(
      element,
      currentPosition,
      startPosition: startPosition,
      keepAspect: keepAspect,
      snapAngle: snapAngle,
      snapAngleStep: snapAngleStep,
      createFromCenter: createFromCenter,
    );
  }
}
