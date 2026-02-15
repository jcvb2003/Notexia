import 'dart:ui';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/selection_delegate.dart';

class SelectionScope {
  final CanvasState Function() _getState;
  final void Function(CanvasState) _emit;
  final _delegate = const SelectionDelegate();

  SelectionScope(this._getState, this._emit);

  void setSelectionBox(Rect? rect) =>
      _emit(_delegate.setSelectionBox(_getState(), rect));

  void setHoveredElement(String? id) =>
      _emit(_delegate.setHoveredElement(_getState(), id));

  void selectElementAt(Offset localPosition, {bool isMultiSelect = false}) {
    _emit(_delegate.selectElementAt(
      _getState(),
      localPosition,
      isMultiSelect: isMultiSelect,
    ));
  }

  void selectElementsInRect(Rect selectionRect) {
    _emit(_delegate.selectElementsInRect(_getState(), selectionRect));
  }
}
