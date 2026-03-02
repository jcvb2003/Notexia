import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';

class ObjectSnapService {
  static const double _snapDistance = 8.0;

  static SnapResult snapMove({
    required Rect targetRect,
    required List<CanvasElement> referenceElements,
    required Set<String> excludedElementIds,
    double zoomLevel = 1.0,
  }) {
    final adaptiveSnapDistance = _snapDistance / zoomLevel;
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
      snapDistance: adaptiveSnapDistance,
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
      snapDistance: adaptiveSnapDistance,
      targetCrossMin: targetRect.left,
      targetCrossMax: targetRect.right,
    );

    if (yResult != null) {
      snapDy = yResult.offset;
      guides.add(yResult.guide);
    }

    // Gap snap (espaçamento igual entre 3+ elementos)
    final gapResult = _calculateGapSnap(
      targetRect: targetRect,
      references: referenceElements,
      excludedIds: excludedElementIds,
      snapDistance: adaptiveSnapDistance,
    );

    // Gap snap substitui alignment snap no eixo correspondente
    // se não houve alignment snap nesse eixo
    if (gapResult != null) {
      if (gapResult.isHorizontal && snapDx == 0) {
        snapDx = gapResult.dx;
        guides.addAll(gapResult.guides);
      }
      if (gapResult.isVertical && snapDy == 0) {
        snapDy = gapResult.dy;
        guides.addAll(gapResult.guides);
      }
    }

    return SnapResult(dx: snapDx, dy: snapDy, guides: guides);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Gap Snap
  // ───────────────────────────────────────────────────────────────────────────

  static _GapSnapResult? _calculateGapSnap({
    required Rect targetRect,
    required List<CanvasElement> references,
    required Set<String> excludedIds,
    required double snapDistance,
  }) {
    final refRects = <Rect>[];
    for (final el in references) {
      if (excludedIds.contains(el.id) || el.isDeleted) continue;
      refRects.add(Rect.fromLTWH(el.x, el.y, el.width, el.height));
    }

    if (refRects.length < 2) return null;

    _GapSnapResult? best;

    // Tentar gap snap horizontal (elementos lado a lado no eixo X)
    final hResult = _tryGapAxis(
      targetRect: targetRect,
      refRects: refRects,
      isHorizontal: true,
      snapDistance: snapDistance,
    );
    if (hResult != null) best = hResult;

    // Tentar gap snap vertical (elementos empilhados no eixo Y)
    final vResult = _tryGapAxis(
      targetRect: targetRect,
      refRects: refRects,
      isHorizontal: false,
      snapDistance: snapDistance,
    );

    if (vResult != null) {
      if (best == null || vResult.score < best.score) {
        best = vResult;
      }
    }

    return best;
  }

  static _GapSnapResult? _tryGapAxis({
    required Rect targetRect,
    required List<Rect> refRects,
    required bool isHorizontal,
    required double snapDistance,
  }) {
    // Ordena refs pelo eixo principal
    final sorted = List<Rect>.from(refRects);
    sorted.sort((a, b) =>
        isHorizontal ? a.left.compareTo(b.left) : a.top.compareTo(b.top));

    _GapSnapResult? best;

    // Para cada par consecutivo, verificar se o target pode ficar
    // com gap igual entre eles
    for (int i = 0; i < sorted.length - 1; i++) {
      final a = sorted[i];
      final b = sorted[i + 1];

      // Gap entre A e B
      final gapAB = isHorizontal ? b.left - a.right : b.top - a.bottom;

      if (gapAB <= 0) continue; // Elementos sobrepostos

      // Posição ideal para gap igual antes de A
      final snapBeforeA = isHorizontal
          ? a.left - gapAB - targetRect.width
          : a.top - gapAB - targetRect.height;
      final dxBefore = isHorizontal ? snapBeforeA - targetRect.left : 0.0;
      final dyBefore = isHorizontal ? 0.0 : snapBeforeA - targetRect.top;

      if ((isHorizontal ? dxBefore : dyBefore).abs() < snapDistance) {
        final score = (isHorizontal ? dxBefore : dyBefore).abs();
        if (best == null || score < best.score) {
          best = _GapSnapResult(
            dx: dxBefore,
            dy: dyBefore,
            isHorizontal: isHorizontal,
            isVertical: !isHorizontal,
            score: score,
            guides: _buildGapGuides(
              targetRect.shift(Offset(dxBefore, dyBefore)),
              a,
              b,
              gapAB,
              isHorizontal,
            ),
          );
        }
      }

      // Posição ideal para gap igual depois de B
      final snapAfterB = isHorizontal ? b.right + gapAB : b.bottom + gapAB;
      final dxAfter = isHorizontal ? snapAfterB - targetRect.left : 0.0;
      final dyAfter = isHorizontal ? 0.0 : snapAfterB - targetRect.top;

      if ((isHorizontal ? dxAfter : dyAfter).abs() < snapDistance) {
        final score = (isHorizontal ? dxAfter : dyAfter).abs();
        if (best == null || score < best.score) {
          best = _GapSnapResult(
            dx: dxAfter,
            dy: dyAfter,
            isHorizontal: isHorizontal,
            isVertical: !isHorizontal,
            score: score,
            guides: _buildGapGuides(
              targetRect.shift(Offset(dxAfter, dyAfter)),
              a,
              b,
              gapAB,
              isHorizontal,
            ),
          );
        }
      }

      // Posição ideal para gap igual entre A e B
      final totalSpace = isHorizontal ? b.left - a.right : b.top - a.bottom;
      final targetSize = isHorizontal ? targetRect.width : targetRect.height;
      final idealGap = (totalSpace - targetSize) / 2;

      if (idealGap > 0) {
        final snapBetween =
            isHorizontal ? a.right + idealGap : a.bottom + idealGap;
        final dxBetween = isHorizontal ? snapBetween - targetRect.left : 0.0;
        final dyBetween = isHorizontal ? 0.0 : snapBetween - targetRect.top;

        if ((isHorizontal ? dxBetween : dyBetween).abs() < snapDistance) {
          final score = (isHorizontal ? dxBetween : dyBetween).abs();
          if (best == null || score < best.score) {
            best = _GapSnapResult(
              dx: dxBetween,
              dy: dyBetween,
              isHorizontal: isHorizontal,
              isVertical: !isHorizontal,
              score: score,
              guides: _buildGapGuides(
                targetRect.shift(Offset(dxBetween, dyBetween)),
                a,
                b,
                idealGap,
                isHorizontal,
              ),
            );
          }
        }
      }
    }

    return best;
  }

