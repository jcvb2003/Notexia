import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element_mapper.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

void main() {
  group('CanvasElementMapper Serialization Round-Trip (All Types)', () {
    final now = DateTime.now();

    test('RectangleElement round-trip', () {
      final element = CanvasElement.rectangle(
        id: 'rect-1',
        x: 10,
        y: 20,
        width: 100,
        height: 50,
        angle: 1.5,
        strokeColor: const Color(0xFFFF0000),
        fillColor: const Color(0xFF00FF00),
        strokeWidth: 2.5,
        strokeStyle: StrokeStyle.dashed,
        fillType: FillType.hachure,
        opacity: 0.5,
        roughness: 2.0,
        zIndex: 10,
        isDeleted: false,
        version: 2,
        versionNonce: 12345,
        updatedAt: now,
      );

      final map = CanvasElementMapper.toMap(element, useIntColors: true);
      final result = CanvasElementMapper.fromMap(map) as RectangleElement;

      expect(result.id, element.id);
      expect(result.type, CanvasElementType.rectangle);
      expect(result.x, element.x);
      expect(result.y, element.y);
      expect(result.width, element.width);
      expect(result.height, element.height);
      expect(result.angle, element.angle);
      expect(result.strokeColor.toARGB32(), element.strokeColor.toARGB32());
      expect(result.fillColor?.toARGB32(), element.fillColor?.toARGB32());
      expect(result.strokeWidth, element.strokeWidth);
      expect(result.strokeStyle, element.strokeStyle);
      expect(result.fillType, element.fillType);
      expect(result.opacity, element.opacity);
      expect(result.roughness, element.roughness);
      expect(result.zIndex, element.zIndex);
      expect(result.isDeleted, element.isDeleted);
      expect(result.version, element.version);
      expect(result.versionNonce, element.versionNonce);
      expect(
        result.updatedAt.toIso8601String(),
        element.updatedAt.toIso8601String(),
      );
    });

    test('EllipseElement round-trip', () {
      final element = CanvasElement.ellipse(
        id: 'ellipse-1',
        x: 50,
        y: 50,
        width: 80,
        height: 80,
        strokeColor: Colors.blue,
        updatedAt: now,
      );

      final map = CanvasElementMapper.toMap(element, useIntColors: true);
      final result = CanvasElementMapper.fromMap(map) as EllipseElement;

      expect(result.id, element.id);
      expect(result.type, CanvasElementType.ellipse);
      expect(result.width, 80);
    });

    test('DiamondElement round-trip', () {
      final element = CanvasElement.diamond(
        id: 'diamond-1',
        x: 100,
        y: 100,
        width: 60,
        height: 60,
        strokeColor: Colors.yellow,
        updatedAt: now,
      );

      final map = CanvasElementMapper.toMap(element, useIntColors: true);
      final result = CanvasElementMapper.fromMap(map) as DiamondElement;

      expect(result.id, element.id);
      expect(result.type, CanvasElementType.diamond);
    });

    test('TriangleElement round-trip', () {
      final element = CanvasElement.triangle(
        id: 'triangle-1',
        x: 30,
        y: 40,
        width: 90,
        height: 70,
        strokeColor: Colors.orange,
        updatedAt: now,
      );

      final map = CanvasElementMapper.toMap(element, useIntColors: true);
      final result = CanvasElementMapper.fromMap(map) as TriangleElement;

      expect(result.id, element.id);
      expect(result.type, CanvasElementType.triangle);
      expect(result.width, 90);
      expect(result.height, 70);
    });

    test('LineElement round-trip', () {
      final element = CanvasElement.line(
        id: 'line-1',
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        strokeColor: Colors.black,
        updatedAt: now,
        points: const [Offset(0, 0), Offset(50, 50), Offset(100, 100)],
      );

      final map = CanvasElementMapper.toMap(element, useIntColors: true);
      final result = CanvasElementMapper.fromMap(map) as LineElement;

      expect(result.id, element.id);
      expect(result.type, CanvasElementType.line);
      expect(result.points.length, 3);
      expect(result.points[1], const Offset(50, 50));
    });

    test('ArrowElement round-trip', () {
      final element = CanvasElement.arrow(
        id: 'arrow-1',
        x: 10,
        y: 10,
        width: 200,
        height: 50,
        strokeColor: Colors.purple,
        updatedAt: now,
        points: const [Offset(0, 0), Offset(200, 50)],
      );

      final map = CanvasElementMapper.toMap(element, useIntColors: true);
      final result = CanvasElementMapper.fromMap(map) as ArrowElement;

      expect(result.id, element.id);
      expect(result.type, CanvasElementType.arrow);
      expect(result.points.length, 2);
    });

    test('FreeDrawElement round-trip', () {
      final element = CanvasElement.freeDraw(
        id: 'freedraw-1',
        x: 0,
        y: 0,
        width: 500,
        height: 500,
        strokeColor: Colors.grey,
        updatedAt: now,
        points: const [Offset(10, 10), Offset(12, 12), Offset(15, 15)],
      );

      final map = CanvasElementMapper.toMap(element, useIntColors: true);
      final result = CanvasElementMapper.fromMap(map) as FreeDrawElement;

      expect(result.id, element.id);
      expect(result.type, CanvasElementType.freeDraw);
      expect(result.points.length, 3);
    });

    test('TextElement round-trip', () {
      final element = CanvasElement.text(
        id: 'text-1',
        x: 50,
        y: 50,
        width: 100,
        height: 20,
        strokeColor: Colors.black,
        updatedAt: now,
        text: 'Notexia',
        fontFamily: 'Cascadia',
        fontSize: 18.0,
        textAlign: TextAlign.center,
      );

      final map = CanvasElementMapper.toMap(element, useIntColors: true);
      final result = CanvasElementMapper.fromMap(map) as TextElement;

      expect(result.id, element.id);
      expect(result.type, CanvasElementType.text);
      expect(result.text, 'Notexia');
      expect(result.fontFamily, 'Cascadia');
      expect(result.fontSize, 18.0);
      expect(result.textAlign, TextAlign.center);
    });
  });
}
