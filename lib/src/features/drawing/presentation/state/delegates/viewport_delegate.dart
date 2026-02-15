import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:notexia/src/app/config/constants/app_constants.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';

class ViewportDelegate {
  const ViewportDelegate();

  CanvasState zoomIn(CanvasState state) {
    final nextZoom = (state.zoomLevel + AppConstants.zoomStep).clamp(
      AppConstants.minZoom,
      AppConstants.maxZoom,
    );
    return state.copyWith(
      transform: state.transform.copyWith(zoomLevel: nextZoom),
    );
  }

  CanvasState zoomOut(CanvasState state) {
    final nextZoom = (state.zoomLevel - AppConstants.zoomStep).clamp(
      AppConstants.minZoom,
      AppConstants.maxZoom,
    );
    return state.copyWith(
      transform: state.transform.copyWith(zoomLevel: nextZoom),
    );
  }

  CanvasState setZoom(CanvasState state, double value) {
    final nextZoom = value.clamp(AppConstants.minZoom, AppConstants.maxZoom);
    return state.copyWith(
      transform: state.transform.copyWith(zoomLevel: nextZoom),
    );
  }

  CanvasState setPanOffset(CanvasState state, Offset offset) {
    return state.copyWith(
      transform: state.transform.copyWith(panOffset: offset),
    );
  }

  CanvasState panBy(CanvasState state, Offset delta) {
    return state.copyWith(
      transform: state.transform.copyWith(
        panOffset: state.panOffset + delta,
      ),
    );
  }
}
