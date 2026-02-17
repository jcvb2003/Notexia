import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';

class CanvasElementMapper {
  static CanvasElement fromMap(Map<String, dynamic> map) {
    // 1. Identificar tipo
    final typeName = map['type'] as String;
    final type = CanvasElementType.values.firstWhere(
      (e) => e.name == typeName,
      orElse: () => CanvasElementType.rectangle,
    );

    // 2. Extrair dados comuns
    final id = map['id'] as String;
    final x = (map['x'] as num).toDouble();
    final y = (map['y'] as num).toDouble();
    final width = (map['width'] as num).toDouble();
    final height = (map['height'] as num).toDouble();
    final angle = (map['angle'] as num?)?.toDouble() ?? 0.0;
    final strokeColor = _parseColor(map['strokeColor']);
    final fillColor =
        map['fillColor'] != null ? _parseColor(map['fillColor']) : null;
    final strokeWidth = (map['strokeWidth'] as num?)?.toDouble() ?? 2.0;
    final strokeStyle = StrokeStyle.values.firstWhere(
      (e) => e.name == (map['strokeStyle'] as String? ?? 'solid'),
      orElse: () => StrokeStyle.solid,
    );
    final fillType = FillType.values.firstWhere(
      (e) => e.name == (map['fillType'] as String? ?? 'transparent'),
      orElse: () => FillType.transparent,
    );
    final opacity = (map['opacity'] as num?)?.toDouble() ?? 1.0;
    final roughness = (map['roughness'] as num?)?.toDouble() ?? 1.0;
    final zIndex = map['zIndex'] as int? ?? 0;

    // Suporte a bool (JSON) ou int (SQLite) para isDeleted
    final isDeletedVal = map['isDeleted'];
    final isDeleted = isDeletedVal is int
        ? isDeletedVal == 1
        : (isDeletedVal as bool? ?? false);

    final version = map['version'] as int? ?? 1;
    final versionNonce = map['versionNonce'] as int? ?? 0;
    final updatedAt = map['updatedAt'] != null
        ? DateTime.parse(map['updatedAt'] as String)
        : DateTime.now();

    // 3. Instanciar elemento específico baseado no tipo
    switch (type) {
      case CanvasElementType.rectangle:
        return RectangleElement(
          id: id,
          x: x,
          y: y,
          width: width,
          height: height,
          angle: angle,
          strokeColor: strokeColor,
          fillColor: fillColor,
          strokeWidth: strokeWidth,
          strokeStyle: strokeStyle,
          fillType: fillType,
          opacity: opacity,
          roughness: roughness,
          zIndex: zIndex,
          isDeleted: isDeleted,
          version: version,
          versionNonce: versionNonce,
          updatedAt: updatedAt,
        );
      case CanvasElementType.diamond:
        return DiamondElement(
          id: id,
          x: x,
          y: y,
          width: width,
          height: height,
          angle: angle,
          strokeColor: strokeColor,
          fillColor: fillColor,
          strokeWidth: strokeWidth,
          strokeStyle: strokeStyle,
          fillType: fillType,
          opacity: opacity,
          roughness: roughness,
          zIndex: zIndex,
          isDeleted: isDeleted,
          version: version,
          versionNonce: versionNonce,
          updatedAt: updatedAt,
        );
      case CanvasElementType.ellipse:
        return EllipseElement(
          id: id,
          x: x,
          y: y,
          width: width,
          height: height,
          angle: angle,
          strokeColor: strokeColor,
          fillColor: fillColor,
          strokeWidth: strokeWidth,
          strokeStyle: strokeStyle,
          fillType: fillType,
          opacity: opacity,
          roughness: roughness,
          zIndex: zIndex,
          isDeleted: isDeleted,
          version: version,
          versionNonce: versionNonce,
          updatedAt: updatedAt,
        );
      case CanvasElementType.triangle:
        return TriangleElement(
          id: id,
          x: x,
          y: y,
          width: width,
          height: height,
          angle: angle,
          strokeColor: strokeColor,
          fillColor: fillColor,
          strokeWidth: strokeWidth,
          strokeStyle: strokeStyle,
          fillType: fillType,
          opacity: opacity,
          roughness: roughness,
          zIndex: zIndex,
          isDeleted: isDeleted,
          version: version,
          versionNonce: versionNonce,
          updatedAt: updatedAt,
        );
      case CanvasElementType.line:
        final pointsList = (map['points'] as List?) ?? [];
        final points = pointsList
            .map((p) =>
                Offset((p['x'] as num).toDouble(), (p['y'] as num).toDouble()))
            .toList();
        return LineElement(
          id: id,
          x: x,
          y: y,
          width: width,
          height: height,
          angle: angle,
          strokeColor: strokeColor,
          fillColor: fillColor,
          strokeWidth: strokeWidth,
          strokeStyle: strokeStyle,
          fillType: fillType,
          opacity: opacity,
          roughness: roughness,
          zIndex: zIndex,
          isDeleted: isDeleted,
          version: version,
          versionNonce: versionNonce,
          updatedAt: updatedAt,
          points: points,
        );
      case CanvasElementType.arrow:
        final pointsList = (map['points'] as List?) ?? [];
        final points = pointsList
            .map((p) =>
                Offset((p['x'] as num).toDouble(), (p['y'] as num).toDouble()))
            .toList();
        return ArrowElement(
          id: id,
          x: x,
          y: y,
          width: width,
          height: height,
          angle: angle,
          strokeColor: strokeColor,
          fillColor: fillColor,
          strokeWidth: strokeWidth,
          strokeStyle: strokeStyle,
          fillType: fillType,
          opacity: opacity,
          roughness: roughness,
          zIndex: zIndex,
          isDeleted: isDeleted,
          version: version,
          versionNonce: versionNonce,
          updatedAt: updatedAt,
          points: points,
        );
      case CanvasElementType.freeDraw:
        final pointsList = (map['points'] as List?) ?? [];
        final points = pointsList
            .map((p) =>
                Offset((p['x'] as num).toDouble(), (p['y'] as num).toDouble()))
            .toList();
        return FreeDrawElement(
          id: id,
          x: x,
          y: y,
          width: width,
          height: height,
          angle: angle,
          strokeColor: strokeColor,
          fillColor: fillColor,
          strokeWidth: strokeWidth,
          strokeStyle: strokeStyle,
          fillType: fillType,
          opacity: opacity,
          roughness: roughness,
          zIndex: zIndex,
          isDeleted: isDeleted,
          version: version,
          versionNonce: versionNonce,
          updatedAt: updatedAt,
          points: points,
        );
      case CanvasElementType.text:
        return TextElement(
          id: id,
          x: x,
          y: y,
          width: width,
          height: height,
          angle: angle,
          strokeColor: strokeColor,
          fillColor: fillColor,
          strokeWidth: strokeWidth,
          strokeStyle: strokeStyle,
          fillType: fillType,
          opacity: opacity,
          roughness: roughness,
          zIndex: zIndex,
          isDeleted: isDeleted,
          version: version,
          versionNonce: versionNonce,
          updatedAt: updatedAt,
          text: map['text'] as String? ?? '',
          fontFamily: map['fontFamily'] as String? ?? 'Virgil',
          fontSize: (map['fontSize'] as num?)?.toDouble() ?? 20.0,
          textAlign: TextAlign.values.firstWhere(
            (e) => e.name == (map['textAlign'] as String? ?? 'left'),
            orElse: () => TextAlign.left,
          ),
          backgroundColor: map['backgroundColor'] != null
              ? _parseColor(map['backgroundColor'])
              : null,
          backgroundRadius:
              (map['backgroundRadius'] as num?)?.toDouble() ?? 4.0,
          isBold: map['isBold'] is int
              ? map['isBold'] == 1
              : (map['isBold'] as bool? ?? false),
          isItalic: map['isItalic'] is int
              ? map['isItalic'] == 1
              : (map['isItalic'] as bool? ?? false),
          isUnderlined: map['isUnderlined'] is int
              ? map['isUnderlined'] == 1
              : (map['isUnderlined'] as bool? ?? false),
          isStrikethrough: map['isStrikethrough'] is int
              ? map['isStrikethrough'] == 1
              : (map['isStrikethrough'] as bool? ?? false),
        );
      default:
        // Caso de tipo desconhecido, retorna retângulo seguro ou lança erro
        // Neste caso, retornamos um retÃ¢ngulo vazio para não crashear
        return RectangleElement(
          id: id,
          x: x,
          y: y,
          width: width,
          height: height,
          angle: angle,
          strokeColor: strokeColor,
          updatedAt: updatedAt,
          zIndex: zIndex,
        );
    }
  }

