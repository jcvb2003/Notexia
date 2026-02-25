import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/services/geometry_service.dart';

/// Base sealed class for all canvas elements.
/// Uses Dart 3 sealed class for exhaustive switch support.
sealed class CanvasElement extends Equatable {
  const CanvasElement();

  // Common properties — every subtype must have these
  String get id;
  CanvasElementType get type;
  double get x;
  double get y;
  double get width;
  double get height;
  double get angle;
  Color get strokeColor;
  Color? get fillColor;
  double get strokeWidth;
  StrokeStyle get strokeStyle;
  FillType get fillType;
  double get opacity;
  double get roughness;
  int get zIndex;
  bool get isDeleted;
  int get version;
  DateTime get updatedAt;

  /// Calculates the bounding box of the element.
  Rect get bounds => Rect.fromLTWH(x, y, width, height);

  /// Determines if the clicked point hits this element (precise hit-test).
  bool containsPoint(Offset point) {
    return GeometryService.containsPoint(this, point);
  }

  /// Whether the element can be resized by standard handles.
  bool get isResizable => switch (this) {
        RectangleElement() => true,
        DiamondElement() => true,
        EllipseElement() => true,
        TextElement() => true,
        LineElement() => true,
        ArrowElement() => true,
        FreeDrawElement() => false,
        TriangleElement() => true,
      };

  /// Whether the element is line-based (has points).
  bool get isLineType => switch (this) {
        RectangleElement() => false,
        DiamondElement() => false,
        EllipseElement() => false,
        TextElement() => false,
        LineElement() => true,
        ArrowElement() => true,
        FreeDrawElement() => true,
        TriangleElement() => false,
      };

  /// Generic copyWith that all subtypes implement.
  CanvasElement copyWith({
    String? id,
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
    DateTime? updatedAt,
  });
}

// ─────────────────────────────────────────────
// Shape elements (no extra fields beyond common)
// ─────────────────────────────────────────────

final class RectangleElement extends CanvasElement {
  @override
  final String id;
  @override
  final CanvasElementType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  final double angle;
  @override
  final Color strokeColor;
  @override
  final Color? fillColor;
  @override
  final double strokeWidth;
  @override
  final StrokeStyle strokeStyle;
  @override
  final FillType fillType;
  @override
  final double opacity;
  @override
  final double roughness;
  @override
  final int zIndex;
  @override
  final bool isDeleted;
  @override
  final int version;
  @override
  final DateTime updatedAt;

  const RectangleElement({
    required this.id,
    this.type = CanvasElementType.rectangle,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.angle = 0,
    required this.strokeColor,
    this.fillColor,
    this.strokeWidth = 2.0,
    this.strokeStyle = StrokeStyle.solid,
    this.fillType = FillType.transparent,
    this.opacity = 1.0,
    this.roughness = 0.0,
    this.zIndex = 0,
    this.isDeleted = false,
    this.version = 1,
    required this.updatedAt,
  });

  @override
  RectangleElement copyWith({
    String? id,
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
    DateTime? updatedAt,
  }) =>
      RectangleElement(
        id: id ?? this.id,
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
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props => [
        id,
        type,
        x,
        y,
        width,
        height,
        angle,
        strokeColor,
        fillColor,
        strokeWidth,
        strokeStyle,
        fillType,
        opacity,
        roughness,
        zIndex,
        isDeleted,
        version,
        updatedAt
      ];
}

final class DiamondElement extends CanvasElement {
  @override
  final String id;
  @override
  final CanvasElementType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  final double angle;
  @override
  final Color strokeColor;
  @override
  final Color? fillColor;
  @override
  final double strokeWidth;
  @override
  final StrokeStyle strokeStyle;
  @override
  final FillType fillType;
  @override
  final double opacity;
  @override
  final double roughness;
  @override
  final int zIndex;
  @override
  final bool isDeleted;
  @override
  final int version;
  @override
  final DateTime updatedAt;

  const DiamondElement({
    required this.id,
    this.type = CanvasElementType.diamond,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.angle = 0,
    required this.strokeColor,
    this.fillColor,
    this.strokeWidth = 2.0,
    this.strokeStyle = StrokeStyle.solid,
    this.fillType = FillType.transparent,
    this.opacity = 1.0,
    this.roughness = 0.0,
    this.zIndex = 0,
    this.isDeleted = false,
    this.version = 1,
    required this.updatedAt,
  });

