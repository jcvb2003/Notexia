import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/services/geometry_service.dart';

part 'canvas_element.freezed.dart';

@freezed
sealed class CanvasElement with _$CanvasElement {
  const CanvasElement._(); // Permite métodos e getters customizados

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
    @Default(0) int versionNonce,
    required DateTime updatedAt,
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
    @Default(0) int versionNonce,
    required DateTime updatedAt,
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
    @Default(0) int versionNonce,
    required DateTime updatedAt,
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
    @Default(0) int versionNonce,
    required DateTime updatedAt,
    required List<Offset> points,
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
    @Default(0) int versionNonce,
    required DateTime updatedAt,
    required List<Offset> points,
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
    @Default(0) int versionNonce,
    required DateTime updatedAt,
    required List<Offset> points,
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
    @Default(0) int versionNonce,
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
    @Default(0) int versionNonce,
    required DateTime updatedAt,
  }) = TriangleElement;

  /// Calcula o bounding box (retângulo delimitador) do elemento.
  Rect get bounds => Rect.fromLTWH(x, y, width, height);

  /// Determina se o ponto clicado atinge este elemento (hit-test básico ou preciso).
  bool containsPoint(Offset point) {
    return map(
      rectangle: (e) => e.bounds.contains(point),
      diamond: (e) => GeometryService.isPointInDiamond(point, e.bounds),
      ellipse: (e) => GeometryService.isPointInEllipse(point, e.bounds),
      text: (e) => e.bounds.contains(point),
      line: (e) => _containsPointLine(point, e.x, e.y, e.points),
      arrow: (e) => _containsPointLine(point, e.x, e.y, e.points),
      freeDraw: (e) => _containsPointFreeDraw(point, e.x, e.y, e.points),
      triangle: (e) => _containsPointTriangle(point, e.x, e.y, e.width, e.height),
    );
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

  static bool _containsPointLine(
      Offset point, double x, double y, List<Offset> points) {
    if (points.length < 2) return false;
    final localPoint = Offset(point.dx - x, point.dy - y);
    return GeometryService.distanceToSegment(
            localPoint, points[0], points[1]) <=
        10.0;
  }

  static bool _containsPointFreeDraw(
      Offset point, double x, double y, List<Offset> points) {
    if (points.isEmpty) return false;
    final localPoint = Offset(point.dx - x, point.dy - y);
    for (int i = 0; i < points.length - 1; i++) {
      if (GeometryService.distanceToSegment(
            localPoint,
            points[i],
            points[i + 1],
          ) <=
          10.0) {
        return true;
      }
    }
    return false;
  }

  static bool _containsPointTriangle(
      Offset point, double x, double y, double w, double h) {
    final p0 = Offset(x + w / 2, y);
    final p1 = Offset(x + w, y + h);
    final p2 = Offset(x, y + h);

    return GeometryService.isPointInTriangle(point, p0, p1, p2);
  }
}
