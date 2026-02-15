import 'package:flutter/material.dart';
import 'package:notexia/src/app/config/constants/notexia_constants.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_entities.dart';
import 'package:notexia/src/core/canvas/primitives/geometry_service.dart';

/// ServiÃ§o responsÃ¡vel pelas transformaÃ§Ãµes aplicadas aos elementos do canvas.
class TransformationService {
  /// Move um elemento por um determinado deslocamento (delta).
  CanvasElement moveElement(CanvasElement element, double dx, double dy) {
    return element.copyWith(
      x: element.x + dx,
      y: element.y + dy,
      updatedAt: DateTime.now(),
      version: element.version + 1,
    );
  }

  /// Redimensiona um elemento (mantendo a proporÃ§Ã£o ou nÃ£o dependendo da lÃ³gica da UI).
  CanvasElement resizeElement(
    CanvasElement element,
    double width,
    double height,
  ) {
    return element.copyWith(
      width: width.clamp(1.0, double.infinity),
      height: height.clamp(1.0, double.infinity),
      updatedAt: DateTime.now(),
      version: element.version + 1,
    );
  }

  /// Rotaciona um elemento.
  CanvasElement rotateElement(CanvasElement element, double angle) {
    return element.copyWith(
      angle: angle,
      updatedAt: DateTime.now(),
      version: element.version + 1,
    );
  }

  /// Redimensiona e posiciona o elemento de acordo com um Rect final.
  /// Encapsula width/height + x/y e incrementa version/updatedAt.
  CanvasElement resizeAndPlace(CanvasElement element, Rect rect) {
    return element.copyWith(
      width: rect.width.clamp(1.0, double.infinity),
      height: rect.height.clamp(1.0, double.infinity),
      x: rect.left,
      y: rect.top,
      updatedAt: DateTime.now(),
      version: element.version + 1,
    );
  }

  /// Atualiza um endpoint de LineElement/ArrowElement.
  /// - isStart: define se o endpoint inicial estÃ¡ sendo movido.
  /// - worldPoint: posiÃ§Ã£o absoluta do endpoint movido.
  /// - snapAngle: se verdadeiro, ajusta o vetor para o Ã¢ngulo mais prÃ³ximo (pi/12).
  CanvasElement updateLineOrArrowEndpoint({
    required CanvasElement element,
    required bool isStart,
    required Offset worldPoint,
    bool snapAngle = false,
    double? angleStep,
  }) {
    if (element is LineElement) {
      if (element.points.length < 2) return element;
      final startAbs = Offset(element.x, element.y) + element.points[0];
      final endAbs = Offset(element.x, element.y) + element.points[1];
      final newStart = isStart ? worldPoint : startAbs;
      final newEnd = isStart ? endAbs : worldPoint;
      final fixed = isStart ? newEnd : newStart;
      final moving = isStart ? newStart : newEnd;
      final nextMoving = snapAngle
          ? fixed +
                GeometryService.snapVector(
                  moving - fixed,
                  angleStep ?? NotexiaConstants.angleSnapStep,
                )
          : moving;
      final finalStart = isStart ? nextMoving : fixed;
      final finalEnd = isStart ? fixed : nextMoving;
      final (nx, ny, w, h, shifted) = GeometryService.normalizePoints(0, 0, [
        finalStart,
        finalEnd,
      ]);
      return element.copyWith(
        x: nx,
        y: ny,
        width: w,
        height: h,
        points: shifted,
        updatedAt: DateTime.now(),
        version: element.version + 1,
      );
    } else if (element is ArrowElement) {
      if (element.points.length < 2) return element;
      final startAbs = Offset(element.x, element.y) + element.points[0];
      final endAbs = Offset(element.x, element.y) + element.points[1];
      final newStart = isStart ? worldPoint : startAbs;
      final newEnd = isStart ? endAbs : worldPoint;
      final fixed = isStart ? newEnd : newStart;
      final moving = isStart ? newStart : newEnd;
      final nextMoving = snapAngle
          ? fixed +
                GeometryService.snapVector(
                  moving - fixed,
                  angleStep ?? NotexiaConstants.angleSnapStep,
                )
          : moving;
      final finalStart = isStart ? nextMoving : fixed;
      final finalEnd = isStart ? fixed : nextMoving;
      final (nx, ny, w, h, shifted) = GeometryService.normalizePoints(0, 0, [
        finalStart,
        finalEnd,
      ]);
      return element.copyWith(
        x: nx,
        y: ny,
        width: w,
        height: h,
        points: shifted,
        updatedAt: DateTime.now(),
        version: element.version + 1,
      );
    }
    return element;
  }
}

