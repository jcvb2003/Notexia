import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';

/// Representa um texto no canvas.
class TextElement extends CanvasElement {
  final String text;
  final String fontFamily;
  final double fontSize;
  final TextAlign textAlign;
  final Color? backgroundColor;
  final double backgroundRadius;
  final bool isBold;
  final bool isItalic;
  final bool isUnderlined;
  final bool isStrikethrough;

  const TextElement({
    required super.id,
    super.type = CanvasElementType.text,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    super.angle,
    required super.strokeColor,
    super.fillColor,
    super.strokeWidth,
    super.strokeStyle,
    super.fillType,
    super.opacity,
    super.roughness,
    super.zIndex,
    super.isDeleted,
    super.version,
    super.versionNonce,
    required super.updatedAt,
    required this.text,
    this.fontFamily = 'Virgil',
    this.fontSize = 20,
    this.textAlign = TextAlign.left,
    this.backgroundColor,
    this.backgroundRadius = 4.0,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderlined = false,
    this.isStrikethrough = false,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        text,
        fontFamily,
        fontSize,
        textAlign,
        backgroundColor,
        backgroundRadius,
        isBold,
        isItalic,
        isUnderlined,
        isStrikethrough,
      ];

  @override
  TextElement copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    double? angle,
    Color? strokeColor,
    Color? fillColor,
    double? strokeWidth,
    StrokeStyle? strokeStyle,
    FillType? fillType,
    double? opacity,
    double? roughness,
    int? zIndex,
    bool? isDeleted,
    int? version,
    int? versionNonce,
    DateTime? updatedAt,
    String? text,
    String? fontFamily,
    double? fontSize,
    TextAlign? textAlign,
    Color? backgroundColor,
    double? backgroundRadius,
    bool? isBold,
    bool? isItalic,
    bool? isUnderlined,
    bool? isStrikethrough,
  }) {
    return TextElement(
      id: id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      angle: angle ?? this.angle,
      strokeColor: strokeColor ?? this.strokeColor,
      fillColor: fillColor ?? this.fillColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeStyle: strokeStyle ?? this.strokeStyle,
      fillType: fillType ?? this.fillType,
      opacity: opacity ?? this.opacity,
      roughness: roughness ?? this.roughness,
      zIndex: zIndex ?? this.zIndex,
      isDeleted: isDeleted ?? this.isDeleted,
      version: version ?? this.version,
      versionNonce: versionNonce ?? this.versionNonce,
      updatedAt: updatedAt ?? this.updatedAt,
      text: text ?? this.text,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      textAlign: textAlign ?? this.textAlign,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundRadius: backgroundRadius ?? this.backgroundRadius,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderlined: isUnderlined ?? this.isUnderlined,
      isStrikethrough: isStrikethrough ?? this.isStrikethrough,
    );
  }

  // render removido.
}
