import 'package:flutter/material.dart';
import 'package:notexia/src/core/canvas/primitives/geometry_utils.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';

/// Representa uma elipse (cÃ­rculo) no canvas.
class EllipseElement extends CanvasElement {
  const EllipseElement({
    required super.id,
    super.type = CanvasElementType.ellipse,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    super.angle,
    required super.strokeColor,
    super.fillColor,
    super.strokeWidth,
    super.strokeStyle,
    super.fillType,
    super.opacity,
    super.roughness,
    super.zIndex,
    super.isDeleted,
    super.version,
    super.versionNonce,
    required super.updatedAt,
  });

  @override
  EllipseElement copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    double? angle,
    Color? strokeColor,
    Color? fillColor,
    double? strokeWidth,
    StrokeStyle? strokeStyle,
    FillType? fillType,
    double? opacity,
    double? roughness,
    int? zIndex,
    bool? isDeleted,
    int? version,
    int? versionNonce,
    DateTime? updatedAt,
  }) {
    return EllipseElement(
      id: id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      angle: angle ?? this.angle,
      strokeColor: strokeColor ?? this.strokeColor,
      fillColor: fillColor ?? this.fillColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeStyle: strokeStyle ?? this.strokeStyle,
      fillType: fillType ?? this.fillType,
      opacity: opacity ?? this.opacity,
      roughness: roughness ?? this.roughness,
      zIndex: zIndex ?? this.zIndex,
      isDeleted: isDeleted ?? this.isDeleted,
      version: version ?? this.version,
      versionNonce: versionNonce ?? this.versionNonce,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // render removido.

  @override
  bool containsPoint(Offset point) {
    return GeometryUtils.isPointInEllipse(point, bounds);
  }
}

