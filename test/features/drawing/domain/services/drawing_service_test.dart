import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';
import 'package:notexia/src/features/drawing/domain/services/canvas_manipulation_service.dart';
import 'package:notexia/src/features/drawing/domain/services/drawing_service.dart';

class MockCanvasManipulationService extends Mock
    implements CanvasManipulationService {}

void main() {
  late MockCanvasManipulationService manipulation;
  late DrawingService service;
  final now = DateTime(2026, 1, 1);

  setUpAll(() {
    registerFallbackValue(
      RectangleElement(
        id: 'fallback',
        x: 0,
        y: 0,
        width: 1,
        height: 1,
        strokeColor: Colors.black,
        updatedAt: DateTime(2026, 1, 1),
      ),
    );
    registerFallbackValue(const Offset(0, 0));
  });

  setUp(() {
    manipulation = MockCanvasManipulationService();
    service = DrawingService(canvasManipulationService: manipulation);
  });

  group('DrawingService.startDrawing', () {
    test('creates drawable element with style from current tool', () {
      final style = const ElementStyle(
        strokeColor: Colors.orange,
        fillColor: Colors.amber,
        strokeWidth: 4,
        strokeStyle: StrokeStyle.dashed,
        fillType: FillType.solid,
        opacity: 0.7,
        roughness: 0.9,
      );

      final created = service.startDrawing(
        type: CanvasElementType.ellipse,
        position: const Offset(10, 20),
        style: style,
      ) as EllipseElement;

      expect(created.id, isNotEmpty);
      expect(created.x, 10);
      expect(created.y, 20);
      expect(created.strokeColor, Colors.orange);
      expect(created.fillColor, Colors.amber);
      expect(created.strokeWidth, 4);
      expect(created.strokeStyle, StrokeStyle.dashed);
      expect(created.fillType, FillType.solid);
      expect(created.opacity, 0.7);
      expect(created.roughness, 0.9);
    });

    test('returns null when selected tool is not creatable', () {
      final created = service.startDrawing(
        type: CanvasElementType.selection,
        position: const Offset(1, 1),
        style: const ElementStyle(),
      );

      expect(created, isNull);
    });
  });

  group('DrawingService.updateDrawingElement', () {
    test('delegates update with drawing flags to manipulation service', () {
      final element = RectangleElement(
        id: 'r1',
        x: 0,
        y: 0,
        width: 0,
        height: 0,
        strokeColor: Colors.black,
        updatedAt: now,
      );
      final updated = element.copyWith(x: 5, y: 6);

      when(
        () => manipulation.updateDrawingElement(
          element,
          const Offset(20, 30),
          startPosition: const Offset(10, 10),
          keepAspect: true,
          snapAngle: true,
          createFromCenter: true,
          snapAngleStep: 0.5,
        ),
      ).thenReturn(updated);

      final result = service.updateDrawingElement(
        element: element,
        currentPosition: const Offset(20, 30),
        startPosition: const Offset(10, 10),
        keepAspect: true,
        snapAngle: true,
        createFromCenter: true,
        snapAngleStep: 0.5,
      );

      expect(result, same(updated));
      verify(
        () => manipulation.updateDrawingElement(
          element,
          const Offset(20, 30),
          startPosition: const Offset(10, 10),
          keepAspect: true,
          snapAngle: true,
          createFromCenter: true,
          snapAngleStep: 0.5,
        ),
      ).called(1);
    });
  });
}
