import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

/// Define as propriedades de estilo padrÃ£o para novos elementos ou elementos selecionados.
class ElementStyle extends Equatable {
  final Color strokeColor;
  final Color? fillColor;
  final double strokeWidth;
  final StrokeStyle strokeStyle;
  final FillType fillType;
  final double opacity;
  final double roughness;

  const ElementStyle({
    this.strokeColor = AppColors.paletteNeutral,
    this.fillColor,
    this.strokeWidth = 2.0,
    this.strokeStyle = StrokeStyle.solid,
    this.fillType = FillType.transparent,
    this.opacity = 1.0,
    this.roughness = 0.0,
  });

  @override
  List<Object?> get props => [
        strokeColor,
        fillColor,
        strokeWidth,
        strokeStyle,
        fillType,
        opacity,
        roughness,
      ];

  ElementStyle copyWith({
    Color? strokeColor,
    Color? fillColor,
    double? strokeWidth,
    StrokeStyle? strokeStyle,
    FillType? fillType,
    double? opacity,
    double? roughness,
  }) {
    return ElementStyle(
      strokeColor: strokeColor ?? this.strokeColor,
      fillColor: fillColor ?? this.fillColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeStyle: strokeStyle ?? this.strokeStyle,
      fillType: fillType ?? this.fillType,
      opacity: opacity ?? this.opacity,
      roughness: roughness ?? this.roughness,
    );
  }
}

/// Represents a set of changes to apply to an element or the current style.
class ElementStylePatch extends Equatable {
  final Color? strokeColor;
  final Color? fillColor;
  final double? strokeWidth;
  final StrokeStyle? strokeStyle;
  final FillType? fillType;
  final double? opacity;
  final double? roughness;

  // Text specific
  final String? text;
  final String? fontFamily;
  final double? fontSize;
  final TextAlign? textAlign;
  final Color? backgroundColor;
  final double? backgroundRadius;
  final bool? isBold;
  final bool? isItalic;
  final bool? isUnderlined;
  final bool? isStrikethrough;

  const ElementStylePatch({
    this.strokeColor,
    this.fillColor,
    this.strokeWidth,
    this.strokeStyle,
    this.fillType,
    this.opacity,
    this.roughness,
    this.text,
    this.fontFamily,
    this.fontSize,
    this.textAlign,
    this.backgroundColor,
    this.backgroundRadius,
    this.isBold,
    this.isItalic,
    this.isUnderlined,
    this.isStrikethrough,
  });

  bool get isEmpty =>
      strokeColor == null &&
      fillColor == null &&
      strokeWidth == null &&
      strokeStyle == null &&
      fillType == null &&
      opacity == null &&
      roughness == null &&
      text == null &&
      fontFamily == null &&
      fontSize == null &&
      textAlign == null &&
      backgroundColor == null &&
      backgroundRadius == null &&
      isBold == null &&
      isItalic == null &&
      isUnderlined == null &&
      isStrikethrough == null;

  @override
  List<Object?> get props => [
        strokeColor,
        fillColor,
        strokeWidth,
        strokeStyle,
        fillType,
        opacity,
        roughness,
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

  /// Applies this patch to an [ElementStyle].
  /// Note: Only standard style properties are applied.
  ElementStyle applyTo(ElementStyle style) {
    return style.copyWith(
      strokeColor: strokeColor,
      fillColor: fillColor,
      strokeWidth: strokeWidth,
      strokeStyle: strokeStyle,
      fillType: fillType,
      opacity: opacity,
      roughness: roughness,
    );
  }
}
