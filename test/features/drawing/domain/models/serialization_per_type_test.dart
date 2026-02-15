import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element_mapper.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/rectangle_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/ellipse_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/diamond_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/triangle_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/line_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/arrow_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/free_draw_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/text_element.dart';

/// Testa a serialização/deserialização roundtrip para todos os tipos de elemento.
///
/// Para cada tipo: cria o elemento → `toMap()` → `fromMap()` → verifica campos.
void main() {
  final now = DateTime(2026, 1, 1);

  group('Serialization Roundtrip', () {
    test('RectangleElement', () {
      final original = RectangleElement(
        id: 'rect-1',
        x: 10,
        y: 20,
        width: 100,
        height: 50,
        angle: 0.5,
        strokeColor: Colors.red,
        fillColor: Colors.blue,
        strokeWidth: 3.0,
        strokeStyle: StrokeStyle.dashed,
        fillType: FillType.solid,
        opacity: 0.8,
        roughness: 1.5,
        updatedAt: now,
      );
      _assertRoundtrip(original);
    });

    test('EllipseElement', () {
      final original = EllipseElement(
        id: 'ellipse-1',
        x: 5,
        y: 15,
        width: 80,
        height: 80,
        strokeColor: Colors.green,
        updatedAt: now,
      );
      _assertRoundtrip(original);
    });

    test('DiamondElement', () {
      final original = DiamondElement(
        id: 'diamond-1',
        x: 30,
        y: 40,
        width: 60,
        height: 60,
        strokeColor: Colors.orange,
        fillColor: Colors.yellow,
        fillType: FillType.hachure,
        updatedAt: now,
      );
      _assertRoundtrip(original);
    });

    test('TriangleElement', () {
      final original = TriangleElement(
        id: 'tri-1',
        x: 0,
        y: 0,
        width: 120,
        height: 100,
        strokeColor: Colors.purple,
        updatedAt: now,
      );
      _assertRoundtrip(original);
    });

    test('LineElement', () {
      final original = LineElement(
        id: 'line-1',
        x: 0,
        y: 0,
        width: 200,
        height: 150,
        strokeColor: Colors.black,
        points: const [Offset(0, 0), Offset(200, 150)],
        updatedAt: now,
      );
      final restored = _roundtrip(original);
      _assertCommonFields(original, restored);
      expect(restored, isA<LineElement>());
      expect(
        (restored as LineElement).points.length,
        original.points.length,
      );
    });

    test('ArrowElement', () {
      final original = ArrowElement(
        id: 'arrow-1',
        x: 10,
        y: 10,
        width: 100,
        height: 80,
        strokeColor: Colors.teal,
        points: const [Offset(10, 10), Offset(110, 90)],
        updatedAt: now,
      );
      final restored = _roundtrip(original);
      _assertCommonFields(original, restored);
      expect(restored, isA<ArrowElement>());
      expect(
        (restored as ArrowElement).points.length,
        original.points.length,
      );
    });

    test('FreeDrawElement', () {
      final original = FreeDrawElement(
        id: 'free-1',
        x: 0,
        y: 0,
        width: 300,
        height: 200,
        strokeColor: Colors.brown,
        points: const [
          Offset(0, 0),
          Offset(10, 15),
          Offset(20, 10),
          Offset(30, 25)
        ],
        updatedAt: now,
      );
      final restored = _roundtrip(original);
      _assertCommonFields(original, restored);
      expect(restored, isA<FreeDrawElement>());
      expect(
        (restored as FreeDrawElement).points.length,
        original.points.length,
      );
    });

    test('TextElement', () {
      final original = TextElement(
        id: 'text-1',
        x: 50,
        y: 50,
        width: 200,
        height: 30,
        strokeColor: Colors.black,
        text: 'Olá Mundo',
        fontFamily: 'Roboto',
        fontSize: 16.0,
        textAlign: TextAlign.center,
        isBold: true,
        isItalic: false,
        updatedAt: now,
      );
      final restored = _roundtrip(original);
      _assertCommonFields(original, restored);
      expect(restored, isA<TextElement>());
      final restoredText = restored as TextElement;
      expect(restoredText.text, original.text);
      expect(restoredText.fontFamily, original.fontFamily);
      expect(restoredText.fontSize, original.fontSize);
      expect(restoredText.textAlign, original.textAlign);
      expect(restoredText.isBold, original.isBold);
      expect(restoredText.isItalic, original.isItalic);
    });
  });

  group('Serialization edge cases', () {
    test('toMap with useIntColors=true converts colors to ARGB32', () {
      final el = RectangleElement(
        id: 'r1',
        x: 0,
        y: 0,
        width: 10,
        height: 10,
        strokeColor: Colors.red,
        updatedAt: now,
      );
      final map = CanvasElementMapper.toMap(el, useIntColors: true);
      expect(map['strokeColor'], isA<int>());
    });

    test('toMap with useIntBools=true converts booleans to 0/1', () {
      final el = TextElement(
        id: 't1',
        x: 0,
        y: 0,
        width: 10,
        height: 10,
        strokeColor: Colors.black,
        text: 'test',
        isBold: true,
        isItalic: false,
        updatedAt: now,
      );
      final map = CanvasElementMapper.toMap(el, useIntBools: true);
      expect(map['isBold'], 1);
      expect(map['isItalic'], 0);
      expect(map['isDeleted'], 0);
    });

    test('fromMap falls back to rectangle for unknown type', () {
      final map = {
        'id': 'unknown-1',
        'type': 'nonexistent_type',
        'x': 0.0,
        'y': 0.0,
        'width': 10.0,
        'height': 10.0,
        'strokeColor': '#FF000000',
        'updatedAt': now.toIso8601String(),
      };
      // The type enum fallback returns rectangle
      final element = CanvasElementMapper.fromMap(map);
      expect(element, isA<RectangleElement>());
    });
  });
}

CanvasElement _roundtrip(CanvasElement original) {
  final map = CanvasElementMapper.toMap(original);
  return CanvasElementMapper.fromMap(map);
}

void _assertRoundtrip(CanvasElement original) {
  final restored = _roundtrip(original);
  _assertCommonFields(original, restored);
  expect(restored.runtimeType, original.runtimeType);
}

void _assertCommonFields(CanvasElement original, CanvasElement restored) {
  expect(restored.id, original.id);
  expect(restored.type, original.type);
  expect(restored.x, original.x);
  expect(restored.y, original.y);
  expect(restored.width, original.width);
  expect(restored.height, original.height);
  expect(restored.strokeWidth, original.strokeWidth);
  expect(restored.strokeStyle, original.strokeStyle);
  expect(restored.fillType, original.fillType);
  expect(restored.opacity, original.opacity);
  expect(restored.roughness, original.roughness);
}
