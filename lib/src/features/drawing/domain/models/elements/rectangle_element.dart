import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';

/// Representa um retÃ¢ngulo no canvas.
class RectangleElement extends CanvasElement {
  const RectangleElement({
    required super.id,
    super.type = CanvasElementType.rectangle,
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
  RectangleElement copyWith({
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
    return RectangleElement(
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
}

