import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:notexia/src/features/drawing/domain/services/object_snap_service.dart';
import 'package:notexia/src/features/drawing/presentation/inputs/middleware/input_event.dart';
import 'package:notexia/src/features/drawing/presentation/inputs/middleware/input_pipeline.dart';

class SnappingMiddleware implements InputMiddleware {
  @override
  void handle(InputEvent event, void Function(InputEvent) next) {
    if (event is ScaleUpdateInputEvent) {
      _handleScaleUpdate(event);
    }
    next(event);
  }

  void _handleScaleUpdate(ScaleUpdateInputEvent event) {
    if (!event.isDraggingSelection) return;

    final isShift = _isShiftPressed();
    final isSnapEnabled = event.state.isAngleSnapEnabled;

    if (isShift || isSnapEnabled) {
      final selectedIds = event.state.selectedElementIds;
      final elements = event.state.elements;
      final selectedElements = elements
          .where((e) => selectedIds.contains(e.id))
          .toList();

      if (selectedElements.isNotEmpty) {
        double minX = double.infinity, minY = double.infinity;
        double maxX = double.negativeInfinity, maxY = double.negativeInfinity;

        for (final el in selectedElements) {
          minX = math.min(minX, el.x);
          minY = math.min(minY, el.y);
          maxX = math.max(maxX, el.x + el.width);
          maxY = math.max(maxY, el.y + el.height);
        }

        final currentRect = Rect.fromLTRB(minX, minY, maxX, maxY);
        final targetRect = currentRect.shift(event.worldFocalDelta);

        final snapResult = ObjectSnapService.snapMove(
          targetRect: targetRect,
          referenceElements: elements,
          excludedElementIds: selectedIds,
        );

        if (snapResult.hasSnap) {
          event.worldFocalDelta += Offset(snapResult.dx, snapResult.dy);
        }
      }
    }
  }

  bool _isShiftPressed() {
    return HardwareKeyboard.instance.logicalKeysPressed.contains(
          LogicalKeyboardKey.shiftLeft,
        ) ||
        HardwareKeyboard.instance.logicalKeysPressed.contains(
          LogicalKeyboardKey.shiftRight,
        );
  }
}
