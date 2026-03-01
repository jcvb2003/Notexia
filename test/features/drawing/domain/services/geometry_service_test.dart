import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/services/geometry_service.dart';

void main() {
  final now = DateTime(2026, 1, 1);

  group('GeometryService static helpers', () {
    test('snapVector keeps zero vector unchanged', () {
      expect(GeometryService.snapVector(Offset.zero, math.pi / 12), Offset.zero);
    });

    test('snapVector snaps to nearest angle step', () {
      final snapped = GeometryService.snapVector(const Offset(10, 6), math.pi / 6);
      final angle = math.atan2(snapped.dy, snapped.dx);
      expect(angle, closeTo(math.pi / 6, 0.02));
    });

    test('snapAngle rounds to nearest step', () {
      final snapped = GeometryService.snapAngle(0.62, 0.5);
      expect(snapped, 0.5);
    });

    test('normalizePoints shifts origin and points', () {
      final normalized = GeometryService.normalizePoints(
        100,
        200,
        const [Offset(-5, 3), Offset(10, 8)],
      );

      expect(normalized.$1, 95);
      expect(normalized.$2, 203);
      expect(normalized.$3, 15);
      expect(normalized.$4, 5);
      expect(normalized.$5, const [Offset(0, 0), Offset(15, 5)]);
    });

    test('distanceToSegment uses orthogonal projection when inside segment', () {
      final d = GeometryService.distanceToSegment(
        const Offset(5, 5),
        const Offset(0, 0),
        const Offset(10, 0),
      );
      expect(d, closeTo(5, 0.0001));
    });

    test('distanceToSegment uses endpoint when projection is outside segment', () {
      final d = GeometryService.distanceToSegment(
        const Offset(20, 4),
        const Offset(0, 0),
        const Offset(10, 0),
      );
      expect(d, closeTo(math.sqrt(116), 0.0001));
    });

    test('isPointInDiamond validates center and outside', () {
      final bounds = Rect.fromLTWH(0, 0, 20, 20);
      expect(GeometryService.isPointInDiamond(const Offset(10, 10), bounds), isTrue);
      expect(GeometryService.isPointInDiamond(const Offset(0, 0), bounds), isFalse);
    });

    test('isPointInEllipse validates center and outside', () {
      final bounds = Rect.fromLTWH(0, 0, 20, 10);
      expect(GeometryService.isPointInEllipse(const Offset(10, 5), bounds), isTrue);
      expect(GeometryService.isPointInEllipse(const Offset(20, 10), bounds), isFalse);
    });
  });

  group('GeometryService instance methods', () {
    final service = GeometryService();

    test('calculateGroupBounds returns zero for empty list', () {
      expect(service.calculateGroupBounds(const []), Rect.zero);
    });

    test('calculateGroupBounds combines multiple element bounds', () {
      final r = RectangleElement(
        id: 'r',
        x: 10,
        y: 20,
        width: 50,
        height: 40,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      final e = EllipseElement(
        id: 'e',
        x: -5,
        y: 15,
        width: 10,
        height: 5,
        strokeColor: Colors.black,
        updatedAt: now,
      );

      expect(service.calculateGroupBounds([r, e]), const Rect.fromLTRB(-5, 15, 60, 60));
    });

    test('isElementInSelection checks overlap', () {
      final element = RectangleElement(
        id: 'r',
        x: 10,
        y: 10,
        width: 20,
        height: 20,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      expect(service.isElementInSelection(const Rect.fromLTWH(0, 0, 12, 12), element), isTrue);
      expect(service.isElementInSelection(const Rect.fromLTWH(40, 40, 10, 10), element), isFalse);
    });
  });

  group('GeometryService.containsPoint', () {
    test('handles rectangle hit-test with rotation', () {
      final rect = RectangleElement(
        id: 'r',
        x: 0,
        y: 0,
        width: 100,
        height: 40,
        angle: math.pi / 4,
        strokeColor: Colors.black,
        updatedAt: now,
      );

      expect(GeometryService.containsPoint(rect, rect.bounds.center), isTrue);
      expect(GeometryService.containsPoint(rect, const Offset(-20, -20)), isFalse);
    });

    test('line hit-test detects near path and rejects far point', () {
      final line = LineElement(
        id: 'l',
        x: 10,
        y: 10,
        width: 100,
        height: 0,
        strokeColor: Colors.black,
        updatedAt: now,
        points: const [Offset(0, 0), Offset(100, 0)],
      );

      expect(GeometryService.containsPoint(line, const Offset(50, 16)), isTrue);
      expect(GeometryService.containsPoint(line, const Offset(50, 30)), isFalse);
    });

    test('triangle hit-test distinguishes inside from outside', () {
      final triangle = TriangleElement(
        id: 't',
        x: 0,
        y: 0,
        width: 40,
        height: 40,
        strokeColor: Colors.black,
        updatedAt: now,
      );

      expect(GeometryService.containsPoint(triangle, const Offset(20, 20)), isTrue);
      expect(GeometryService.containsPoint(triangle, const Offset(2, 2)), isFalse);
    });
  });
}
