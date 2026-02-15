import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/text_element.dart';

import 'package:notexia/src/features/drawing/domain/factories/element_factory.dart';
import 'package:notexia/src/core/utils/extensions/color_extensions.dart';

class TextFactory implements ElementFactory<TextElement> {
  @override
  TextElement create(CanvasElementCommonData common, Map<String, dynamic> map) {
    return TextElement(
      id: common.id,
      x: common.x,
      y: common.y,
      width: common.width,
      height: common.height,
      angle: common.angle,
      strokeColor: common.strokeColor,
      fillColor: common.fillColor,
      strokeWidth: common.strokeWidth,
      strokeStyle: common.strokeStyle,
      fillType: common.fillType,
      opacity: common.opacity,
      roughness: common.roughness,
      zIndex: common.zIndex,
      isDeleted: common.isDeleted,
      version: common.version,
      versionNonce: common.versionNonce,
      updatedAt: common.updatedAt,
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
      backgroundRadius: (map['backgroundRadius'] as num?)?.toDouble() ?? 4.0,
      isBold: _parseBool(map['isBold']),
      isItalic: _parseBool(map['isItalic']),
      isUnderlined: _parseBool(map['isUnderlined']),
      isStrikethrough: _parseBool(map['isStrikethrough']),
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is int) {
      return value == 1;
    } else if (value is bool) {
      return value;
    }
    return false;
  }

  static Color _parseColor(dynamic value) {
    if (value is int) {
      return Color(value);
    } else if (value is String) {
      return hexToColor(value);
    }
    return Colors.black;
  }
}
