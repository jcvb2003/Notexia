import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';

/// Dados comuns a todos os elementos do canvas.
class CanvasElementCommonData {
  final String id;
  final CanvasElementType type;
  final double x;
  final double y;
  final double width;
  final double height;
  final double angle;
  final Color strokeColor;
  final Color? fillColor;
  final double strokeWidth;
  final StrokeStyle strokeStyle;
  final FillType fillType;
  final double opacity;
  final double roughness;
  final int zIndex;
  final bool isDeleted;
  final int version;
  final int versionNonce;
  final DateTime updatedAt;

  const CanvasElementCommonData({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.angle,
    required this.strokeColor,
    this.fillColor,
    required this.strokeWidth,
    required this.strokeStyle,
    required this.fillType,
    required this.opacity,
    required this.roughness,
    required this.zIndex,
    required this.isDeleted,
    required this.version,
    required this.versionNonce,
    required this.updatedAt,
  });
}

/// Interface para fÃ¡bricas de elementos.
abstract class ElementFactory<T extends CanvasElement> {
  T create(CanvasElementCommonData common, Map<String, dynamic> map);
}