  @override
  DiamondElement copyWith({
    String? id,
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
    DateTime? updatedAt,
  }) =>
      DiamondElement(
        id: id ?? this.id,
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
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props => [
        id,
        type,
        x,
        y,
        width,
        height,
        angle,
        strokeColor,
        fillColor,
        strokeWidth,
        strokeStyle,
        fillType,
        opacity,
        roughness,
        zIndex,
        isDeleted,
        version,
        updatedAt
      ];
}

final class EllipseElement extends CanvasElement {
  @override
  final String id;
  @override
  final CanvasElementType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  final double angle;
  @override
  final Color strokeColor;
  @override
  final Color? fillColor;
  @override
  final double strokeWidth;
  @override
  final StrokeStyle strokeStyle;
  @override
  final FillType fillType;
  @override
  final double opacity;
  @override
  final double roughness;
  @override
  final int zIndex;
  @override
  final bool isDeleted;
  @override
  final int version;
  @override
  final DateTime updatedAt;

  const EllipseElement({
    required this.id,
    this.type = CanvasElementType.ellipse,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.angle = 0,
    required this.strokeColor,
    this.fillColor,
    this.strokeWidth = 2.0,
    this.strokeStyle = StrokeStyle.solid,
    this.fillType = FillType.transparent,
    this.opacity = 1.0,
    this.roughness = 0.0,
    this.zIndex = 0,
    this.isDeleted = false,
    this.version = 1,
    required this.updatedAt,
  });

  @override
  EllipseElement copyWith({
    String? id,
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
    DateTime? updatedAt,
  }) =>
      EllipseElement(
        id: id ?? this.id,
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
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props => [
        id,
        type,
        x,
        y,
        width,
        height,
        angle,
        strokeColor,
        fillColor,
        strokeWidth,
        strokeStyle,
        fillType,
        opacity,
        roughness,
        zIndex,
        isDeleted,
        version,
        updatedAt
      ];
}

final class TriangleElement extends CanvasElement {
  @override
  final String id;
  @override
  final CanvasElementType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  final double angle;
  @override
  final Color strokeColor;
  @override
  final Color? fillColor;
  @override
  final double strokeWidth;
  @override
  final StrokeStyle strokeStyle;
  @override
  final FillType fillType;
  @override
  final double opacity;
  @override
  final double roughness;
  @override
  final int zIndex;
  @override
  final bool isDeleted;
  @override
  final int version;
  @override
  final DateTime updatedAt;

  const TriangleElement({
    required this.id,
    this.type = CanvasElementType.triangle,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.angle = 0,
    required this.strokeColor,
    this.fillColor,
    this.strokeWidth = 2.0,
    this.strokeStyle = StrokeStyle.solid,
    this.fillType = FillType.transparent,
    this.opacity = 1.0,
    this.roughness = 0.0,
    this.zIndex = 0,
    this.isDeleted = false,
    this.version = 1,
    required this.updatedAt,
  });

  @override
  TriangleElement copyWith({
    String? id,
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
    DateTime? updatedAt,
  }) =>
      TriangleElement(
        id: id ?? this.id,
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
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props => [
        id,
        type,
        x,
        y,
        width,
        height,
        angle,
        strokeColor,
        fillColor,
        strokeWidth,
        strokeStyle,
        fillType,
        opacity,
        roughness,
        zIndex,
        isDeleted,
        version,
        updatedAt
      ];
}

// ─────────────────────────────────────────────
// Line-based elements (have List<Offset> points)
// ─────────────────────────────────────────────

final class LineElement extends CanvasElement {
  @override
  final String id;
  @override
  final CanvasElementType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  final double angle;
  @override
  final Color strokeColor;
  @override
  final Color? fillColor;
  @override
  final double strokeWidth;
  @override
  final StrokeStyle strokeStyle;
  @override
  final FillType fillType;
  @override
  final double opacity;
  @override
  final double roughness;
  @override
  final int zIndex;
  @override
  final bool isDeleted;
  @override
  final int version;
  @override
  final DateTime updatedAt;
  final List<Offset> points;

  const LineElement({
    required this.id,
    this.type = CanvasElementType.line,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.angle = 0,
    required this.strokeColor,
    this.fillColor,
    this.strokeWidth = 2.0,
    this.strokeStyle = StrokeStyle.solid,
    this.fillType = FillType.transparent,
    this.opacity = 1.0,
    this.roughness = 0.0,
    this.zIndex = 0,
    this.isDeleted = false,
    this.version = 1,
    required this.updatedAt,
    required this.points,
  });

  @override
  LineElement copyWith({
    String? id,
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
    DateTime? updatedAt,
    List<Offset>? points,
  }) =>
      LineElement(
        id: id ?? this.id,
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
        updatedAt: updatedAt ?? this.updatedAt,
        points: points ?? this.points,
      );

  @override
  List<Object?> get props => [
        id,
        type,
        x,
        y,
        width,
        height,
        angle,
        strokeColor,
        fillColor,
        strokeWidth,
        strokeStyle,
        fillType,
        opacity,
        roughness,
        zIndex,
        isDeleted,
        version,
        updatedAt,
        points
      ];
}

final class ArrowElement extends CanvasElement {
  @override
  final String id;
  @override
  final CanvasElementType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  final double angle;
  @override
  final Color strokeColor;
  @override
  final Color? fillColor;
  @override
  final double strokeWidth;
  @override
  final StrokeStyle strokeStyle;
  @override
  final FillType fillType;
  @override
  final double opacity;
  @override
  final double roughness;
  @override
  final int zIndex;
  @override
  final bool isDeleted;
  @override
  final int version;
  @override
  final DateTime updatedAt;
  final List<Offset> points;

