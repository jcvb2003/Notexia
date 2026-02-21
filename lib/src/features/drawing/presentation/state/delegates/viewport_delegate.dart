import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:notexia/src/app/config/constants/app_constants.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/core/errors/result.dart';

class ViewportDelegate {
  const ViewportDelegate();

  Result<CanvasState> zoomIn(CanvasState state) {
    final nextZoom = (state.zoomLevel + AppConstants.zoomStep).clamp(
      AppConstants.minZoom,
      AppConstants.maxZoom,
    );
    return Result.success(state.copyWith(
      transform: state.transform.copyWith(zoomLevel: nextZoom),
    ));
  }

  Result<CanvasState> zoomOut(CanvasState state) {
    final nextZoom = (state.zoomLevel - AppConstants.zoomStep).clamp(
      AppConstants.minZoom,
      AppConstants.maxZoom,
    );
    return Result.success(state.copyWith(
      transform: state.transform.copyWith(zoomLevel: nextZoom),
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
}
