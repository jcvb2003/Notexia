import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:notexia/src/app/config/constants/app_constants.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';
import 'package:notexia/src/features/drawing/domain/services/geometry_service.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';

/// ServiÃ§o responsÃ¡vel por realizar transformaÃ§Ãµes e manipulaÃ§Ãµes nos elementos do canvas.
/// Desacopla a lÃ³gica matemÃ¡tica e de transformaÃ§Ã£o do Cubit.
class CanvasManipulationService {
  final TransformationService _transformationService;

  CanvasManipulationService(this._transformationService);

  /// Move os elementos selecionados por um determinado delta.
  List<CanvasElement> moveElements(
    List<CanvasElement> elements,
    Set<String> selectedIds,
    Offset delta,
  ) {
    if (selectedIds.isEmpty) return elements;

    return elements.map((element) {
      if (selectedIds.contains(element.id)) {
        return _transformationService.moveElement(element, delta.dx, delta.dy);
      }
      return element;
    }).toList();
  }

  /// Remove os elementos selecionados da lista.
  List<CanvasElement> deleteElements(
    List<CanvasElement> elements,
    Set<String> selectedIds,
  ) {
    if (selectedIds.isEmpty) return elements;
    return elements.where((e) => !selectedIds.contains(e.id)).toList();
  }

  /// Atualiza propriedades visuais dos elementos selecionados.
  List<CanvasElement> updateElementsProperties(
    List<CanvasElement> elements,
    Set<String> selectedIds,
    ElementStylePatch patch,
  ) {
    if (selectedIds.isEmpty) return elements;

    return elements.map((element) {
      if (selectedIds.contains(element.id)) {
        CanvasElement updated = element;

        // Propriedades comuns
        if (patch.strokeColor != null ||
            patch.fillColor != null ||
            patch.strokeWidth != null ||
            patch.strokeStyle != null ||
            patch.fillType != null ||
            patch.opacity != null ||
            patch.roughness != null) {
          updated = updated.copyWith(
            strokeColor: patch.strokeColor ?? updated.strokeColor,
            fillColor: patch.fillColor ?? updated.fillColor,
            strokeWidth: patch.strokeWidth ?? updated.strokeWidth,
            strokeStyle: patch.strokeStyle ?? updated.strokeStyle,
            fillType: patch.fillType ?? updated.fillType,
            opacity: patch.opacity ?? updated.opacity,
            roughness: patch.roughness ?? updated.roughness,
            updatedAt: DateTime.now(),
          );
        }

        // Propriedades de Texto
        if (updated is TextElement) {
          final textEl = updated;
          updated = textEl.copyWith(
            text: patch.text ?? textEl.text,
            fontFamily: patch.fontFamily ?? textEl.fontFamily,
            fontSize: patch.fontSize ?? textEl.fontSize,
            textAlign: patch.textAlign ?? textEl.textAlign,
            backgroundColor: patch.backgroundColor ?? textEl.backgroundColor,
            backgroundRadius: patch.backgroundRadius ?? textEl.backgroundRadius,
            isBold: patch.isBold ?? textEl.isBold,
            isItalic: patch.isItalic ?? textEl.isItalic,
            isUnderlined: patch.isUnderlined ?? textEl.isUnderlined,
            isStrikethrough: patch.isStrikethrough ?? textEl.isStrikethrough,
            updatedAt: DateTime.now(),
          );
        }

        return updated;
      }
      return element;
    }).toList();
  }

