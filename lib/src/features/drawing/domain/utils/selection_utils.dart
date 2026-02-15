import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_entities.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';

class SelectionUtils {
  static bool isLineElement(CanvasElement element) {
    return element is LineElement || element is ArrowElement;
  }

  static bool isLineElementType(CanvasElementType type) {
    return type == CanvasElementType.line || type == CanvasElementType.arrow;
  }

  static bool isResizableElementType(CanvasElementType type) {
    return switch (type) {
      CanvasElementType.rectangle ||
      CanvasElementType.ellipse ||
      CanvasElementType.diamond ||
      CanvasElementType.triangle ||
      CanvasElementType.text ||
      CanvasElementType.image => true,
      _ => false,
    };
  }

  static (Offset, Offset)? lineEndpoints(CanvasElement element) {
    if (element is LineElement) {
      if (element.points.length < 2) return null;
      final start = Offset(element.x, element.y) + element.points[0];
      final end = Offset(element.x, element.y) + element.points[1];
      return (start, end);
    }
    if (element is ArrowElement) {
      if (element.points.length < 2) return null;
      final start = Offset(element.x, element.y) + element.points[0];
      final end = Offset(element.x, element.y) + element.points[1];
      return (start, end);
    }
    return null;
  }

  static Offset computeRotateHandleCenter(
    Rect rect,
    double zoomLevel, {
    double rotateOffset = 24.0,
  }) {
    return rect.topCenter.translate(0, -rotateOffset / zoomLevel);
  }
}

