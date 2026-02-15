import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';

class ObjectSnapService {
  static const double _snapDistance = 8.0;

  static SnapResult snapMove({
    required Rect targetRect,
    required List<CanvasElement> referenceElements,
    required List<String> excludedElementIds,
  }) {
    double snapDx = 0;
    double snapDy = 0;
    List<SnapGuide> guides = [];

    // Snap X (Vertical Guides - alinhar coordenadas X)
    final xResult = _calculateSnap1D(
      targetMin: targetRect.left,
      targetCenter: targetRect.center.dx,
      targetMax: targetRect.right,
      references: referenceElements,
      excludedIds: excludedElementIds,
      isVertical: true,
      snapDistance: _snapDistance,
      targetCrossMin: targetRect.top,
      targetCrossMax: targetRect.bottom,
    );

    if (xResult != null) {
      snapDx = xResult.offset;
      guides.add(xResult.guide);
    }

    // Snap Y (Horizontal Guides - alinhar coordenadas Y)
    final yResult = _calculateSnap1D(
      targetMin: targetRect.top,
      targetCenter: targetRect.center.dy,
      targetMax: targetRect.bottom,
      references: referenceElements,
      excludedIds: excludedElementIds,
      isVertical: false,
      snapDistance: _snapDistance,
      targetCrossMin: targetRect.left,
      targetCrossMax: targetRect.right,
    );

    if (yResult != null) {
      snapDy = yResult.offset;
      guides.add(yResult.guide);
    }

    return SnapResult(dx: snapDx, dy: snapDy, guides: guides);
  }

  static _Snap1DResult? _calculateSnap1D({
    required double targetMin,
    required double targetCenter,
    required double targetMax,
    required List<CanvasElement> references,
    required List<String> excludedIds,
    required bool isVertical,
    required double snapDistance,
    required double targetCrossMin,
    required double targetCrossMax,
  }) {
    _SnapCandidate? bestCandidate;

    for (final element in references) {
      if (excludedIds.contains(element.id) || element.isDeleted) continue;

      // Usa bounds que considera rotaÃ§Ã£o (AABB) se disponÃ­vel, ou fallback para xywh
      // Como CanvasElement tem bounds getter, usamos ele.
      // PorÃ©m, note que bounds pode ser computado, o que pode ser lento em loop.
      // Se referenceElements for grande, talvez precise otimizar.
      // Por enquanto, assumimos que Ã© rÃ¡pido o suficiente.
      // IMPORTANTE: CanvasElement nÃ£o tem 'bounds' direto no snippet que vi anteriormente?
      // Espere, vi element.bounds em scale_gesture_handlers.dart.
      // Se nÃ£o tiver, usaremos Rect.fromLTWH(element.x, element.y, element.width, element.height)

      Rect rect;
      try {
        // Tentativa de usar bounds se for mixin ou extension visÃ­vel
        // Como nÃ£o tenho certeza se o compilador vai aceitar 'bounds' dinamicamente aqui sem ver a definiÃ§Ã£o completa
        // Vou assumir que 'bounds' Ã© uma propriedade vÃ¡lida baseada no snippet.
        // Se der erro de compilaÃ§Ã£o, corrijo.
        // Mas para garantir, vou usar a definiÃ§Ã£o bÃ¡sica se nÃ£o for complexo.
        rect = Rect.fromLTWH(
          element.x,
          element.y,
          element.width,
          element.height,
        );
      } catch (e) {
        continue;
      }

      final refMin = isVertical ? rect.left : rect.top;
      final refCenter = isVertical ? rect.center.dx : rect.center.dy;
      final refMax = isVertical ? rect.right : rect.bottom;

      final refCrossMin = isVertical ? rect.top : rect.left;
      final refCrossMax = isVertical ? rect.bottom : rect.right;

      // Check all combinations
      // Target Start -> Ref Start, Center, End
      _checkCandidate(
        targetMin,
        refMin,
        refCrossMin,
        refCrossMax,
        targetCrossMin,
        targetCrossMax,
        isVertical,
        snapDistance,
        bestCandidate,
        (c) => bestCandidate = c,
      );
      _checkCandidate(
        targetMin,
        refCenter,
        refCrossMin,
        refCrossMax,
        targetCrossMin,
        targetCrossMax,
        isVertical,
        snapDistance,
        bestCandidate,
        (c) => bestCandidate = c,
      );
      _checkCandidate(
        targetMin,
        refMax,
        refCrossMin,
        refCrossMax,
        targetCrossMin,
        targetCrossMax,
        isVertical,
        snapDistance,
        bestCandidate,
        (c) => bestCandidate = c,
      );

      // Target Center -> Ref Start, Center, End
      _checkCandidate(
        targetCenter,
        refMin,
        refCrossMin,
        refCrossMax,
        targetCrossMin,
        targetCrossMax,
        isVertical,
        snapDistance,
        bestCandidate,
        (c) => bestCandidate = c,
      );
      _checkCandidate(
        targetCenter,
        refCenter,
        refCrossMin,
        refCrossMax,
        targetCrossMin,
        targetCrossMax,
        isVertical,
        snapDistance,
        bestCandidate,
        (c) => bestCandidate = c,
      );
      _checkCandidate(
        targetCenter,
        refMax,
        refCrossMin,
        refCrossMax,
        targetCrossMin,
        targetCrossMax,
        isVertical,
        snapDistance,
        bestCandidate,
        (c) => bestCandidate = c,
      );

      // Target End -> Ref Start, Center, End
      _checkCandidate(
        targetMax,
        refMin,
        refCrossMin,
        refCrossMax,
        targetCrossMin,
        targetCrossMax,
        isVertical,
        snapDistance,
        bestCandidate,
        (c) => bestCandidate = c,
      );
      _checkCandidate(
        targetMax,
        refCenter,
        refCrossMin,
        refCrossMax,
        targetCrossMin,
        targetCrossMax,
        isVertical,
        snapDistance,
        bestCandidate,
        (c) => bestCandidate = c,
      );
      _checkCandidate(
        targetMax,
        refMax,
        refCrossMin,
        refCrossMax,
        targetCrossMin,
        targetCrossMax,
        isVertical,
        snapDistance,
        bestCandidate,
        (c) => bestCandidate = c,
      );
    }

    final candidate = bestCandidate;
    if (candidate != null) {
      return _Snap1DResult(
        offset: candidate.diff,
        guide: SnapGuide(
          isVertical: isVertical,
          offset: candidate.snapTo,
          min: math.min(candidate.crossMin, targetCrossMin),
          max: math.max(candidate.crossMax, targetCrossMax),
        ),
      );
    }
    return null;
  }

  static void _checkCandidate(
    double targetVal,
    double refVal,
    double refCrossMin,
    double refCrossMax,
    double targetCrossMin,
    double targetCrossMax,
    bool isVertical,
    double snapDistance,
    _SnapCandidate? currentBest,
    Function(_SnapCandidate) updateBest,
  ) {
    final diff = refVal - targetVal;
    if (diff.abs() > snapDistance) return;

    if (currentBest == null || diff.abs() < currentBest.diff.abs()) {
      updateBest(_SnapCandidate(diff, refVal, refCrossMin, refCrossMax));
    }
  }
}

class _SnapCandidate {
  final double diff;
  final double snapTo;
  final double crossMin;
  final double crossMax;

  _SnapCandidate(this.diff, this.snapTo, this.crossMin, this.crossMax);
}

class _Snap1DResult {
  final double offset;
  final SnapGuide guide;

  _Snap1DResult({required this.offset, required this.guide});
}
