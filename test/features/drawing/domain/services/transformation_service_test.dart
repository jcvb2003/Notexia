import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

void main() {
  group('TransformationService.resizeAndPlace', () {
    test('atualiza x/y/width/height e incrementa version', () {
      final now = DateTime.now();
      final rect = CanvasElement.rectangle(
        id: 'r1',
        x: 10,
        y: 20,
        width: 30,
        height: 40,
        strokeColor: const Color(0xff000000),
        updatedAt: now,
        version: 1,
      );
      final t = TransformationService();
      final next = t.resizeAndPlace(rect, const Rect.fromLTWH(0, 0, 100, 50));
      expect(next.x, 0);
      expect(next.y, 0);
      expect(next.width, 100);
      expect(next.height, 50);
      expect(next.version, 2);
      expect(
        next.updatedAt.isAfter(now) || next.updatedAt.isAtSameMomentAs(now),
        isTrue,
      );
    });
  });

  group('TransformationService.updateLineOrArrowEndpoint', () {
    test(
      'line com snapAngle true: vetor final é ajustado ao passo (pi/12)',
      () {
        final now = DateTime.now();
        final line = CanvasElement.line(
          id: 'l1',
          x: 10,
          y: 20,
          width: 100,
          height: 0,
          strokeColor: const Color(0xff000000),
          updatedAt: now,
          version: 1,
          points: const [Offset(0, 0), Offset(100, 0)],
        );
        final t = TransformationService();
        const worldPoint = Offset(80, 80); // força ~45°
        final next = t.updateLineOrArrowEndpoint(
          element: line,
          isStart: false,
          worldPoint: worldPoint,
          snapAngle: true,
        ) as LineElement;

        expect(next.version, 2);
        expect(next.points.length, 2);
        final p0 = next.points[0];
        final p1 = next.points[1];
        // vetor normalizado deve estar próximo de 45° (dx ≈ dy)
        expect((p1.dx - p0.dx).abs(), closeTo((p1.dy - p0.dy).abs(), 0.75));
      },
    );
    test('line com passo customizado (pi/6) ajusta ângulo para ~30°', () {
      final now = DateTime.now();
      final line = CanvasElement.line(
        id: 'l2',
        x: 0,
        y: 0,
        width: 0,
        height: 0,
        strokeColor: const Color(0xff000000),
        updatedAt: now,
        version: 1,
        points: const [Offset(0, 0), Offset(10, 0)],
      );
      final t = TransformationService();
      final next = t.updateLineOrArrowEndpoint(
        element: line,
        isStart: false,
        worldPoint: const Offset(100, 60),
        snapAngle: true,
        angleStep: math.pi / 6,
      ) as LineElement;
      final p0 = next.points[0];
      final p1 = next.points[1];
      final angle = math.atan2(p1.dy - p0.dy, p1.dx - p0.dx);
      expect(angle, closeTo(math.pi / 6, 0.02));
    });

    test(
      'arrow sem snapAngle: atualiza endpoints e normaliza bounding box',
      () {
        final now = DateTime.now();
        final arr = CanvasElement.arrow(
          id: 'a1',
          x: 10,
          y: 20,
          width: 100,
          height: 0,
          strokeColor: const Color(0xff000000),
          updatedAt: now,
          version: 3,
          points: const [Offset(0, 0), Offset(100, 0)],
        );
        final t = TransformationService();
        const worldPoint = Offset(40, 60);
        final next = t.updateLineOrArrowEndpoint(
          element: arr,
          isStart: true, // move o início
          worldPoint: worldPoint,
          snapAngle: false,
        ) as ArrowElement;

        expect(next.version, 4);
        expect(next.points.length, 2);
        final p0 = next.points[0];
        final p1 = next.points[1];
        const finalStart = worldPoint;
        const finalEnd = Offset(110, 20); // antigo endAbs
        final minX = math.min(finalStart.dx, finalEnd.dx);
        final minY = math.min(finalStart.dy, finalEnd.dy);
        // Pontos normalizados: cada ponto deve ser relativo ao minX/minY
        expect(p0.dx, closeTo(finalStart.dx - minX, 0.01));
        expect(p0.dy, closeTo(finalStart.dy - minY, 0.01));
        expect(p1.dx, closeTo(finalEnd.dx - minX, 0.01));
        expect(p1.dy, closeTo(finalEnd.dy - minY, 0.01));
        // Confirma x/y como min dos endpoints
        expect(next.x, closeTo(minX, 0.01));
        expect(next.y, closeTo(minY, 0.01));
      },
    );
  });
}