  static Map<String, dynamic> toMap(
    CanvasElement element, {
    bool useIntColors = false,
    bool useIntBools = false,
  }) {
    final map = <String, dynamic>{
      'id': element.id,
      'type': element.type.name,
      'x': element.x,
      'y': element.y,
      'width': element.width,
      'height': element.height,
      'angle': element.angle,
      'strokeColor': _colorToHexOrInt(element.strokeColor, useIntColors),
      'fillColor': element.fillColor != null
          ? _colorToHexOrInt(element.fillColor!, useIntColors)
          : null,
      'strokeWidth': element.strokeWidth,
      'strokeStyle': element.strokeStyle.name,
      'fillType': element.fillType.name,
      'opacity': element.opacity,
      'roughness': element.roughness,
      'zIndex': element.zIndex,
      'isDeleted': element.isDeleted,
      'version': element.version,
      'versionNonce': element.versionNonce,
      'updatedAt': element.updatedAt.toIso8601String(),
    };

    if (element is TextElement) {
      map.addAll({
        'text': element.text,
        'fontFamily': element.fontFamily,
        'fontSize': element.fontSize,
        'textAlign': element.textAlign.name,
        'backgroundColor': element.backgroundColor != null
            ? _colorToHexOrInt(element.backgroundColor!, useIntColors)
            : null,
        'backgroundRadius': element.backgroundRadius,
        'isBold': element.isBold,
        'isItalic': element.isItalic,
        'isUnderlined': element.isUnderlined,
        'isStrikethrough': element.isStrikethrough,
      });
    } else if (element is LineElement) {
      map['points'] =
          element.points.map((p) => {'x': p.dx, 'y': p.dy}).toList();
    } else if (element is ArrowElement) {
      map['points'] =
          element.points.map((p) => {'x': p.dx, 'y': p.dy}).toList();
    } else if (element is FreeDrawElement) {
      map['points'] =
          element.points.map((p) => {'x': p.dx, 'y': p.dy}).toList();
    }

    if (useIntBools) {
      // Converte campos booleanos para int (0/1) para SQLite
      final boolFields = [
        'isDeleted',
        'isBold',
        'isItalic',
        'isUnderlined',
        'isStrikethrough',
      ];

      for (var field in boolFields) {
        if (map.containsKey(field) && map[field] is bool) {
          map[field] = (map[field] as bool) ? 1 : 0;
        }
      }
    }

    return map;
  }

  static dynamic _colorToHexOrInt(Color color, bool asInt) {
    if (asInt) {
      return color.toARGB32();
    }
    return color.toHex();
  }

  static Color _parseColor(dynamic value) {
    if (value is int) {
      return Color(value);
    } else if (value is String) {
      return HexColorExtension.fromHex(value);
    }
    return Colors.black; // Fallback seguro
  }
}

// Pequena extensão local helper se a global não estiver disponível ou para garantir
extension HexColorExtension on Color {
  String toHex() {
    return '#${toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
