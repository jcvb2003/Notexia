import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';

/// Serviço de snap-to-grid geométrico.
///
/// Quando ativo, SEMPRE alinha ao grid mais próximo (snap hard).
/// A decisão de ativar/desativar fica no state (`isGridSnapEnabled`).
class GridSnapService {
  /// Calcula o delta para alinhar o canto top-left de [rect] ao grid.
  ///
  /// Grid snap é "hard": sempre snapeia ao ponto mais próximo.
  /// Retorna [SnapResult] com guides para renderização.
  static SnapResult snapRectToGrid({
    required Rect rect,
    required double gridSize,
  }) {
    if (gridSize <= 0) return const SnapResult();

    final snappedX = (rect.left / gridSize).roundToDouble() * gridSize;
    final snappedY = (rect.top / gridSize).roundToDouble() * gridSize;

    final dx = snappedX - rect.left;
    final dy = snappedY - rect.top;

    // Se já está no grid, não precisa de snap
    if (dx == 0 && dy == 0) return const SnapResult();

    final guides = <SnapGuide>[];

    if (dx != 0) {
      guides.add(SnapGuide(
        isVertical: true,
        offset: snappedX,
        min: rect.top + dy,
        max: rect.bottom + dy,
        type: SnapGuideType.grid,
      ));
    }

    if (dy != 0) {
      guides.add(SnapGuide(
        isVertical: false,
        offset: snappedY,
        min: rect.left + dx,
        max: rect.right + dx,
        type: SnapGuideType.grid,
      ));
    }

    return SnapResult(
      dx: dx,
      dy: dy,
      guides: guides,
    );
  }
}
