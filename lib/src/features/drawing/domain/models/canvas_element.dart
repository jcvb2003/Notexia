import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart'; // Mantemos para Color, Offset, Rect
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';

abstract class CanvasElement extends Equatable {
  final String id;
  final CanvasElementType type;
  final double x;
  final double y;
  final double width;
  final double height;
  final double angle;
  final Color strokeColor;
  final Color? fillColor;
  final double strokeWidth;
  final StrokeStyle strokeStyle;
  final FillType fillType;
  final double opacity;
  final double roughness;
  final int zIndex;
  final bool isDeleted;
  final int version;
  final int versionNonce;
  final DateTime updatedAt;

  const CanvasElement({
    required this.id,
    required this.type,
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
    this.versionNonce = 0,
    required this.updatedAt,
  });

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
        versionNonce,
        updatedAt,
      ];

  /// Calcula o bounding box (retÃ¢ngulo delimitador) do elemento.
  Rect get bounds => Rect.fromLTWH(x, y, width, height);

  /// Cria uma cÃ³pia do elemento com campos atualizados.
  /// Subclasses devem implementar este mÃ©todo.
  CanvasElement copyWith({
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
  });

  // MÃ©todo render REMOVIDO. A renderizaÃ§Ã£o agora Ã© responsabilidade de ElementRenderer.

  /// Determina se o ponto clicado atinge este elemento (hit-test bÃ¡sico).
  bool containsPoint(Offset point) {
    return bounds.contains(point);
  }

  /// Se o elemento pode ser redimensionado por alÃ§as padrÃ£o.
  bool get isResizable => true;

  /// Se o elemento Ã© baseado em linha (tem pontos).
  bool get isLineType => false;
}
