import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/services/geometry_service.dart';

part 'canvas_element.freezed.dart';

@freezed
sealed class CanvasElement with _$CanvasElement {
  const CanvasElement._(); // Permite métodos e getters customizados

  @override
  Map<String, dynamic> get customData;

  /// Obtém um valor do customData com tipagem.
  T? getCustomData<T>(String key) => customData[key] as T?;

  /// Retorna uma cópia do elemento com o valor atualizado no customData.
  CanvasElement setCustomData(String key, dynamic value) {
    final newData = Map<String, dynamic>.from(customData);
    newData[key] = value;
    return copyWithCustomData(newData);
  }

  /// Método auxiliar abstrato para o copyWith do freezed (implementado via macro ou manual wrap)
  /// Na verdade, o freezed gera o copyWith, mas para o union abstrata
  /// precisamos garantir que customData está disponível.
  CanvasElement copyWithCustomData(Map<String, dynamic> customData) {
    return map(
      rectangle: (e) => e.copyWith(customData: customData),
      diamond: (e) => e.copyWith(customData: customData),
      ellipse: (e) => e.copyWith(customData: customData),
      line: (e) => e.copyWith(customData: customData),
      arrow: (e) => e.copyWith(customData: customData),
      freeDraw: (e) => e.copyWith(customData: customData),
      text: (e) => e.copyWith(customData: customData),
      triangle: (e) => e.copyWith(customData: customData),
    );
  }

  // --- Propriedades Comuns como Getters Abstratos (para acesso direto) ---
  // Freezed gera getters para propriedades comuns automaticamente se definidas em todos os construtores.
  // Porém, garantimos que todas as factories tenham estes campos.

  const factory CanvasElement.rectangle({
    required String id,
    @Default(CanvasElementType.rectangle) CanvasElementType type,
    required double x,
    required double y,
    required double width,
    required double height,
    @Default(0) double angle,
    required Color strokeColor,
    Color? fillColor,
    @Default(2.0) double strokeWidth,
    @Default(StrokeStyle.solid) StrokeStyle strokeStyle,
    @Default(FillType.transparent) FillType fillType,
    @Default(1.0) double opacity,
    @Default(0.0) double roughness,
    @Default(0) int zIndex,
    @Default(false) bool isDeleted,
    @Default(1) int version,
    required DateTime updatedAt,
    @Default({}) Map<String, dynamic> customData,
  }) = RectangleElement;

  const factory CanvasElement.diamond({
    required String id,
    @Default(CanvasElementType.diamond) CanvasElementType type,
    required double x,
    required double y,
    required double width,
    required double height,
    @Default(0) double angle,
    required Color strokeColor,
    Color? fillColor,
    @Default(2.0) double strokeWidth,
    @Default(StrokeStyle.solid) StrokeStyle strokeStyle,
    @Default(FillType.transparent) FillType fillType,
    @Default(1.0) double opacity,
    @Default(0.0) double roughness,
    @Default(0) int zIndex,
    @Default(false) bool isDeleted,
    @Default(1) int version,
    required DateTime updatedAt,
    @Default({}) Map<String, dynamic> customData,
  }) = DiamondElement;

  const factory CanvasElement.ellipse({
    required String id,
    @Default(CanvasElementType.ellipse) CanvasElementType type,
    required double x,
    required double y,
    required double width,
    required double height,
    @Default(0) double angle,
    required Color strokeColor,
    Color? fillColor,
    @Default(2.0) double strokeWidth,
    @Default(StrokeStyle.solid) StrokeStyle strokeStyle,
    @Default(FillType.transparent) FillType fillType,
    @Default(1.0) double opacity,
    @Default(0.0) double roughness,
    @Default(0) int zIndex,
    @Default(false) bool isDeleted,
    @Default(1) int version,
    required DateTime updatedAt,
    @Default({}) Map<String, dynamic> customData,
  }) = EllipseElement;

  const factory CanvasElement.line({
    required String id,
    @Default(CanvasElementType.line) CanvasElementType type,
    required double x,
    required double y,
    required double width,
    required double height,
    @Default(0) double angle,
    required Color strokeColor,
    Color? fillColor,
    @Default(2.0) double strokeWidth,
    @Default(StrokeStyle.solid) StrokeStyle strokeStyle,
    @Default(FillType.transparent) FillType fillType,
    @Default(1.0) double opacity,
    @Default(0.0) double roughness,
    @Default(0) int zIndex,
    @Default(false) bool isDeleted,
    @Default(1) int version,
    required DateTime updatedAt,
    required List<Offset> points,
    @Default({}) Map<String, dynamic> customData,
  }) = LineElement;

