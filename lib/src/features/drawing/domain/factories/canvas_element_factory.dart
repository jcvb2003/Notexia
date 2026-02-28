import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_entities.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

/// Factory responsible for creating new Canvas Elements.
class CanvasElementFactory {
  /// Creates a new [CanvasElement] based on the provided [type].
  /// Returns null if the type does not correspond to a creatable element (like selection).
  static CanvasElement? create({
    required CanvasElementType type,
    required String id,
    required Offset position,
    Color strokeColor = AppColors.paletteNeutral,
    Color? fillColor,
    double strokeWidth = 2.0,
    StrokeStyle strokeStyle = StrokeStyle.solid,
    FillType fillType = FillType.transparent,
    double opacity = 1.0,
    double roughness = 0.0,
  }) {
    final now = DateTime.now();

    switch (type) {
      case CanvasElementType.rectangle:
        return RectangleElement(
          id: id,
          x: position.dx,
          y: position.dy,
          width: 0,
          height: 0,
          strokeColor: strokeColor,
          fillColor: fillColor,
          strokeWidth: strokeWidth,
          strokeStyle: strokeStyle,
          fillType: fillType,
          opacity: opacity,
          roughness: roughness,
          updatedAt: now,
        );
      case CanvasElementType.ellipse:
        return EllipseElement(
          id: id,
          x: position.dx,
          y: position.dy,
          width: 0,
          height: 0,
          strokeColor: strokeColor,
          fillColor: fillColor,
          strokeWidth: strokeWidth,
          strokeStyle: strokeStyle,
          fillType: fillType,
          opacity: opacity,
          roughness: roughness,
          updatedAt: now,
        );
      case CanvasElementType.diamond:
        return DiamondElement(
          id: id,
          x: position.dx,
          y: position.dy,
          width: 0,
          height: 0,
          strokeColor: strokeColor,
          fillColor: fillColor,
          strokeWidth: strokeWidth,
          strokeStyle: strokeStyle,
          fillType: fillType,
          opacity: opacity,
          roughness: roughness,
          updatedAt: now,
        );
      case CanvasElementType.triangle:
        return TriangleElement(
          id: id,
          x: position.dx,
          y: position.dy,
          width: 0,
          height: 0,
          strokeColor: strokeColor,
          fillColor: fillColor,
          strokeWidth: strokeWidth,
          strokeStyle: strokeStyle,
          fillType: fillType,
          opacity: opacity,
          roughness: roughness,
          updatedAt: now,
        );
      case CanvasElementType.line:
        return LineElement(
          id: id,
          x: position.dx,
          y: position.dy,
          width: 0,
          height: 0,
          strokeColor: strokeColor,
          strokeWidth: strokeWidth,
          strokeStyle: strokeStyle,
          opacity: opacity,
          roughness: roughness,
          updatedAt: now,
          points: [const Offset(0, 0)],
        );
      case CanvasElementType.arrow:
        return ArrowElement(
          id: id,
          x: position.dx,
          y: position.dy,
          width: 0,
          height: 0,
          strokeColor: strokeColor,
          strokeWidth: strokeWidth,
          strokeStyle: strokeStyle,
          opacity: opacity,
          roughness: roughness,
          updatedAt: now,
          points: [const Offset(0, 0)],
        );
      case CanvasElementType.freeDraw:
        return FreeDrawElement(
          id: id,
          x: position.dx,
          y: position.dy,
          width: 0,
          height: 0,
          strokeColor: strokeColor,
          strokeWidth: strokeWidth,
          opacity: opacity,
          roughness: roughness,
          updatedAt: now,
          points: [const Offset(0, 0)],
        );
      case CanvasElementType.text:
        return TextElement(
          id: id,
          x: position.dx,
          y: position.dy,
          width: 100, // Default width
          height: 30, // Default height
          strokeColor: strokeColor,
          opacity: opacity,
          updatedAt: now,
          text: '',
        );
      case CanvasElementType.image:
      case CanvasElementType.eraser:
      case CanvasElementType.selection:
      case CanvasElementType.navigation:
        return null;
    }
  }
}