  /// Atualiza a geometria de um elemento durante o desenho ativo.
  CanvasElement updateDrawingElement(
    CanvasElement element,
    Offset currentPosition, {
    required Offset startPosition,
    bool keepAspect = false,
    bool snapAngle = false,
    bool createFromCenter = false,
    double? snapAngleStep,
  }) {
    if (element is LineElement ||
        element is ArrowElement ||
        element is FreeDrawElement) {
      final localOffsetForLines = currentPosition - startPosition;
      final angleStep = snapAngleStep ?? AppConstants.angleSnapStep;

      if (element is LineElement) {
        final snappedOffset = snapAngle
            ? GeometryService.snapVector(localOffsetForLines, angleStep)
            : localOffsetForLines;

        // Sempre reconstrÃ³i a partir da origem (0,0) relativa ao startPosition
        // para evitar que normalizaÃ§Ãµes sucessivas desloquem os pontos erroneamente.
        final newPoints = [Offset.zero, snappedOffset];

        final normalized = GeometryService.normalizePoints(
          startPosition.dx,
          startPosition.dy,
          newPoints,
        );
        return element.copyWith(
          x: normalized.$1,
          y: normalized.$2,
          width: normalized.$3,
          height: normalized.$4,
          points: normalized.$5,
        );
      } else if (element is ArrowElement) {
        final snappedOffset = snapAngle
            ? GeometryService.snapVector(localOffsetForLines, angleStep)
            : localOffsetForLines;

        final newPoints = [Offset.zero, snappedOffset];

        final normalized = GeometryService.normalizePoints(
          startPosition.dx,
          startPosition.dy,
          newPoints,
        );
        return element.copyWith(
          x: normalized.$1,
          y: normalized.$2,
          width: normalized.$3,
          height: normalized.$4,
          points: normalized.$5,
        );
      } else if (element is FreeDrawElement) {
        // Converte os pontos atuais de volta para o espaÃ§o relativo ao startPosition
        // para poder adicionar o novo ponto de forma consistente.
        final relativePoints = element.points.map((p) {
          return Offset(
            p.dx + (element.x - startPosition.dx),
            p.dy + (element.y - startPosition.dy),
          );
        }).toList();

        final localPoint = currentPosition - startPosition;
        if (relativePoints.isEmpty ||
            (localPoint - relativePoints.last).distance >= 1.5) {
          relativePoints.add(localPoint);
        }

        final normalized = GeometryService.normalizePoints(
          startPosition.dx,
          startPosition.dy,
          relativePoints,
        );
        return element.copyWith(
          x: normalized.$1,
          y: normalized.$2,
          width: normalized.$3,
          height: normalized.$4,
          points: normalized.$5,
        );
      }
    }

    // LÃ³gica para Formas (RetÃ¢ngulo, Elipse, Diamante) - Inspirado no snow_draw
    final dx = (currentPosition.dx - startPosition.dx).abs();
    final dy = (currentPosition.dy - startPosition.dy).abs();

    double minX = math.min(startPosition.dx, currentPosition.dx);
    double minY = math.min(startPosition.dy, currentPosition.dy);
    double maxX = math.max(startPosition.dx, currentPosition.dx);
    double maxY = math.max(startPosition.dy, currentPosition.dy);

    if (createFromCenter) {
      minX = startPosition.dx - dx;
      minY = startPosition.dy - dy;
      maxX = startPosition.dx + dx;
      maxY = startPosition.dy + dy;
    }

    if (keepAspect) {
      final width = maxX - minX;
      final height = maxY - minY;

      if (width > height) {
        if (createFromCenter) {
          minY = startPosition.dy - dx;
          maxY = startPosition.dy + dx;
        } else {
          if (startPosition.dy < currentPosition.dy) {
            maxY = minY + width;
          } else {
            minY = maxY - width;
          }
        }
      } else {
        if (createFromCenter) {
          minX = startPosition.dx - dy;
          maxX = startPosition.dx + dy;
        } else {
          if (startPosition.dx < currentPosition.dx) {
            maxX = minX + height;
          } else {
            minX = maxX - height;
          }
        }
      }
    }

    return element.copyWith(
      x: minX,
      y: minY,
      width: maxX - minX,
      height: maxY - minY,
      updatedAt: DateTime.now(),
      version: element.version + 1,
    );
  }
}
