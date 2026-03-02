import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:notexia/src/app/config/constants/app_constants.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/core/errors/result.dart';

class ViewportDelegate {
  const ViewportDelegate();

  Result<CanvasState> zoomIn(CanvasState state, [Offset? screenCenter]) {
    final nextZoom = (state.zoomLevel + AppConstants.zoomStep).clamp(
      AppConstants.minZoom,
      AppConstants.maxZoom,
    );
    if (screenCenter != null) {
      final worldPoint = (screenCenter - state.panOffset) / state.zoomLevel;
      final nextPan = screenCenter - (worldPoint * nextZoom);
      return Result.success(state.copyWith(
        transform: state.transform.copyWith(
          zoomLevel: nextZoom,
          panOffset: nextPan,
        ),
      ));
    }
    return Result.success(state.copyWith(
      transform: state.transform.copyWith(zoomLevel: nextZoom),
    ));
  }

  Result<CanvasState> zoomOut(CanvasState state, [Offset? screenCenter]) {
    final nextZoom = (state.zoomLevel - AppConstants.zoomStep).clamp(
      AppConstants.minZoom,
      AppConstants.maxZoom,
    );
    if (screenCenter != null) {
      final worldPoint = (screenCenter - state.panOffset) / state.zoomLevel;
      final nextPan = screenCenter - (worldPoint * nextZoom);
      return Result.success(state.copyWith(
        transform: state.transform.copyWith(
          zoomLevel: nextZoom,
          panOffset: nextPan,
        ),
      ));
    }
    return Result.success(state.copyWith(
      transform: state.transform.copyWith(zoomLevel: nextZoom),
    ));
  }

  Result<CanvasState> setZoomAtPoint(
      CanvasState state, double nextZoom, Offset nextPan) {
    final clamped = nextZoom.clamp(AppConstants.minZoom, AppConstants.maxZoom);
    return Result.success(state.copyWith(
      transform: state.transform.copyWith(
        zoomLevel: clamped,
        panOffset: nextPan,
      ),
    ));
  }

  Result<CanvasState> setZoom(CanvasState state, double value) {
    final nextZoom = value.clamp(AppConstants.minZoom, AppConstants.maxZoom);
    return Result.success(state.copyWith(
      transform: state.transform.copyWith(zoomLevel: nextZoom),
    ));
  }

  Result<CanvasState> setPanOffset(CanvasState state, Offset offset) {
    return Result.success(state.copyWith(
      transform: state.transform.copyWith(panOffset: offset),
    ));
  }

  Result<CanvasState> panBy(CanvasState state, Offset delta) {
    return Result.success(state.copyWith(
      transform: state.transform.copyWith(
        panOffset: state.panOffset + delta,
      ),
    ));
  }

  Result<CanvasState> resetViewport(CanvasState state) {
    return Result.success(state.copyWith(
      transform: const CanvasTransform(
        zoomLevel: 1.0,
        panOffset: Offset.zero,
      ),
    ));
  }

  Result<CanvasState> centerSelection(CanvasState state) {
    if (state.selectedElementIds.isEmpty) return Result.success(state);

    final selectedElements = state.elements
        .where((e) => state.selectedElementIds.contains(e.id))
        .toList();

    if (selectedElements.isEmpty) return Result.success(state);

    Rect? combinedBounds;
    for (final element in selectedElements) {
      if (combinedBounds == null) {
        combinedBounds = element.bounds;
      } else {
        combinedBounds = combinedBounds.expandToInclude(element.bounds);
      }
    }

    if (combinedBounds == null) return Result.success(state);

    // Simplificado: apenas centraliza o pan no meio da seleção com zoom atual.
    // Em uma implementação real, poderíamos ajustar o zoom para caber na tela.
    final center = combinedBounds.center;
    // centralizado na tela (assumindo tamanho padrão de exemplo ou mantendo zoom)
    // Para simplificar agora e resolver o erro de compilação:
    return Result.success(state.copyWith(
      transform: state.transform.copyWith(
        panOffset: Offset.zero - (center * state.zoomLevel),
      ),
    ));
  }
}
