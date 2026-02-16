import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/core/utils/extensions/color_extensions.dart';
import 'package:notexia/src/features/drawing/domain/factories/element_factory.dart';
import 'package:notexia/src/features/drawing/domain/factories/element_factory_provider.dart';

class CanvasElementMapper {
  static CanvasElement fromMap(Map<String, dynamic> map) {
    final typeName = map['type'] as String;
    final type = CanvasElementType.values.firstWhere(
      (e) => e.name == typeName,
      orElse: () => CanvasElementType.rectangle,
    );

    // Campos comuns
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

    final commonData = CanvasElementCommonData(
      id: id,
      type: type,
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

    try {
      final factory = ElementFactoryProvider.getFactory(type);
      return factory.create(commonData, map);
    } catch (e) {
      // Fallback para tipos nÃ£o suportados ou erros de factory
      // Retorna um retÃ¢ngulo como fallback seguro, ou relanÃ§a erro dependendo da polÃ­tica
      // Neste caso, vamos relanÃ§ar se for um erro de factory nÃ£o encontrada
      rethrow;
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
      'strokeColor': element.strokeColor.toHex(),
      'fillColor': element.fillColor?.toHex(),
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
        'backgroundColor': element.backgroundColor?.toHex(),
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

    if (useIntColors) {
      // Converte cores de Hex string de volta para int
      if (map['strokeColor'] is String) {
        map['strokeColor'] = hexToColor(map['strokeColor']).toARGB32();
      }
      if (map['fillColor'] is String) {
        map['fillColor'] = hexToColor(map['fillColor']).toARGB32();
      }
      if (map['backgroundColor'] is String) {
        map['backgroundColor'] = hexToColor(map['backgroundColor']).toARGB32();
      }
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
        if (map[field] is bool) {
          map[field] = (map[field] as bool) ? 1 : 0;
        }
      }
    }

    return map;
  }

  static Color _parseColor(dynamic value) {
    if (value is int) {
      return Color(value);
    } else if (value is String) {
      return hexToColor(value);
    }
    return Colors.black; // Fallback seguro
  }
}