  const ArrowElement({
    required this.id,
    this.type = CanvasElementType.arrow,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.angle = 0,
    required this.strokeColor,
    this.fillColor,
    this.strokeWidth = 2.0,
    this.strokeStyle = StrokeStyle.solid,
    this.fillType = FillType.transparent,
    this.opacity = 1.0,
    this.roughness = 0.0,
    this.zIndex = 0,
    this.isDeleted = false,
    this.version = 1,
    required this.updatedAt,
    required this.points,
  });

  @override
  ArrowElement copyWith({
    String? id,
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
    DateTime? updatedAt,
    List<Offset>? points,
  }) =>
      ArrowElement(
        id: id ?? this.id,
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
        updatedAt: updatedAt ?? this.updatedAt,
        points: points ?? this.points,
      );

  @override
  List<Object?> get props => [
        id,
        type,
        x,
        y,
        width,
        height,
        angle,
        strokeColor,
        fillColor,
        strokeWidth,
        strokeStyle,
        fillType,
        opacity,
        roughness,
        zIndex,
        isDeleted,
        version,
        updatedAt,
        points
      ];
}

final class FreeDrawElement extends CanvasElement {
  @override
  final String id;
  @override
  final CanvasElementType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  final double angle;
  @override
  final Color strokeColor;
  @override
  final Color? fillColor;
  @override
  final double strokeWidth;
  @override
  final StrokeStyle strokeStyle;
  @override
  final FillType fillType;
  @override
  final double opacity;
  @override
  final double roughness;
  @override
  final int zIndex;
  @override
  final bool isDeleted;
  @override
  final int version;
  @override
  final DateTime updatedAt;
  final List<Offset> points;

  const FreeDrawElement({
    required this.id,
    this.type = CanvasElementType.freeDraw,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.angle = 0,
    required this.strokeColor,
    this.fillColor,
    this.strokeWidth = 2.0,
    this.strokeStyle = StrokeStyle.solid,
    this.fillType = FillType.transparent,
    this.opacity = 1.0,
    this.roughness = 0.0,
    this.zIndex = 0,
    this.isDeleted = false,
    this.version = 1,
    required this.updatedAt,
    required this.points,
  });

  @override
  FreeDrawElement copyWith({
    String? id,
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
    DateTime? updatedAt,
    List<Offset>? points,
  }) =>
      FreeDrawElement(
        id: id ?? this.id,
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
        updatedAt: updatedAt ?? this.updatedAt,
        points: points ?? this.points,
      );

  @override
  List<Object?> get props => [
        id,
        type,
        x,
        y,
        width,
        height,
        angle,
        strokeColor,
        fillColor,
        strokeWidth,
        strokeStyle,
        fillType,
        opacity,
        roughness,
        zIndex,
        isDeleted,
        version,
        updatedAt,
        points
      ];
}

// ─────────────────────────────────────────────
// Text element (has text-specific fields)
// ─────────────────────────────────────────────

final class TextElement extends CanvasElement {
  @override
  final String id;
  @override
  final CanvasElementType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  final double angle;
  @override
  final Color strokeColor;
  @override
  final Color? fillColor;
  @override
  final double strokeWidth;
  @override
  final StrokeStyle strokeStyle;
  @override
  final FillType fillType;
  @override
  final double opacity;
  @override
  final double roughness;
  @override
  final int zIndex;
  @override
  final bool isDeleted;
  @override
  final int version;
  @override
  final DateTime updatedAt;
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
    required this.id,
    this.type = CanvasElementType.text,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.angle = 0,
    required this.strokeColor,
    this.fillColor,
    this.strokeWidth = 2.0,
    this.strokeStyle = StrokeStyle.solid,
    this.fillType = FillType.transparent,
    this.opacity = 1.0,
    this.roughness = 0.0,
    this.zIndex = 0,
    this.isDeleted = false,
    this.version = 1,
    required this.updatedAt,
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
  TextElement copyWith({
    String? id,
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
  }) =>
      TextElement(
        id: id ?? this.id,
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

  @override
  List<Object?> get props => [
        id,
        type,
        x,
        y,
        width,
        height,
        angle,
        strokeColor,
        fillColor,
        strokeWidth,
        strokeStyle,
        fillType,
        opacity,
        roughness,
        zIndex,
        isDeleted,
        version,
        updatedAt,
        text,
        fontFamily,
        fontSize,
        textAlign,
        backgroundColor,
        backgroundRadius,
        isBold,
        isItalic,
        isUnderlined,
        isStrikethrough
      ];
}
