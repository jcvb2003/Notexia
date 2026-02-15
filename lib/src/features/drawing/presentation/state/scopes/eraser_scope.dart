import 'dart:ui';

import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/eraser_delegate.dart';

class EraserScope {
  final CanvasState Function() _getState;
  final void Function(CanvasState) _emit;
  final void Function(DrawingDocument) _saveDocument;
  final _delegate = const EraserDelegate();

  EraserScope(this._getState, this._emit, this._saveDocument);

  void setEraserMode(EraserMode mode) => _emit(
        _getState().copyWith(
          interaction: _delegate.setEraserMode(
            _getState().interaction,
            mode,
          ),
        ),
      );

  void startEraser(Offset point) => _emit(
        _getState().copyWith(
          interaction: _delegate.startEraser(
            _getState().interaction,
            point,
          ),
        ),
      );

  void updateEraserTrail(Offset point) => _emit(
        _getState().copyWith(
          interaction: _delegate.updateEraserTrail(
            _getState().interaction,
            point,
          ),
        ),
      );

  void endEraser() => _emit(
        _getState().copyWith(
          interaction: _delegate.endEraser(_getState().interaction),
        ),
      );

  void eraseElementsAtPoint(Offset worldPoint, double radius) {
    final state = _getState();
    final updatedElements = _delegate.eraseElements(
      state.document.elements,
      worldPoint,
      radius,
    );

    if (updatedElements.length == state.document.elements.length) return;

    final updatedDoc = state.document.copyWith(elements: updatedElements);
    _emit(
      state.copyWith(
        document: updatedDoc,
        interaction: state.interaction.copyWith(selectedElementIds: []),
      ),
    );
    _saveDocument(updatedDoc);
  }
}
