import 'dart:ui';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/core/errors/result.dart';

class EraserDelegate {
  const EraserDelegate();

  Result<InteractionState> setEraserMode(
      InteractionState state, EraserMode mode) {
    return Result.success(state.copyWith(
      eraser: state.eraser.copyWith(mode: mode),
    ));
  }

  Result<InteractionState> startEraser(InteractionState state, Offset point) {
    return Result.success(state.copyWith(
      eraser: state.eraser.copyWith(
        isActive: true,
        trail: [point],
      ),
    ));
  }

  Result<InteractionState> updateEraserTrail(
      InteractionState state, Offset point) {
    final updated = List<Offset>.from(state.eraser.trail)..add(point);
    if (updated.length > 24) {
      updated.removeRange(0, updated.length - 24);
    }
    return Result.success(state.copyWith(
      eraser: state.eraser.copyWith(
        trail: updated,
        isActive: true,
      ),
    ));
  }

  Result<InteractionState> endEraser(InteractionState state) {
    return Result.success(state.copyWith(
      eraser: state.eraser.copyWith(
        isActive: false,
        trail: const [],
      ),
    ));
  }

  Result<List<CanvasElement>> eraseElements(
    List<CanvasElement> elements,
    Offset worldPoint,
    double radius,
  ) {
    final result = elements.where((element) {
      final inflated = element.bounds.inflate(radius);
      return !inflated.contains(worldPoint);
    }).toList();
    return Result.success(result);
  }
}
