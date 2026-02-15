import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/line_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/arrow_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/free_draw_element.dart';
import 'package:notexia/src/features/drawing/domain/factories/element_factory.dart';

class LineFactory implements ElementFactory<LineElement> {
  @override
  LineElement create(CanvasElementCommonData common, Map<String, dynamic> map) {
    return LineElement(
      id: common.id,
      x: common.x,
      y: common.y,
      width: common.width,
      height: common.height,
      angle: common.angle,
      strokeColor: common.strokeColor,
      fillColor: common.fillColor,
      strokeWidth: common.strokeWidth,
      strokeStyle: common.strokeStyle,
      fillType: common.fillType,
      opacity: common.opacity,
      roughness: common.roughness,
      zIndex: common.zIndex,
      isDeleted: common.isDeleted,
      version: common.version,
      versionNonce: common.versionNonce,
      updatedAt: common.updatedAt,
      points: _parsePoints(map['points']),
    );
  }
}

class ArrowFactory implements ElementFactory<ArrowElement> {
  @override
  ArrowElement create(
      CanvasElementCommonData common, Map<String, dynamic> map) {
    return ArrowElement(
      id: common.id,
      x: common.x,
      y: common.y,
      width: common.width,
      height: common.height,
      angle: common.angle,
      strokeColor: common.strokeColor,
      fillColor: common.fillColor,
      strokeWidth: common.strokeWidth,
      strokeStyle: common.strokeStyle,
      fillType: common.fillType,
      opacity: common.opacity,
      roughness: common.roughness,
      zIndex: common.zIndex,
      isDeleted: common.isDeleted,
      version: common.version,
      versionNonce: common.versionNonce,
      updatedAt: common.updatedAt,
      points: _parsePoints(map['points']),
    );
  }
}

class FreeDrawFactory implements ElementFactory<FreeDrawElement> {
  @override
  FreeDrawElement create(
      CanvasElementCommonData common, Map<String, dynamic> map) {
    return FreeDrawElement(
      id: common.id,
      x: common.x,
      y: common.y,
      width: common.width,
      height: common.height,
      angle: common.angle,
      strokeColor: common.strokeColor,
      fillColor: common.fillColor,
      strokeWidth: common.strokeWidth,
      strokeStyle: common.strokeStyle,
      fillType: common.fillType,
      opacity: common.opacity,
      roughness: common.roughness,
      zIndex: common.zIndex,
      isDeleted: common.isDeleted,
      version: common.version,
      versionNonce: common.versionNonce,
      updatedAt: common.updatedAt,
      points: _parsePoints(map['points']),
    );
  }
}

List<Offset> _parsePoints(dynamic points) {
  if (points is List) {
    return points
        .map((p) => Offset(
              (p['x'] as num).toDouble(),
              (p['y'] as num).toDouble(),
            ))
        .toList();
  }
  return [];
}
