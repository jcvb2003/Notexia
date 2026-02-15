import 'package:flutter/material.dart';

class GeometryUtils {
  static double distanceToSegment(Offset p, Offset v, Offset w) {
    final l2 = (v - w).distanceSquared;
    if (l2 == 0) return (p - v).distance;
    final t =
        ((p.dx - v.dx) * (w.dx - v.dx) + (p.dy - v.dy) * (w.dy - v.dy)) / l2;
    if (t < 0) return (p - v).distance;
    if (t > 1) return (p - w).distance;
    return (p - Offset(v.dx + t * (w.dx - v.dx), v.dy + t * (w.dy - v.dy)))
        .distance;
  }

  static bool isPointInEllipse(Offset point, Rect bounds) {
    if (!bounds.contains(point)) return false;
    final center = bounds.center;
    final a = bounds.width / 2;
    final b = bounds.height / 2;
    if (a <= 0 || b <= 0) return false;
    final dx = point.dx - center.dx;
    final dy = point.dy - center.dy;
    return (dx / a) * (dx / a) + (dy / b) * (dy / b) <= 1.0;
  }

  static bool isPointInDiamond(Offset point, Rect bounds) {
    if (!bounds.contains(point)) return false;
    final center = bounds.center;
    final h = bounds.width / 2;
    final v = bounds.height / 2;
    if (h <= 0 || v <= 0) return false;
    final dx = (point.dx - center.dx).abs();
    final dy = (point.dy - center.dy).abs();
    return (dx / h) + (dy / v) <= 1.0;
  }
}
