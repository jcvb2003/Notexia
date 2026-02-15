import 'dart:ui';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';

class EraserDelegate {
  const EraserDelegate();

  InteractionState setEraserMode(InteractionState state, EraserMode mode) {
    return state.copyWith(
      eraser: state.eraser.copyWith(mode: mode),
    );
  }

  InteractionState startEraser(InteractionState state, Offset point) {
    return state.copyWith(
      eraser: state.eraser.copyWith(
        isActive: true,
        trail: [point],
      ),
    );
  }

  InteractionState updateEraserTrail(InteractionState state, Offset point) {
    final updated = List<Offset>.from(state.eraser.trail)..add(point);
    if (updated.length > 24) {
      updated.removeRange(0, updated.length - 24);
    }
    return state.copyWith(
      eraser: state.eraser.copyWith(
        trail: updated,
        isActive: true,
      ),
    );
  }

  InteractionState endEraser(InteractionState state) {
    return state.copyWith(
      eraser: state.eraser.copyWith(
        isActive: false,
        trail: const [],
      ),
    );
  }

  List<CanvasElement> eraseElements(
    List<CanvasElement> elements,
    Offset worldPoint,
    double radius,
  ) {
    return elements.where((element) {
      final inflated = element.bounds.inflate(radius);
      return !inflated.contains(worldPoint);
    }).toList();
  }
}
