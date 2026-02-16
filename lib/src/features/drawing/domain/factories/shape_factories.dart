import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

import 'package:notexia/src/features/drawing/domain/factories/element_factory.dart';

class RectangleFactory implements ElementFactory<RectangleElement> {
  @override
  RectangleElement create(
      CanvasElementCommonData common, Map<String, dynamic> map) {
    return RectangleElement(
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
    );
  }
}

class EllipseFactory implements ElementFactory<EllipseElement> {
  @override
  EllipseElement create(
      CanvasElementCommonData common, Map<String, dynamic> map) {
    return EllipseElement(
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
    );
  }
}

class DiamondFactory implements ElementFactory<DiamondElement> {
  @override
  DiamondElement create(
      CanvasElementCommonData common, Map<String, dynamic> map) {
    return DiamondElement(
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
    );
  }
}

class TriangleFactory implements ElementFactory<TriangleElement> {
  @override
  TriangleElement create(
      CanvasElementCommonData common, Map<String, dynamic> map) {
    return TriangleElement(
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
    );
  }
}
