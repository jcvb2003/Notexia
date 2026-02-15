import 'dart:ui';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/viewport_delegate.dart';

class ViewportScope {
  final CanvasState Function() _getState;
  final void Function(CanvasState) _emit;
  final _delegate = const ViewportDelegate();

  ViewportScope(this._getState, this._emit);

  void zoomIn() => _emit(_delegate.zoomIn(_getState()));

  void zoomOut() => _emit(_delegate.zoomOut(_getState()));

  void setZoom(double value) => _emit(_delegate.setZoom(_getState(), value));

  void setPanOffset(Offset offset) =>
      _emit(_delegate.setPanOffset(_getState(), offset));

  void panBy(Offset delta) => _emit(_delegate.panBy(_getState(), delta));
}
