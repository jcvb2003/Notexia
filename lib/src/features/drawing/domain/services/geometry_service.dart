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
    final shiftedPoints =
        points.map((p) => Offset(p.dx - minX, p.dy - minY)).toList();
    final width = maxX - minX;
    final height = maxY - minY;
    return (originX + minX, originY + minY, width, height, shiftedPoints);
  }

  /// Calcula a distância de um ponto para um segmento de reta definido por [a] e [b].
  static double distanceToSegment(Offset p, Offset a, Offset b) {
    final x = p.dx;
    final y = p.dy;
    final x1 = a.dx;
    final y1 = a.dy;
    final x2 = b.dx;
    final y2 = b.dy;

    final A = x - x1;
    final B = y - y1;
    final C = x2 - x1;
    final D = y2 - y1;

    final dot = A * C + B * D;
    final lenSq = C * C + D * D;
    double param = -1;

    if (lenSq != 0) {
      param = dot / lenSq;
    }

    double xx, yy;

    if (param < 0) {
      xx = x1;
      yy = y1;
    } else if (param > 1) {
      xx = x2;
      yy = y2;
    } else {
      xx = x1 + param * C;
      yy = y1 + param * D;
    }

    final dx = x - xx;
    final dy = y - yy;

    return math.sqrt(dx * dx + dy * dy);
  }

  /// Verifica se um ponto está dentro de um diamante (losango).
  static bool isPointInDiamond(Offset point, Rect bounds) {
    // Transforma o ponto para coordenadas relativas ao centro do diamante
    final center = bounds.center;
    final dx = (point.dx - center.dx).abs();
    final dy = (point.dy - center.dy).abs();
    final width = bounds.width;
    final height = bounds.height;

    // Equação do losango: |x|/a + |y|/b <= 1
    // onde a = width/2 e b = height/2
    return (dx / (width / 2)) + (dy / (height / 2)) <= 1.0;
  }

  /// Verifica se um ponto está dentro de uma elipse.
  static bool isPointInEllipse(Offset point, Rect bounds) {
    final center = bounds.center;
    final rx = bounds.width / 2;
    final ry = bounds.height / 2;

    if (rx == 0 || ry == 0) return false;

    final dx = point.dx - center.dx;
    final dy = point.dy - center.dy;

    // Equação da elipse: (x-h)²/a² + (y-k)²/b² <= 1
    return ((dx * dx) / (rx * rx)) + ((dy * dy) / (ry * ry)) <= 1.0;
  }
}
