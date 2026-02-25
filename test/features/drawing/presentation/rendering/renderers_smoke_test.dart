import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/renderer_provider.dart';

class MockCanvas extends Mock implements Canvas {}

/// Smoke tests para garantir que os renderers não crasham ao desenhar diferentes estilos.
void main() {
  late MockCanvas mockCanvas;
  final now = DateTime.now();

  setUp(() {
    mockCanvas = MockCanvas();
  });

  group('Renderer Smoke Tests', () {
    test('RectangleRenderer smoke test (all styles)', () {
      final rect = RectangleElement(
        id: 'r1',
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        strokeColor: const Color(0xFF000000),
        strokeStyle: StrokeStyle.dashed,
        fillType: FillType.hachure,
        fillColor: const Color(0xFFFF0000),
        updatedAt: now,
      );

      final renderer = RendererProvider.getRenderer(rect);
      expect(() => renderer.render(mockCanvas, rect), returnsNormally);
    });

    test('EllipseRenderer smoke test', () {
      final el = EllipseElement(
        id: 'e1',
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        strokeColor: const Color(0xFF000000),
        updatedAt: now,
      );
      final renderer = RendererProvider.getRenderer(el);
      expect(() => renderer.render(mockCanvas, el), returnsNormally);
    });

    test('DiamondRenderer smoke test', () {
      final el = DiamondElement(
        id: 'd1',
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        strokeColor: const Color(0xFF000000),
        updatedAt: now,
      );
      final renderer = RendererProvider.getRenderer(el);
      expect(() => renderer.render(mockCanvas, el), returnsNormally);
    });

    test('TriangleRenderer smoke test', () {
      final el = TriangleElement(
        id: 't1',
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        strokeColor: const Color(0xFF000000),
        updatedAt: now,
      );
      final renderer = RendererProvider.getRenderer(el);
      expect(() => renderer.render(mockCanvas, el), returnsNormally);
    });

    test('LineRenderer smoke test', () {
      final el = LineElement(
        id: 'l1',
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        strokeColor: const Color(0xFF000000),
        points: const [Offset(0, 0), Offset(100, 100)],
        updatedAt: now,
      );
      final renderer = RendererProvider.getRenderer(el);
      expect(() => renderer.render(mockCanvas, el), returnsNormally);
    });

    test('ArrowRenderer smoke test', () {
      final el = ArrowElement(
        id: 'a1',
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        strokeColor: const Color(0xFF000000),
        points: const [Offset(0, 0), Offset(100, 100)],
        updatedAt: now,
      );
      final renderer = RendererProvider.getRenderer(el);
      expect(() => renderer.render(mockCanvas, el), returnsNormally);
    });

    test('FreeDrawRenderer smoke test', () {
      final el = FreeDrawElement(
        id: 'f1',
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        strokeColor: const Color(0xFF000000),
        points: const [Offset(0, 0), Offset(10, 10), Offset(20, 5)],
        updatedAt: now,
      );
      final renderer = RendererProvider.getRenderer(el);
      expect(() => renderer.render(mockCanvas, el), returnsNormally);
    });

    test('TextRenderer smoke test', () {
      final el = TextElement(
        id: 'txt1',
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        strokeColor: const Color(0xFF000000),
        text: 'Smoke Test',
        updatedAt: now,
      );
      final renderer = RendererProvider.getRenderer(el);
      expect(() => renderer.render(mockCanvas, el), returnsNormally);
    });
  });
}
