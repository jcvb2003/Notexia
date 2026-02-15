import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

/// ServiÃ§o responsÃ¡vel por toda a lÃ³gica geomÃ©trica do canvas.
/// NÃ£o depende de estado, apenas realiza cÃ¡lculos.
class GeometryService {
  /// Verifica se um ponto estÃ¡ dentro do bounding box de um elemento.
  bool isPointInElement(Offset point, CanvasElement element) {
    // Hit-test bÃ¡sico usando o bounding box.
    // Futuramente implementaremos hit-tests precisos para elipses e diamantes.
    return element.bounds.contains(point);
  }

  /// Verifica se um elemento estÃ¡ contido em uma Ã¡rea de seleÃ§Ã£o (retÃ¢ngulo).
  bool isElementInSelection(Rect selectionRect, CanvasElement element) {
    return selectionRect.overlaps(element.bounds);
  }

  /// Calcula o bounding box que engloba mÃºltiplos elementos.
  Rect calculateGroupBounds(List<CanvasElement> elements) {
    if (elements.isEmpty) return Rect.zero;

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final element in elements) {
      final bounds = element.bounds;
      if (bounds.left < minX) minX = bounds.left;
      if (bounds.top < minY) minY = bounds.top;
      if (bounds.right > maxX) maxX = bounds.right;
      if (bounds.bottom > maxY) maxY = bounds.bottom;
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  static Offset snapVector(Offset vector, double step) {
    if (vector == Offset.zero) return vector;
    final angle = math.atan2(vector.dy, vector.dx);
    final snapped = (angle / step).round() * step;
    final length = vector.distance;
    return Offset(math.cos(snapped) * length, math.sin(snapped) * length);
  }

  static double snapAngle(double angle, double step) {
    return (angle / step).round() * step;
  }

  static (double, double, double, double, List<Offset>) normalizePoints(
    double originX,
    double originY,
    List<Offset> points,
  ) {
    if (points.isEmpty) {
      return (originX, originY, 0, 0, points);
    }
    var minX = points.first.dx;
    var minY = points.first.dy;
    var maxX = points.first.dx;
    var maxY = points.first.dy;
    for (final p in points) {
      if (p.dx < minX) minX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy > maxY) maxY = p.dy;
    }
    final shiftedPoints = points
        .map((p) => Offset(p.dx - minX, p.dy - minY))
        .toList();
    final width = maxX - minX;
    final height = maxY - minY;
    return (originX + minX, originY + minY, width, height, shiftedPoints);
  }
}