  static List<SnapGuide> _buildGapGuides(
    Rect target,
    Rect a,
    Rect b,
    double gapValue,
    bool isHorizontal,
  ) {
    final guides = <SnapGuide>[];
    final roundedGap = (gapValue * 10).roundToDouble() / 10;

    if (isHorizontal) {
      final crossMid = (math.max(target.top, math.max(a.top, b.top)) +
              math.min(target.bottom, math.min(a.bottom, b.bottom))) /
          2;

      // Guide entre A e target (se target está entre A e B)
      if (target.left > a.right && target.right < b.left) {
        guides.add(SnapGuide(
          isVertical: false,
          offset: crossMid,
          min: a.right,
          max: target.left,
          type: SnapGuideType.gap,
          gapValue: roundedGap,
        ));
        guides.add(SnapGuide(
          isVertical: false,
          offset: crossMid,
          min: target.right,
          max: b.left,
          type: SnapGuideType.gap,
          gapValue: roundedGap,
        ));
      } else if (target.right <= a.left) {
        // Target antes de A
        guides.add(SnapGuide(
          isVertical: false,
          offset: crossMid,
          min: target.right,
          max: a.left,
          type: SnapGuideType.gap,
          gapValue: roundedGap,
        ));
        guides.add(SnapGuide(
          isVertical: false,
          offset: crossMid,
          min: a.right,
          max: b.left,
          type: SnapGuideType.gap,
          gapValue: roundedGap,
        ));
      } else {
        // Target depois de B
        guides.add(SnapGuide(
          isVertical: false,
          offset: crossMid,
          min: a.right,
          max: b.left,
          type: SnapGuideType.gap,
          gapValue: roundedGap,
        ));
        guides.add(SnapGuide(
          isVertical: false,
          offset: crossMid,
          min: b.right,
          max: target.left,
          type: SnapGuideType.gap,
          gapValue: roundedGap,
        ));
      }
    } else {
      final crossMid = (math.max(target.left, math.max(a.left, b.left)) +
              math.min(target.right, math.min(a.right, b.right))) /
          2;

      if (target.top > a.bottom && target.bottom < b.top) {
        guides.add(SnapGuide(
          isVertical: true,
          offset: crossMid,
          min: a.bottom,
          max: target.top,
          type: SnapGuideType.gap,
          gapValue: roundedGap,
        ));
        guides.add(SnapGuide(
          isVertical: true,
          offset: crossMid,
          min: target.bottom,
          max: b.top,
          type: SnapGuideType.gap,
          gapValue: roundedGap,
        ));
      } else if (target.bottom <= a.top) {
        guides.add(SnapGuide(
          isVertical: true,
          offset: crossMid,
          min: target.bottom,
          max: a.top,
          type: SnapGuideType.gap,
          gapValue: roundedGap,
        ));
        guides.add(SnapGuide(
          isVertical: true,
          offset: crossMid,
          min: a.bottom,
          max: b.top,
          type: SnapGuideType.gap,
          gapValue: roundedGap,
        ));
      } else {
        guides.add(SnapGuide(
          isVertical: true,
          offset: crossMid,
          min: a.bottom,
          max: b.top,
          type: SnapGuideType.gap,
          gapValue: roundedGap,
        ));
        guides.add(SnapGuide(
          isVertical: true,
          offset: crossMid,
          min: b.bottom,
          max: target.top,
          type: SnapGuideType.gap,
          gapValue: roundedGap,
        ));
      }
    }

    return guides;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Alignment Snap 1D
  // ───────────────────────────────────────────────────────────────────────────

  static _Snap1DResult? _calculateSnap1D({
    required double targetMin,
    required double targetCenter,
    required double targetMax,
    required List<CanvasElement> references,
    required Set<String> excludedIds,
    required bool isVertical,
    required double snapDistance,
    required double targetCrossMin,
    required double targetCrossMax,
  }) {
    _SnapCandidate? bestCandidate;

    for (final element in references) {
      if (excludedIds.contains(element.id) || element.isDeleted) continue;

      final rect = Rect.fromLTWH(
        element.x,
        element.y,
        element.width,
        element.height,
      );

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

class _GapSnapResult {
  final double dx;
  final double dy;
  final bool isHorizontal;
  final bool isVertical;
  final double score;
  final List<SnapGuide> guides;

  _GapSnapResult({
    required this.dx,
    required this.dy,
    required this.isHorizontal,
    required this.isVertical,
    required this.score,
    required this.guides,
  });
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
