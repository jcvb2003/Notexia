import 'dart:ui';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/core/errors/result.dart';

class SelectionDelegate {
  const SelectionDelegate();

  Result<CanvasState> setSelectionBox(CanvasState state, Rect? rect) {
    return Result.success(state.copyWith(
      transform: state.transform.copyWith(selectionBox: rect),
    ));
  }

  Result<CanvasState> selectElementAt(CanvasState state, Offset localPosition,
      {bool isMultiSelect = false}) {
    final reversedElements = state.elements.reversed;
    String? foundId;
    for (final element in reversedElements) {
      if (element.containsPoint(localPosition)) {
        foundId = element.id;
        break;
      }
    }

    if (foundId != null) {
      if (isMultiSelect) {
        final newSelection = Set<String>.from(state.selectedElementIds);
        if (newSelection.contains(foundId)) {
          newSelection.remove(foundId);
        } else {
          newSelection.add(foundId);
        }
        return Result.success(state.copyWith(
          interaction: state.interaction.copyWith(
            selectedElementIds: newSelection,
          ),
        ));
      } else {
        if (!state.selectedElementIds.contains(foundId)) {
          return Result.success(state.copyWith(
            interaction: state.interaction.copyWith(
              selectedElementIds: {foundId},
            ),
          ));
        }
        return Result.success(state);
      }
    } else {
      if (!isMultiSelect) {
        return Result.success(state.copyWith(
          interaction: state.interaction.copyWith(selectedElementIds: {}),
        ));
      }
      return Result.success(state);
    }
  }

  Result<CanvasState> selectElementsInRect(
      CanvasState state, Rect selectionRect) {
    final selected = <String>{};
    for (final element in state.elements) {
      if (selectionRect.overlaps(element.bounds)) {
        selected.add(element.id);
      }
    }
    return Result.success(state.copyWith(
      interaction: state.interaction.copyWith(selectedElementIds: selected),
    ));
  }

  Result<CanvasState> setHoveredElement(CanvasState state, String? id) {
    return Result.success(state.copyWith(
      interaction: state.interaction.copyWith(hoveredElementId: id),
    ));
  }
}