  const factory CanvasElement.arrow({
    required String id,
    @Default(CanvasElementType.arrow) CanvasElementType type,
    required double x,
    required double y,
    required double width,
    required double height,
    @Default(0) double angle,
    required Color strokeColor,
    Color? fillColor,
    @Default(2.0) double strokeWidth,
    @Default(StrokeStyle.solid) StrokeStyle strokeStyle,
    @Default(FillType.transparent) FillType fillType,
    @Default(1.0) double opacity,
    @Default(0.0) double roughness,
    @Default(0) int zIndex,
    @Default(false) bool isDeleted,
    @Default(1) int version,
    required DateTime updatedAt,
    required List<Offset> points,
    @Default({}) Map<String, dynamic> customData,
  }) = ArrowElement;

  const factory CanvasElement.freeDraw({
    required String id,
    @Default(CanvasElementType.freeDraw) CanvasElementType type,
    required double x,
    required double y,
    required double width,
    required double height,
    @Default(0) double angle,
    required Color strokeColor,
    Color? fillColor,
    @Default(2.0) double strokeWidth,
    @Default(StrokeStyle.solid) StrokeStyle strokeStyle,
    @Default(FillType.transparent) FillType fillType,
    @Default(1.0) double opacity,
    @Default(0.0) double roughness,
    @Default(0) int zIndex,
    @Default(false) bool isDeleted,
    @Default(1) int version,
    required DateTime updatedAt,
    required List<Offset> points,
    @Default({}) Map<String, dynamic> customData,
  }) = FreeDrawElement;

  const factory CanvasElement.text({
    required String id,
    @Default(CanvasElementType.text) CanvasElementType type,
    required double x,
    required double y,
    required double width,
    required double height,
    @Default(0) double angle,
    required Color strokeColor,
    Color? fillColor,
    @Default(2.0) double strokeWidth,
    @Default(StrokeStyle.solid) StrokeStyle strokeStyle,
    @Default(FillType.transparent) FillType fillType,
    @Default(1.0) double opacity,
    @Default(0.0) double roughness,
    @Default(0) int zIndex,
    @Default(false) bool isDeleted,
    @Default(1) int version,
    required DateTime updatedAt,
    required String text,
    @Default('Virgil') String fontFamily,
    @Default(20) double fontSize,
    @Default(TextAlign.left) TextAlign textAlign,
    Color? backgroundColor,
    @Default(4.0) double backgroundRadius,
    @Default(false) bool isBold,
    @Default(false) bool isItalic,
    @Default(false) bool isUnderlined,
    @Default(false) bool isStrikethrough,
    @Default({}) Map<String, dynamic> customData,
  }) = TextElement;

  const factory CanvasElement.triangle({
    required String id,
    @Default(CanvasElementType.triangle) CanvasElementType type,
    required double x,
    required double y,
    required double width,
    required double height,
    @Default(0) double angle,
    required Color strokeColor,
    Color? fillColor,
    @Default(2.0) double strokeWidth,
    @Default(StrokeStyle.solid) StrokeStyle strokeStyle,
    @Default(FillType.transparent) FillType fillType,
    @Default(1.0) double opacity,
    @Default(0.0) double roughness,
    @Default(0) int zIndex,
    @Default(false) bool isDeleted,
    @Default(1) int version,
    required DateTime updatedAt,
    @Default({}) Map<String, dynamic> customData,
  }) = TriangleElement;

  /// Calcula o bounding box (retângulo delimitador) do elemento.
  Rect get bounds => Rect.fromLTWH(x, y, width, height);

  /// Determines if the clicked point hits this element (precise hit-test).
  bool containsPoint(Offset point) {
    return GeometryService.containsPoint(this, point);
  }

  /// Se o elemento pode ser redimensionado por alças padrão.
  bool get isResizable => map(
        rectangle: (_) => true,
        diamond: (_) => true,
        ellipse: (_) => true,
        text: (_) =>
            true, // Texto geralmente é redimensionado por fonte, mas pode ter bounds
        line: (_) => true,
        arrow: (_) => true,
        freeDraw: (_) => false, // FreeDraw não suporta resize padrão ainda
        triangle: (_) => true,
      );

  /// Se o elemento é baseado em linha (tem pontos).
  bool get isLineType => map(
        rectangle: (_) => false,
        diamond: (_) => false,
        ellipse: (_) => false,
        text: (_) => false,
        line: (_) => true,
        arrow: (_) => true,
        freeDraw: (_) => true,
        triangle: (_) => false,
      );
}
